//
//  TwitterViewController.m
//  SocialApp
//
//  Created by MokshaX on 8/12/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
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
@property (strong, nonatomic) NSMutableArray * newsArray;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    


        static NSString *CellIdentifier = @"Cell";
        TweetTableViewCell*cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        



            

                STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"PdLBPYUXlhQpt4AguShUIw" consumerSecret:@"drdhGuKSingTbsDLtYpob4m5b5dn1abf9XXYyZKQzk"];
                if (indexPath.row==0) {
                [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
                    
                    
                    [twitter getUserTimelineWithScreenName:@"floyddd" successBlock:^(NSArray *statuses) {
                        NSLog(@"array %@",statuses);
                        
                            NSDictionary *status = [statuses objectAtIndex:indexPath.row];
                        cell.lblTweet.text= [status objectForKey:@"text"];
                        cell.lblScreenName.text=[[[[status objectForKey:@"entities"] objectForKey:@"user_mentions"] valueForKey:@"name"] objectAtIndex:0];
                        [self.tableview reloadData];
                        NSLog(@"data %@",[[[[status objectForKey:@"entities"] objectForKey:@"user_mentions"] valueForKey:@"name"] objectAtIndex:0]);
                    } errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                    }];
                    
                } errorBlock:^(NSError *error) {
                    NSLog(@"-- error %@", error);
                    
                }];

                

            }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 1;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        self.title=@"Twitter";

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
