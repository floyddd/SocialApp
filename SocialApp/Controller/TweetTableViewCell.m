//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//

#import "TweetTableViewCell.h"

@implementation TweetTableViewCell

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
