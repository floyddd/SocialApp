//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//




#import "SWRevealViewController.h"


#import "DashboardViewController.h"
@interface DashboardViewController () {



}





@end

@implementation DashboardViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    
    
    
    left.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=left;
    
    
    
    [left setTarget: self.revealViewController];
    [left setAction: @selector( revealToggle: )];

     [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

//}
@end
