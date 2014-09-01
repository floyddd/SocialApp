//
//  TweetTableViewCell.m
//  SocialApp
//
//  Created by MokshaX on 8/17/14. Contact:9841852849(Parag Regmi, iOS Developer)
//  Copyright (c) 2014 MokshaX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAuthentificator.h"
#import "IFeedCell.h"

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@interface IFeedController : UIViewController <UITableViewDataSource,UITableViewDelegate,InstagramAuth,NSURLConnectionDataDelegate>

{
    UITableView *feedTable;
    UIView *helloView;
    NSString *accessToken;
    UIImageView *image;
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property(nonatomic,strong) UITableView *feedTable;
@property(nonatomic,strong) UIView *helloView;
@property(nonatomic,strong) NSString *accessToken;
@property(nonatomic,strong) UIImageView *image;
@property(nonatomic,strong) NSArray *items;

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;



@end
