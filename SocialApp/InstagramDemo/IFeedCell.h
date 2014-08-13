//
//  IFeedCell.h
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFeedCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *ownerName;
@property (nonatomic,weak) IBOutlet UILabel *time;
@property (nonatomic,weak) IBOutlet UILabel *likesCount;
@property (nonatomic,weak) IBOutlet UIImageView *ownerPhoto;
@property (nonatomic,weak) IBOutlet UIImageView *iPhoto;
@property (nonatomic,weak) IBOutlet UIButton *commentButton;
@property (nonatomic,weak) IBOutlet UIButton *likeButton;



@end
