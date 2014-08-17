//
//  IFeedController.m
//  InstagramDemo
//
//  Copyright (c) Nexitusor. All rights reserved.
//
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "IFeedItem.h"
#import "IFeedStore.h"
#import <QuartzCore/QuartzCore.h>
#import "IFeedController.h"
#import "IAuthentificator.h"


#define REFRESH_HEADER_HEIGHT 52.0f //задаем высоту ячейки "pull-to-refresh"

@implementation IFeedController
@synthesize feedTable,helloView,accessToken,image,items,textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


//загружаем приветствующее view, если токен = 0

-(void)loadHelloView

{
   // [[self navigationController]setNavigationBarHidden:YES];
    CGRect helloFrame = [[UIScreen mainScreen]bounds];
    helloView = [[UIView alloc]initWithFrame:helloFrame];

    CGRect imageVIew =[[UIScreen mainScreen]bounds];
    image = [[UIImageView alloc]initWithFrame:imageVIew];
    [image setImage:[UIImage imageNamed:@"insta3.jpg"]];
    [[self helloView]addSubview:image];

    CGRect ma = CGRectMake(110, 300, 100, 30);
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:ma];
    [but setTitle:@"Login" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor whiteColor]];
    but.titleLabel.font =[ UIFont fontWithName:@"Arial" size:20];
    but.titleLabel.textColor = [UIColor blackColor];
    [[but layer]setBorderWidth:2];

    [but addTarget:self action:@selector(openLoginView:) forControlEvents:UIControlEventTouchUpInside];
    [helloView addSubview:but];
    [[self view]addSubview:helloView];
    
    
    
    
}
-(void)aMethod:(id)sender {
    [self performSegueWithIdentifier:@"back" sender:sender];
}
// загружаем основное табличное view. если токен = 0, показываем окно приветствия

-(void)viewDidLoad

{
    [super viewDidLoad];
    
    accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    [UIView commitAnimations];
 
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    
    
    
    left.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=left;
    
    
    
    [left setTarget: self.revealViewController];
    [left setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    
    CGRect tableFrame = [[UIScreen mainScreen]bounds];
    feedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tableFrame.size.width, tableFrame.size.height-40) style:UITableViewStylePlain];
    [[self view]addSubview:feedTable];
    [[self feedTable]setDelegate:self];
  
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    [[self navigationItem]setTitle:@"Instagram"];
    [feedTable setDataSource:self];
    
    //[[self navigationItem]setRightBarButtonItem:item];
    
    [[self view]bringSubviewToFront:helloView];
    [feedTable setRowHeight:440];
    [feedTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   // [[self navigationController]setNavigationBarHidden:NO];
    
    [self addPullToRefreshHeader];
    textPull = @"Pull down to refresh..."; //устанавливаем текст для "pull-to-refresh"
    textRelease = @"Release to refresh...";
    textLoading = @"Loading...";
    
    //нет токена - предлагаем автоиризироваться
        if (!accessToken)
        {
            [self loadHelloView];
        }
        else
        {
            [self askStoreToLoadData]; //иначе наполняем таблицу
        }

    
}

//создаем "pull-to-refresh" и описываем его логику

- (void)addPullToRefreshHeader

{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont systemFontOfSize:15];
    refreshLabel.textColor = [UIColor darkGrayColor];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayArrow2.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.feedTable addSubview:refreshHeaderView];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    if (isLoading) {
       
        if (scrollView.contentOffset.y > 0)
            self.feedTable.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.feedTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
     
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
              
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
               
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        
        [self startLoading];
    }
}

- (void)startLoading

{
    isLoading = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.feedTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
   
    [self refresh];
}

- (void)stopLoading

{
    isLoading = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.feedTable.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete

{
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh

{
    [self askStoreToLoadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.5];
}


//выходим. отправляем пользователя разлогиниться и удаляем токен

-(void)logout:(id)sender

{
    
    NSURL *url = [[NSURL alloc]initWithString:@"http://instagram.com/accounts/logout/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    [con start];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selfUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    accessToken = nil;
    ShowNetworkActivityIndicator();
}

-(void)viewDidUnload
{
    feedTable = nil;
    image = nil;
    helloView = nil;
    refreshSpinner = nil;
    refreshArrow = nil;
    refreshHeaderView = nil;
}

//получив ответ об успешном логауте, показываем окно авторизации

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self loadHelloView];
    HideNetworkActivityIndicator();
   
}

//отправляем запрос синглтону на загрузку данных

-(void)askStoreToLoadData

{
    ShowNetworkActivityIndicator();
    [[IFeedStore sharedFeedStore] loadUsersFeed:^(NSArray *array, NSError *error) 
        
    {

        if(error)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [av show];
            
            HideNetworkActivityIndicator();
        }
        else
        {
            //обновляем данные и перезагружаем таблицу
            
            
            items = array;
            HideNetworkActivityIndicator();
            [feedTable reloadData];
            
            
        }
        
    }];
    
}


