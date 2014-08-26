//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#import "NSDate+PrettyDate.h"
#import "AFNetworking.h"
#import "TweetTableViewCell.h"
#import "SWRevealViewController.h"
#import "STTwitter.h"
#import "NetworkActivity.h"
#import <Social/Social.h>
#import "TwitterViewController.h"
#import <Accounts/Accounts.h>
@interface TwitterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)btnPostTweet:(id)sender;
@property (nonatomic, strong) STTwitterAPI *twitter;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSArray *statuses;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation TwitterViewController
- (void) awakeFromNib
{
    // CREATE ACCOUNT STORE
    self.accountStore = [[ACAccountStore alloc] init];
}
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

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        
        
        
        /*
         At this point, the user can use the API and you can read his access tokens with:
         
         _twitter.oauthAccessToken;
         _twitter.oauthAccessTokenSecret;
         
         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
         
         Next time, just instanciate STTwitter with the class method:
         
         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
         
         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
         */
        
    } errorBlock:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getTImeline{
    NSLog(@"timeline action");
    
    [_twitter getHomeTimelineSinceID:nil
                               count:60
                        successBlock:^(NSArray *statuses) {
                            
                            NSLog(@"-- statuses: %@", statuses);
                            
                            //                            self.getTimelineStatusLabel.text = [NSString stringWithFormat:@"%lu statuses", (unsigned long)[statuses count]];
                            
                            self.statuses = statuses;
                            [self.tableview reloadData];
                            
                            HideNetworkActivityIndicator();
                        } errorBlock:^(NSError *error) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                            message:[error localizedDescription]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifier = @"Cell";
    TweetTableViewCell*cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *status = [self.statuses objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateStringg = [status valueForKey:@"created_at"];
    
    
    NSString *dateStr = dateStringg;
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setTimeStyle:NSDateFormatterFullStyle];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    //    [dateFormat setDateFormat:@"EEE, d LLL yyyy HH:mm:ss Z"];
    [dateFormat setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSLog(@"Current Date: %@", [formatter stringFromDate:date]);
    
    
    
    //use this for system font
    
    
    
    
    NSString *imageURL=[[status valueForKey:@"user"] objectForKey:@"profile_image_url"];
    imageURL=[imageURL stringByReplacingOccurrencesOfString:@"normal"
                                            withString:@"bigger"];
    [cell.imgView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    
    
    
    
    
    
    
    cell.lblTweet.text=text;
    cell.lblTime.text=[formatter stringFromDate:date];
    cell.lblScreenName.text=[status valueForKeyPath:@"user.name"];
    cell.lblUsername.text=[NSString stringWithFormat:@"@%@",screenName];
    
    cell.lblTimeInterval.text = [NSString stringWithFormat:@"%@,", [date prettyDate]];
    
    return cell;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [_statuses count];
    
}
-(void)login{
    NSLog(@"ios action");
    
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [self getTImeline];
        ShowNetworkActivityIndicator();
        
    } errorBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}

- (IBAction)loginWithiOSAction:(id)sender {
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Twitter";
    [self login];
    
    
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"5E9AC1"];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    
    
    
    left.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=left;
    
    
    
    [left setTarget: self.revealViewController];
    [left setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
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



- (IBAction)btnPickPhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=(id)self;
    //imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.imageView.image=editedImage;
        // Get the new image from the context
        
        // End the context
        
    }
    else         if ([mediaType isEqualToString:@"public.movie"]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Video file not supported."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            
            [controller addImage:self.imageView.image];
            [self presentViewController:controller animated:YES completion:Nil];}
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Alert"
                                                            message:@"Log in to Facebook via Settings of your iPhone to access the sharing feature!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // for example, presenting a vc or performing a segue
    }];
    
}





@end
