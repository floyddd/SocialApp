//
//  IFeedItem.h
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFeedItem : NSObject

@property(nonatomic,readonly)NSString *imageOwnerNickname;
@property(nonatomic,readonly)NSString *timeFromRelease;
@property(nonatomic,assign)NSInteger likeCount;
@property(nonatomic,readonly)NSString *commentsCount;
@property(readonly, nonatomic, unsafe_unretained)NSURL *imageUrl;
@property(nonatomic,readonly)NSString *ownerID;
@property(nonatomic,readonly)NSString *postID;
@property(nonatomic,assign)BOOL likeStatus;
@property(nonatomic,readonly)NSDictionary *adict;
@property (readonly, nonatomic, unsafe_unretained) NSURL *avatarImageURL;

-(id)initWithParams:(NSDictionary*)params;
-(NSString*)timeFromNowToReleaseWithString:(NSString *)string;
-(BOOL)checkLikeStatus:(NSDictionary*)diction;

@end
