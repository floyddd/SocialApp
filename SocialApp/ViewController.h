//
//  ViewController.h
//  FacebookTest
//
//  Created by MokshaX on 8/25/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//
#import <Social/Social.h>
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface ViewController : UIViewController<UIImagePickerControllerDelegate,FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
