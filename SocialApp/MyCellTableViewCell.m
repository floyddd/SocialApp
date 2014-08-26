//
//  MyCellTableViewCell.m
//  FacebookTest
//
//  Created by MokshaX on 8/26/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//

#import "MyCellTableViewCell.h"

@implementation MyCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
