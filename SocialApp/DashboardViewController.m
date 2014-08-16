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


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

//}
@end
