//
//  DashboardViewController.m
//  YashKumar
//
//  Created by Bidhee on 6/29/14.
//  Copyright (c) 2014 Bidhee. All rights reserved.
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
