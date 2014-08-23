//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//
#import "DashboardViewController.h"
#import "MenuViewController.h"
#import "SWRevealViewController.h"

@implementation SWUITableViewCell
@end

@implementation MenuViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
        
    
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"zero";
            break;
        case 1:
            CellIdentifier = @"one";
            break;
            
        case 2:
            CellIdentifier = @"two";
            break;
        case 3:
            CellIdentifier = @"three";
            break;
        
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];

    
    
    
    switch ( indexPath.row ){
        case 0:

            return cell;
            break;
            
        case 1:
            // cell.textLabel.text=@"Filmography";
            return cell;
            break;
            
            
        case 2:
            //  cell.textLabel.text=@"Social Initiatives";
            return cell;
            break;
            
        case 3:
            //    cell.textLabel.text=@"Videos";
            return cell;
            break;
            
        
            }
    
    return 0;
    
    
    
    
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    
    // configure the destination view controller:
       // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc pushFrontViewController:nc animated:YES];
        };
    }
}


@end
