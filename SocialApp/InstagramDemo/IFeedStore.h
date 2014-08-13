//
//  IFeedStore.h
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFeedStore : NSObject

+(IFeedStore *)sharedFeedStore;

-(void)loadUsersFeed:(void(^)(NSArray *array, NSError *error))block;

-(void)SendLikeOrUnlikeWithString:(NSString*)string andLikeStatus:(BOOL)status andBlock:(void(^)(NSError *error))thisBLock;


@end
