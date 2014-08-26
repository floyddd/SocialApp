//
//  MyCellTableViewCell.h
//  FacebookTest
//
//  Created by MokshaX on 8/26/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIewPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@end
