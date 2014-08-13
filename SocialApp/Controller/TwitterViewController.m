//
//  TwitterViewController.m
//  SocialApp
//
//  Created by MokshaX on 8/12/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import "NetworkActivity.h"
#import <Social/Social.h>
#import "TwitterViewController.h"
#import <Accounts/Accounts.h>
@interface TwitterViewController ()
- (IBAction)btnPostTweet:(id)sender;

- (IBAction)btnPostPhoto:(id)sender;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation TwitterViewController
- (void) awakeFromNib
{
    // CREATE ACCOUNT STORE
    self.accountStore = [[ACAccountStore alloc] init];
}

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btnPostTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];

        [self presentViewController:tweetSheet animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Login Alert"
                                                        message:@"Log in to Twitter via Settings of your iPhone to access the sharing feature!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (IBAction)btnPostPhoto:(id)sender {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // POST IMAGE
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.imagePickerController dismissViewControllerAnimated:FALSE completion:^{
        
        // 1. SLRequest
        [self postImage:image withStatus:@""];
        
        /*
         // 2. SLComposeView
         if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
         {
         SLComposeViewController *twController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
         
         
         [twController addImage:image];
         
         [self presentViewController:twController animated:YES completion:^{
         NSLog(@"Tweet sheet has been presented.");
         }];
         
         }
         else {
         NSLog(@"Twitter not available");
         }
         */
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// POST IMAGE FUNCTION
- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    if ([self userHasAccessToTwitter]) {
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        
       // [[UIApplication sharedApplication] showNetworkActivityIndicator];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/update_with_media.json"];
                 NSDictionary *params = @{@"status" : status};
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                         requestMethod:SLRequestMethodPOST
                                                                   URL:url
                                                            parameters:params];
                 NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
                 [request addMultipartData:imageData
                                  withName:@"media[]"
                                      type:@"image/jpeg"
                                  filename:@"image.jpg"];
                 
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 NSLog(@"Start sending image!!");
                 
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     
                     [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                     
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *jsonData = [NSJSONSerialization
                                                       JSONObjectWithData:responseData
                                                       options:NSJSONReadingAllowFragments
                                                       error:&jsonError];
                             
                             if (jsonData) {
                                 NSLog(@"Tweet sent!!");
                                 [self showStatus:@"Your tweet is sent !" withTitle:@"Success"];
                             }
                             else {
                                 [self showStatus:@"Something is wrong" withTitle:@"Failed"];
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             [self showStatus:@"Something is wrong" withTitle:@"Failed"];
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
    else {
        NSLog(@"No twitter access");
    }
    
}
- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)showStatus:(NSString *)status withTitle:(NSString*) title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                        message: status
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    });
    
}
@end
