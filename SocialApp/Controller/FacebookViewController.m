//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import <Social/Social.h>
#import "UIAlertView+Blocks.h"
#import "FBCell.h"
#import <FacebookSDK/FBDialogs.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookViewController.h"
#import <Social/Social.h>

@interface FacebookViewController ()
- (IBAction)btnPostStatus:(id)sender;
- (IBAction)btnPostPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong) NSArray *posts;
@property (strong) FBSession *fbSession;

@end

@implementation FacebookViewController
BOOL hasTwitter = NO;
BOOL hasFacebook = NO;

- (void)updatePosts {
	self.posts = nil;
	[self.tableView reloadData];
    
	[self getNewsfeed];
}
- (void)getNewsfeed {
	if (!hasFacebook) {
		[self loginFacebook];
		return;
	}
    NSLog(@"permissions::%@",FBSession.activeSession.permissions);
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"access_token"] = FBSession.activeSession.accessTokenData;
    NSLog(@"TOKEN %@",parameters[@"access_token"]);
	FBRequest *request = [FBRequest requestForGraphPath:@"me/feed"];
	[request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
		if (error) {
			[UIAlertView showAlertViewWithTitle:@"Connection Error" message:@"There was an error getting the news feed. Please try again." cancelButtonTitle:@"OK" otherButtonTitles:nil onDismiss:nil onCancel:nil];
		} else {
			self.posts =result;
            //    NSLog(@"%@",[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"status"]);
            NSLog(@"data %@",[result objectForKey:@"data"]);
            
			[self.tableView reloadData];
		}
	}];
}

- (void)loginFacebook {
	[FBSession openActiveSessionWithReadPermissions:@[

                                                      @"public_profile",
                                                      
                                                      @"read_stream",
                                                      @"user_status",
                                                      ]
	                                   allowLoginUI:YES
	                              completionHandler:^(FBSession *session,
	                                                  FBSessionState state,
	                                                  NSError *error) {
                                      if (error) {
                                          hasFacebook = NO;
                                          NSLog(error.debugDescription);
                                          NSLog(error.description);
                                      } else {
                                          self.fbSession = session;
                                          hasFacebook = YES;
                                          [self updatePosts];
                                      }
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
- (void)preferredContentSizeChanged:(NSNotification *)notification {
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Facebook";
FBLoginView *loginView = [[FBLoginView alloc] initWithFrame:CGRectMake(13, 347, self.view.bounds.size.width - 38, 8)];
loginView.delegate = self;
     [self.view addSubview:loginView];
    
    
    if (FBSession.activeSession.state == FBSessionStateOpen ||
        FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        self.fbSession = FBSession.activeSession;
        loginView.hidden=YES;
        hasFacebook = YES;
    }


[self updatePosts];
[[NSNotificationCenter defaultCenter]
 addObserver:self
 selector:@selector(preferredContentSizeChanged:)
 name:UIContentSizeCategoryDidChangeNotification
 object:nil];

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
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
        

        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
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
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSDictionary *wallPost = [self.posts objectAtIndex:indexPath.row];
    
	NSString *cellIdentifier;
	if (wallPost[@"picture"] && wallPost[@"message"]) {
		cellIdentifier = @"FBPictureCell";
	} else if (wallPost[@"picture"] && !wallPost[@"message"]) {
		cellIdentifier = @"FBPictureOnlyCell";
	} else {
		cellIdentifier = @"FBCell";
	}
    
	FBCell *fbCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	fbCell.wallPost = wallPost;
    
	return fbCell;
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
	float height = 80;
    
	NSString *string = post[@"message"];
	if (string) {
		NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                     };
		CGRect bodyFrame =
        [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds),
                                                CGFLOAT_MAX)
                             options:(NSStringDrawingUsesLineFragmentOrigin |
                                      NSStringDrawingUsesFontLeading)
                          attributes:attributes
                             context:nil];
        
		height += ceilf(CGRectGetHeight(bodyFrame));
	}
	if (post[@"picture"]) {
		height += 136 + 12;
	}
    
	return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return self.posts.count;
}

- (IBAction)btnPostPhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=(id)self;
    //imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    

}
@end
