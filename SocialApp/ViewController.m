//
//  ViewController.m
//  FacebookTest
//
//  Created by MokshaX on 8/25/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import "MyCellTableViewCell.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "FBCell.h"
@interface ViewController ()
@property (strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray * filmographyArray;
- (IBAction)btnPostStatus:(id)sender;
- (IBAction)btnPostPhoto:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
      self.title=@"Facebook";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    
    
    
    left.tintColor=[UIColor blackColor];
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
        NSString *urls=[NSString stringWithFormat:@"https://graph.facebook.com/579709429/home?access_token=CAACEdEose0cBAMYnzDPZBZB6lD5dW97Con35pzFpN8Dq0GXiTBh9ZCyCROVyvMwW1EfQ7kX03e4I05wDZAYySGWYobZAxMcBsQbSYZC8aefOQk0xVbywB6iMX39FEbPlU9dazzLCSl1omHjdcX6ZCsUIlD0L4E9wa8w2JKBknsw7WeyZBKvjFWIIMpYPizGeJXxuA2hE2hZBZAG68hKb5yhWmj"];
        NSURL *url = [NSURL URLWithString:urls];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //AFNetworking asynchronous url request
        

        AFJSONRequestOperation *operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            self. filmographyArray = [JSON objectForKey:@"data"];
                                                            
                                                            self.posts=[JSON objectForKey:@"data"];
                                                            NSLog(@"cdount %d",[self.posts count]);
                                                            [self.tableView reloadData];
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
    NSString *str=[self.posts[indexPath.row] objectForKey:@"picture"];
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
    NSString *pic=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",profile];
    NSLog(@"url %@",pic);
    NSURL *urls = [NSURL URLWithString:pic];
    NSURLRequest *requests=[NSURLRequest requestWithURL:urls];

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
