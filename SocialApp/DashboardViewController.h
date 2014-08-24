//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//


#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#define iPhone4Or5oriPad ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : 999))
@interface DashboardViewController : UIViewController <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblViewNews;
@property (strong, nonatomic) IBOutlet  UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong,nonatomic) UIImageView *imgView;
@property (nonatomic) BOOL segueRecieved;
@property (nonatomic) BOOL navigationHide;
@property (nonatomic, strong) NSArray *statuses;

//@property (strong, nonatomic) IBOutlet  UIView *hideView;
@end
