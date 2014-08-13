//
//  IAuthentificator.h
//  InstagramDemo
//

//  Copyright (c) Nexitusor. All rights reserved.
//

////////////////ВНИМАНИЕ!///////////
//Перед началом использования заменить scope,callbackURL,clientID,clientSecret на свои 

#import <Foundation/Foundation.h>

#define scope @"basic+likes+comments+relationships"
#define callbackURL @"http://rnc.com.np"
#define clientID @"8e067e0922994ad192413d48c83571ba"
#define clientSecret @"a4e72f404d134eabb0c2a3c67364a1bd"

#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES

@protocol InstagramAuth <NSObject>
-(void) didAuth:(NSMutableString*)token;
@end


@interface IAuthentificator : UIViewController <UIWebViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

{
    NSMutableString *accessToken;
    UIWebView *webView;
    NSURLConnection *connection;
    NSMutableData *mdata;
   __weak id<InstagramAuth>iDelegate;
    
}
@property (nonatomic,strong) NSMutableString *accessToken;
@property (nonatomic,readonly) UIWebView *webView;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *mdata;
@property (nonatomic,weak) id<InstagramAuth>iDelegate;



@end

