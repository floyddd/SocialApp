//
//  TwitterPostPhotoViewController.m
//  SocialApp
//
//  Created by MokshaX on 8/13/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import <Social/Social.h>
#import "TwitterPostPhotoViewController.h"

@interface TwitterPostPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnPostPhotoOutlet;
- (IBAction)btnPickPhoto:(id)sender;
- (IBAction)btnPostPhoto:(id)sender;



@end

@implementation TwitterPostPhotoViewController

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
         self.btnPostPhotoOutlet.enabled=NO;
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
        if (self.imageView.image!=nil) {
            self.btnPostPhotoOutlet.enabled=YES;
        }
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)btnPostPhoto:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller addImage:self.imageView.image];
        
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
@end
