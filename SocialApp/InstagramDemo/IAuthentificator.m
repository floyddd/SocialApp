//
//  IAuthentificator.m
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//

#import "IAuthentificator.h"

@implementation IAuthentificator
@synthesize accessToken,webView,code,connection,mdata,iDelegate;

-(void)loadView

{

}

//показываем UIWebView

-(void)viewDidLoad

{
    CGRect webFrame = [[UIScreen mainScreen]applicationFrame];
    webView = [[UIWebView alloc]initWithFrame:webFrame];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
    [self setView:webView];

    //UINavigationBar *headerView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    //The UINavigationItem is neede as a "box" that holds the Buttons or other elements
 //   UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@"Login"];
    
    //Creating some buttons:
   
    UIButton *barDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 420, 320, 60)];
    [barDoneButton addTarget:self action:@selector(signInDonePressed) forControlEvents:UIControlEventTouchUpInside];
    //Putting the Buttons on the Carrier
    barDoneButton.backgroundColor=[UIColor lightGrayColor];
    [barDoneButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  //  [self.view addSubview:barDoneButton];
  //  [buttonCarrier setRightBarButtonItem:barDoneButton];
    
    //The NavigationBar accepts those "Carrier" (UINavigationItem) inside an Array
    //NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    
    // Attaching the Array to the NavigationBar
  //  [headerView setItems:barItemArray];
    //[self.view addSubview:headerView];
    
    if([clientID isEqualToString:@"YOUR CLIENT ID"]|[callbackURL isEqualToString:@"YOUR CALLBACK URL"]|[clientSecret isEqualToString:@"YOUR  CLIENT SECRET"])
    {
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"Error" message:@"change your callback url, secret id or client id to yours" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alview show];
        HideNetworkActivityIndicator();
    }
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&display=touch&scope=%@&redirect_uri=%@&response_type=code",clientID,scope,callbackURL]];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:req];
    mdata = [NSMutableData data];
}
-(void)signInDonePressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//загружаем окно авторизации, заходим под своим логином

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    webView.frame=CGRectMake(0, 20, 320, 500);
    NSString *currentUrl = [[request URL]absoluteString];
    NSString *prefix = [NSString stringWithFormat:@"%@/?code=",callbackURL];
    
    if([currentUrl hasPrefix:prefix])
    {
        code = [currentUrl substringFromIndex:[prefix length]];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:15.0];
        [request setHTTPMethod:@"POST"];
        NSString* params = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",clientID,clientSecret,callbackURL,code];
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        
        self.connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        ShowNetworkActivityIndicator();
        return NO;
        
    }
//нужно добавить поведение в ситуациях, если инстаграм висит, пользователь забыл пароль и т.д. Остановить или запретить загрузку

    return YES;
    
    
    
    
}

//прячем индикатор активности, когда загрузка завершена

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    HideNetworkActivityIndicator();
}

// сохраняем загруженные данные

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [mdata appendData:data];
}

//останавливаем загрузку, если произошла ошибка

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    self.connection =nil;
    mdata = nil;
    
}

//парсим полученные json-данные, берем токен и свой id. Отправляем ответ табличному контроллеру об успешной загрузке 

-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    NSError *jsonError = nil;
    
    id jsonData = [NSJSONSerialization JSONObjectWithData:self.mdata options:0 error:&jsonError];
    if(jsonData && [NSJSONSerialization isValidJSONObject:jsonData])
        
    {
        accessToken = [jsonData objectForKey:@"access_token"];
        NSString *userID= [jsonData valueForKeyPath:@"user.id"];
        
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:userID forKey:@"selfUserID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SEL select = @selector(didAuth:);
        if (iDelegate && [iDelegate respondsToSelector:select])
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [iDelegate performSelector:select withObject:accessToken];
            #pragma clang diagnostic pop
        }
    }
}

-(void)viewDidUnload
{
    connection = nil;
    mdata = nil;
    code = nil;
    accessToken = nil;
    webView = nil;
}

@end
