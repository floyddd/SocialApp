//
//  FacebookViewController.m
//  SocialApp
//
//  Created by MokshaX on 8/12/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookViewController.h"
#import <Social/Social.h>

@interface FacebookViewController ()
- (IBAction)btnPostStatus:(id)sender;
- (IBAction)btnPostPhoto:(id)sender;


@end

@implementation FacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //FBLoginView *loginView = [[FBLoginView alloc] initWithFrame:CGRectMake(13, 347, self.view.bounds.size.width - 38, 8)];
    //loginView.delegate = self;
   // [self.view addSubview:loginView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        
                        NSLog(@"In fallback handler");
                    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPostStatus:(id)sender {


if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    
    [self presentViewController:controller animated:YES completion:Nil];
} else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Alert"
                                                    message:@"Log in to Facebook via Settings of your iPhone to access the sharing feature!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
}

- (IBAction)btnPostPhoto:(id)sender {
    
    

}
@end
