//
//  ViewController.m
//  FacebookTest
//
//  Created by MokshaX on 8/25/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES

#import "MyCellTableViewCell.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "FBCell.h"
@interface ViewController (){
    FBLoginView *loginView ;
    id token;
    NSString *urls;
}
@property (strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)btnPostStatus:(id)sender;
- (IBAction)btnPostPhoto:(id)sender;
@end

@implementation ViewController
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginVie user:(id<FBGraphUser>)user
{
    self.tableView.hidden=NO;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(Logout)];
        right.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=right;
     [loginView removeFromSuperview];

}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginVie
{
    self.navigationItem.rightBarButtonItem=nil;
    [self.view addSubview:loginView];
    self.tableView.hidden=YES;
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
-(void)Logout{
    [self.view addSubview:loginView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      self.title=@"Facebook";
    
self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"003D99"];
UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(Logout)];
    if ([FBSession activeSession].state != FBSessionStateCreatedTokenLoaded)
    {
        self.tableView.hidden=YES;
        
          [self.view addSubview:loginView];
    }
    else
    {
        ShowNetworkActivityIndicator();
        self.tableView.hidden=NO;
        loginView.hidden=YES;
        
    }
    
    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    
   // self.navigationItem.rightBarButtonItem=right;
    right.tintColor=[UIColor whiteColor];
  loginView  = [[FBLoginView alloc] initWithFrame:CGRectMake(50, 300, 60, 8)];
    loginView.delegate = self;
    loginView.readPermissions=@[@"read_stream",@"public_profile",@"user_friends"];
    token=[[FBSession activeSession]accessTokenData];
    NSString *graphLink=[NSString stringWithFormat:@"/me/home?access_token=%@",token];
    [FBRequestConnection startWithGraphPath:graphLink
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error

                                              ) {
                              /* handle the result */
                              NSLog(@"result %@",result);
                          }];

    
  
    left.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=left;
    
    
    
    [left setTarget: self.revealViewController];
    [left setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];

    [self pullFilmography];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullFilmography
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        token=[[FBSession activeSession]accessTokenData];
        NSLog(@"token %@",[[FBSession activeSession]permissions]);
        BOOL isTheObjectThere = [[[FBSession activeSession]permissions] containsObject: @"read_stream"];
        NSLog(@"object there %hhd",isTheObjectThere);
        
        if (isTheObjectThere) {
            urls=[NSString stringWithFormat:@"https://graph.facebook.com/me/home?access_token=%@",token];
        }
        else{
            urls=[NSString stringWithFormat:@"https://graph.facebook.com/me/home?access_token=CAACEdEose0cBACDqiLJv0rMFIb7fZCljcyzHzhEpRUq8211FXuckWJZAYlA0bFv2p6A5weDOCI5E96MghanMfjvqyXWNpHntCqdCZC2JzbaAkzel1jKx9QCp79zMy6cnG7Fu1oe7GWG1AoTogAF3hrwwQvM16lZBY9T1X6uVEzELoDrKpaWW1hOODM6Q86nZCndzRaCisHnFyIz6sNwBxrHxjB6KZAzNYZD"];}
        NSURL *url = [NSURL URLWithString:urls];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //AFNetworking asynchronous url request
        

        AFJSONRequestOperation *operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                         
                                                            self.posts=[JSON objectForKey:@"data"];
                                                            NSLog(@"cdount %d",[self.posts count]);
                                                            [self.tableView reloadData];
                                                            HideNetworkActivityIndicator();
                                                            NSLog(@"%@", JSON);
                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                    NSError *error, id JSON) {
                                                            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                        }];
        [operation start];

   });
}
- (void)preferredContentSizeChanged:(NSNotification *)notification {
	[self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    MyCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[MyCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    NSLog(@"post %@",self.posts[0]);
    cell.lblTitle.text=[[self.posts[indexPath.row] objectForKey:@"from"] objectForKey:@"name"];
    cell.lblMessage.text=[self.posts[indexPath.row] objectForKey:@"message"];
    NSString *str=  [self.posts[indexPath.row] objectForKey:@"picture"];
    NSLog(@"test %@",str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];


    [cell.imgVIewPhoto setImageWithURLRequest:request
                     placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  
                                  // do image resize here
                                  
                                  // then set image view
                                  
                                  cell.imgVIewPhoto.image = image;
                              }
                              failure:nil];
    
    
    NSString *profile= [[self.posts[indexPath.row] objectForKey:@"from"] objectForKey:@"id"];
    NSString *pic=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",profile];
    NSLog(@"url %@",pic);
    NSURL *urlss = [NSURL URLWithString:pic];
    NSURLRequest *requests=[NSURLRequest requestWithURL:urlss];

    [cell.imgviewProfile setImageWithURLRequest:requests
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          // do image resize here
                                          
                                          // then set image view
                                          
                                          cell.imgviewProfile.image = image;
                                      }
                                      failure:nil];

    
    return cell;
//	NSDictionary *wallPost = [self.posts objectAtIndex:indexPath.row];
//
//	NSString *cellIdentifier;
//	if (wallPost[@"picture"] && wallPost[@"message"]) {
//		cellIdentifier = @"FBPictureCell";
//	} else if (wallPost[@"picture"] && !wallPost[@"message"]) {
//		cellIdentifier = @"FBPictureOnlyCell";
//	} else {
//		cellIdentifier = @"FBCell";
//	}
//    
//	FBCell *fbCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//	fbCell.wallPost = wallPost;
//    
//	return fbCell;
}
//- (CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
//	float height = 80;
//    
//	NSString *string = post[@"message"];
//	if (string) {
//		NSDictionary *attributes = @{
//                                     NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
//                                     };
//		CGRect bodyFrame =
//        [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds),
//                                                CGFLOAT_MAX)
//                             options:(NSStringDrawingUsesLineFragmentOrigin |
//                                      NSStringDrawingUsesFontLeading)
//                          attributes:attributes
//                             context:nil];
//        
//		height += ceilf(CGRectGetHeight(bodyFrame));
//	}
//	if (post[@"picture"]) {
//		height += 136 + 12;
//	}
//    
//	return height;
//}
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
