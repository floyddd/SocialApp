//
//  DashboardViewController.h
//  YashKumar
//
//  Created by Bidhee on 6/29/14.
//  Copyright (c) 2014 Bidhee. All rights reserved.
//


#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#define iPhone4Or5oriPad ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : 999))
@interface DashboardViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblViewNews;
@property (strong, nonatomic) IBOutlet  UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong,nonatomic) UIImageView *imgView;
@property (nonatomic) BOOL segueRecieved;
@property (nonatomic) BOOL navigationHide;
@property (nonatomic, strong) NSArray *statuses;

//@property (strong, nonatomic) IBOutlet  UIView *hideView;
@end