//открываем окно авторизации

-(void)openLoginView:(id)sender

{
    ShowNetworkActivityIndicator();
    IAuthentificator *iAuth = [[IAuthentificator alloc]init];
    [iAuth setIDelegate:self];
    [iAuth setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:iAuth animated:YES completion:^{}];
    
}

// стандартные методы делегата таблицы

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IFeedCell *cell = (IFeedCell*)[tableView dequeueReusableCellWithIdentifier:@"IFeedCell"];
    
        if(!cell)
            
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IFeedCell"owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            
        }
    
    IFeedItem *tut = [items objectAtIndex:[indexPath row]];
    
    [cell.commentButton addTarget:self
                           action:@selector(pushIT:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeButton addTarget:self
                        action:@selector(sendLike:) forControlEvents:UIControlEventTouchUpInside];
    
    [[cell ownerName]setText:tut.imageOwnerNickname];
    [[cell time]setText:[NSString stringWithFormat:@"%@",tut.timeFromRelease]];
    [[cell likesCount]setText:[NSString stringWithFormat:@"%i likes",tut.likeCount]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell ownerPhoto]setImageWithURL:tut.avatarImageURL];
    [[cell iPhoto]setImageWithURL:tut.imageUrl];
    
    //в зависимости от статуса лайка обновляем изображение на кнопке
    
    if(tut.likeStatus)
    {
        cell.likeButton.imageView.image = [UIImage imageNamed:@"hurtred.jpg"];
    }
    else
    {
        cell.likeButton.imageView.image = [UIImage imageNamed:@"hurt2.jpg"];

    }

    return cell;
}

//открываем комментарии (work in progress)

-(void)pushIT:(id)sender

{
 
    UIAlertView *pushAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Work in progress" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [pushAlert show];
}


//отправляем лайк или удаляем его

-(void)sendLike:(id)sender

{
    //получаем номер ячейки, из которой нажата кнопка

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.feedTable];
    NSIndexPath *indexPath = [self.feedTable indexPathForRowAtPoint:buttonPosition];

    BOOL likes;
    IFeedItem *item = [items objectAtIndex:[indexPath row]];
    NSInteger likesCount = [item likeCount];
    UIImage *selectedImage = [UIImage imageNamed:@"hurtred.jpg"];
    UIImage *unselectedImage = [UIImage imageNamed:@"hurt2.jpg"];
   
    // в зависимости от статуса лайка меняем цвет кнопки и запрос (POST/DELETE)
  
    if(item.likeStatus)
    {
        [sender setImage:unselectedImage forState:UIControlStateNormal];
        [sender setSelected:NO];
        [[items objectAtIndex:[indexPath row]]setLikeCount:likesCount-1];
        [[items objectAtIndex:[indexPath row]]setLikeStatus:NO];
        [feedTable reloadData];
        likes = 1;
        ShowNetworkActivityIndicator();
    }
    else
    {
        [sender setImage:selectedImage forState:UIControlStateSelected];
        [sender setSelected:YES];
        [[items objectAtIndex:[indexPath row]]setLikeCount:likesCount+1];
        [[items objectAtIndex:[indexPath row]]setLikeStatus:YES];
        [feedTable reloadData];
        likes = 0;
        ShowNetworkActivityIndicator();
    }
  
    //отправляем запрос

    [[IFeedStore sharedFeedStore]SendLikeOrUnlikeWithString:[NSString stringWithFormat:@"%@",item.postID] andLikeStatus:likes andBlock:^(NSError *error){
        
       if(error)
       {
           UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [av show];
           HideNetworkActivityIndicator();
       }
        else
        {
            HideNetworkActivityIndicator();
        }
    }];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 440;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [items count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    
}

//проверка авторизации, успех = убираем окно авторизации и перезагружаем таблицу

-(void)didAuth:(NSMutableString *)token
{
    HideNetworkActivityIndicator();
    image = nil;
    [helloView removeFromSuperview];
    helloView = nil;
    [[self navigationController]setNavigationBarHidden:NO];
    [self askStoreToLoadData];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    
}

@end
