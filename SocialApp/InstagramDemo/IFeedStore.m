//
//  IFeedStore.m
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//
#import "IFeedItem.h"
#import "IFeedStore.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"



#define likeURL @"https://api.instagram.com/v1/media/%@/likes"


@implementation IFeedStore

//создаем singleton,который будет закачивать данные, паковать и отправлять контроллерам. Если уже создан, просто вернуть.
//Если бы загрузка проходила через стандартные NSURLConnetion, можно было создать отдельный класс именно для запросов.

+(IFeedStore *)sharedFeedStore

{
    static IFeedStore *feedStore = nil;
    if(!feedStore)
       feedStore = [[IFeedStore alloc]init];
    
    return feedStore;
    
}

//Загружаем пользовательскую ленту в формате json, парсим ее, пакуем данные в массив и отправляем таблице

-(void)loadUsersFeed:(void (^)(NSArray *array, NSError *error))block

{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSString *urlStr = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed/?access_token=%@&count=7",token];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
   
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSArray *jsonArray = [JSON objectForKey:@"data"];
       
        NSMutableArray *feed = [NSMutableArray arrayWithCapacity:[jsonArray count]];
        for(NSDictionary *dict in jsonArray)
        {
            IFeedItem *item = [[IFeedItem alloc]initWithParams:dict];
            [feed addObject:item];
        }

        if(block)
        {
            block([NSArray arrayWithArray:feed], nil);
        }
 
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    
    {
        
        block([NSArray array],error); 
    }];
    
    [operation start];
    
}

//отправляем запрос "поставить/убрать лайк", метод принимает булевую переменную с флагом о текущем состоянии лайка
//для каждого поста, в зависимости от которой ставится или снимается лайк

-(void)SendLikeOrUnlikeWithString:(NSString *)string andLikeStatus:(BOOL)status andBlock:(void (^)(NSError *error))thisBLock

{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSString *requestMethod = [NSString string];
    NSString *pathString = [NSString stringWithFormat:@"/v1/media/%@/likes",string];
    NSDictionary *params = [NSDictionary dictionary];
   
    
    if(status)                          //send unlike
    {
        requestMethod = @"DELETE";
        pathString = [NSString stringWithFormat:@"/v1/media/%@/likes?access_token=%@",string,token];
    }
    else                                //send like
    {
        requestMethod = @"POST";
        params = @{@"access_token": token};
        
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com"]];
   
    NSURLRequest *request =[client requestWithMethod:requestMethod path:pathString parameters:params];
    
    AFJSONRequestOperation *oper = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"good request!");
        
        if(thisBLock)
        {
            thisBLock(nil);
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) //возвращаем ошибку
                                    
                                    
    {
        NSLog(@"bad request");
        thisBLock(error);
    }];
    [oper start];
    
}

@end
