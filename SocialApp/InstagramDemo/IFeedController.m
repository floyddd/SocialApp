//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "IFeedItem.h"
#import "IFeedStore.h"
#import <QuartzCore/QuartzCore.h>
#import "IFeedController.h"
#import "IAuthentificator.h"


#define REFRESH_HEADER_HEIGHT 52.0f //задаем высоту ячейки "pull-to-refresh"

@implementation IFeedController{
    UIBarButtonItem *logoutButton ;
    
}
@synthesize feedTable,helloView,accessToken,image,items,textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


//загружаем приветствующее view, если токен = 0

-(void)loadHelloView

{
    
    //CGRect helloFrame = [[UIScreen mainScreen]bounds];
    //    helloView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 499, 499)];
    //
    //    CGRect imageVIew =[[UIScreen mainScreen]bounds];
    //    image = [[UIImageView alloc]initWithFrame:imageVIew];
    //    [image setImage:[UIImage imageNamed:@"insta3.jpg"]];
    //    [[self helloView]addSubview:image];
    
    CGRect ma = CGRectMake(10, 300, 100, 30);
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:ma];
    [but setTitle:@"Login" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor whiteColor]];
    but.titleLabel.font =[ UIFont fontWithName:@"Arial" size:20];
    but.titleLabel.textColor = [UIColor blackColor];
    [[but layer]setBorderWidth:2];
    
    [but addTarget:self action:@selector(openLoginView:) forControlEvents:UIControlEventTouchUpInside];
    [helloView addSubview:but];
    [[self view]addSubview:helloView];
    
    
    
    
}
-(void)aMethod:(id)sender {
    [self performSegueWithIdentifier:@"back" sender:sender];
}
// загружаем основное табличное view. если токен = 0, показываем окно приветствия
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(void)viewDidLoad

{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"335466"];
    
    
    
    accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (!accessToken) {
        
        [self openLoginView:self];
        
    }
    else{
        logoutButton= [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        [[self navigationItem]setRightBarButtonItem:logoutButton];
        logoutButton.tintColor=[UIColor whiteColor];
    }
    
    [UIView commitAnimations];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    
    
    
    left.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=left;
    
    
    
    [left setTarget: self.revealViewController];
    [left setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    
    CGRect tableFrame = [[UIScreen mainScreen]bounds];
    feedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, tableFrame.size.width, tableFrame.size.height-40) style:UITableViewStylePlain];
    [[self view]addSubview:feedTable];
    [[self feedTable]setDelegate:self];
    
    // logoutButton= [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    // [[self navigationItem]setRightBarButtonItem:logoutButton];
    [[self navigationItem]setTitle:@"Instagram"];
    [feedTable setDataSource:self];
    
    
    
    [[self view]bringSubviewToFront:helloView];
    [feedTable setRowHeight:440];
    [feedTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // [[self navigationController]setNavigationBarHidden:NO];
    
  
    
    //нет токена - предлагаем автоиризироваться
    if (!accessToken)
    {
        [self loadHelloView];
    }
    else
    {
        [self askStoreToLoadData]; //иначе наполняем таблицу
    }
    
    
}

//создаем "pull-to-refresh" и описываем его логику



//выходим. отправляем пользователя разлогиниться и удаляем токен

-(void)logout:(id)sender

{
    
    self.feedTable.dataSource=nil;
    [self.feedTable reloadData];
    
    
    logoutButton.title=@"";
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
    //                                                    message:@"Logged out."
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"OK"
    //                                          otherButtonTitles:nil];
    //    [alert show];
    
    [self openLoginView:self];
    
    NSURL *url = [[NSURL alloc]initWithString:@"http://instagram.com/accounts/logout/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    [con start];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selfUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    accessToken = nil;
    ShowNetworkActivityIndicator();
}

-(void)viewDidUnload
{
    feedTable = nil;
    image = nil;
    helloView = nil;
    refreshSpinner = nil;
    refreshArrow = nil;
    refreshHeaderView = nil;
}

//получив ответ об успешном логауте, показываем окно авторизации

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self loadHelloView];
    HideNetworkActivityIndicator();
    
}

//отправляем запрос синглтону на загрузку данных

-(void)askStoreToLoadData

{
    ShowNetworkActivityIndicator();
    [[IFeedStore sharedFeedStore] loadUsersFeed:^(NSArray *array, NSError *error)
     
     {
         
         if(error)
         {
             UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             
             [av show];
             
             HideNetworkActivityIndicator();
         }
         else
         {
             //обновляем данные и перезагружаем таблицу
             
             
             items = array;
             HideNetworkActivityIndicator();
             [feedTable reloadData];
             
             
         }
         
     }];
    
}


//открываем окно авторизации

-(void)openLoginView:(id)sender

{
    ShowNetworkActivityIndicator();
    IAuthentificator *iAuth = [[IAuthentificator alloc]init];
    [iAuth setIDelegate:self];
    
    [self presentViewController:iAuth animated:YES completion:^{}];
    
}

// стандартные методы делегата таблицы

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IFeedCell *cell = (IFeedCell*)[tableView dequeueReusableCellWithIdentifier:@"IFeedCell"];
    
    if(!cell)
        
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IFeedCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
    }
    
    IFeedItem *tut = [items objectAtIndex:[indexPath row]];
    

    [[cell ownerName]setText:tut.imageOwnerNickname];
    [[cell time]setText:[NSString stringWithFormat:@"%@",tut.timeFromRelease]];
    [[cell likesCount]setText:[NSString stringWithFormat:@"%i likes",tut.likeCount]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell ownerPhoto]setImageWithURL:tut.avatarImageURL];
    [[cell iPhoto]setImageWithURL:tut.imageUrl];
    
    //в зависимости от статуса лайка обновляем изображение на кнопке
    
 
    
    return cell;
}

//открываем комментарии (work in progress)


//отправляем лайк или удаляем его



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 440;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [items count];
}


//проверка авторизации, успех = убираем окно авторизации и перезагружаем таблицу

-(void)didAuth:(NSMutableString *)token
{
    logoutButton= [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    logoutButton.tintColor=[UIColor whiteColor];
    [[self navigationItem]setRightBarButtonItem:logoutButton];
    HideNetworkActivityIndicator();
    image = nil;
    [helloView removeFromSuperview];
    helloView = nil;
    // [[self navigationController]setNavigationBarHidden:NO];
    [self askStoreToLoadData];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    
}

@end
