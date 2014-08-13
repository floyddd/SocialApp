//
//  IFeedItem.m
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//

#import "IFeedItem.h"

@implementation IFeedItem{
@private
    NSString *avatarImageURLString;
    NSString *imageForUrl;}

@synthesize timeFromRelease,imageOwnerNickname,likeCount,imageUrl,commentsCount,ownerID,postID,adict,likeStatus;

//создаем объект с информацией о посте(изображение,отправитель,кол-во лайков и т.д.)

-(id)initWithParams:(NSDictionary *)params

{
    self = [super init];
    if(self)
    {
        NSString *dateInUnix = [params valueForKeyPath:@"created_time"];
        likeCount = [[params valueForKeyPath:@"likes.count"]intValue];
        timeFromRelease = [self timeFromNowToReleaseWithString:dateInUnix];
        imageOwnerNickname =[params valueForKeyPath:@"user.username"];
        imageForUrl = [params valueForKeyPath:@"images.low_resolution.url"];
        commentsCount = [params valueForKeyPath:@"comments.count"];
        ownerID = [params valueForKeyPath:@"user.id"];
        postID = [params valueForKey:@"id"];
        adict = [params valueForKeyPath:@"likes.data"];
        likeStatus = [self checkLikeStatus:params];
        avatarImageURLString = [params valueForKeyPath:@"user.profile_picture"];
    }
    
    return self;
}

//возвращаем URl'ы для последующей загрузки изображений

- (NSURL *)avatarImageURL {
    return [NSURL URLWithString:avatarImageURLString];
}

-(NSURL *)imageUrl{
    return [NSURL URLWithString:imageForUrl];
}

// переводим время создания поста из юникса в дни,часы

-(NSString*)timeFromNowToReleaseWithString:(NSString *)string

{
    NSString *dg = string;
    NSString *dayspast = [NSString string];
    time_t unixFromNow = (time_t)[[NSDate date]timeIntervalSince1970]; //current time in unix
    long releaseTime = [dg intValue];
    NSInteger dif = (unixFromNow - releaseTime)/84600;
    if(dif<1)
    {
        dif = (unixFromNow - releaseTime)/3600;
        if(dif<1)
        {
         dayspast = @"just now";
        }
        else
        {
        dayspast =  [NSString stringWithFormat:@"%dh",dif];
        }
    }
    else if(dif >6)
    {
        dif = dif/7;
        dayspast  = [NSString stringWithFormat:@"%dw",dif];
    }
    else{
    dayspast  = [NSString stringWithFormat:@"%dd",dif];
    }
    return dayspast;
    
}

//проверяем текущий статус лайка для поста - ищем свой id среди id людей, лайкнувших пост

-(BOOL)checkLikeStatus:(NSDictionary *)diction

{
    NSString *myId = [[NSUserDefaults standardUserDefaults]objectForKey:@"selfUserID"];
    NSArray *likers = [diction valueForKeyPath:@"likes.data"];
    NSMutableArray *good = [NSMutableArray arrayWithCapacity:[likers count]];
    BOOL result = 0;
    for(NSDictionary*dic in likers)
    {
        [good addObject:[dic valueForKey:@"id"]];
    
    }
    for(int i=0;i<[good count];i++)
        if ([myId isEqual:[good objectAtIndex:i]])
        {
            result = 1;
        }
    
    return result;
}


@end
