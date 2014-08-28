//
//  TweetTableViewCell.h
//  SocialApp
//
//  Created by MokshaX on 8/17/14.
//  Copyright (c) 2014 MokshaX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *lblTweet;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
