//
//  TweetTableViewCell.h
//  SocialApp
//
//  Created by MokshaX on 8/17/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTweet;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;

@end
