//
//  SplashVC.m
//  organizer App
//
//  Created by one click IT consultany on 6/19/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "SplashVC.h"

@interface SplashVC ()
{
    int page;
}

@end

@implementation SplashVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-bg.png"]]];

    self.navigationController.navigationBarHidden=YES;
    
    UIImageView * imgCV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imgCV];
    
    scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [scrlContent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2"]]];
    scrlContent.showsHorizontalScrollIndicator = NO;
    scrlContent.showsVerticalScrollIndicator = NO;
    scrlContent.pagingEnabled = YES;
    scrlContent.bounces = NO;
    scrlContent.delegate = self;
    [self.view addSubview:scrlContent];
    [scrlContent setContentOffset:CGPointMake(0, 0) animated:YES];

    [scrlContent setContentSize:CGSizeMake(1024*3, 768)];
    
    if (IS_IPAD)
    {
//        scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//        [scrlContent setContentSize:CGSizeMake(scrlContent.frame.size.width*3, 768)];
    }
    else
    {
        if (IS_IPHONE_5)
        {
            scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            [scrlContent setContentSize:CGSizeMake(scrlContent.frame.size.width*3, 568-20)];
        }
        else
        {
            scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            [scrlContent setContentSize:CGSizeMake(scrlContent.frame.size.width*3, 480-20)];
        }
    }

    
     firstImg =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    firstImg.backgroundColor=
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-3-bg"]];
    [scrlContent addSubview:firstImg];
    
    
     secondImg =[[UIView alloc] initWithFrame:CGRectMake(1024, 0, 1024, 768)];
    secondImg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-5-bg"]];
    [scrlContent addSubview:secondImg];
    
     thirdImg =[[UIView alloc] initWithFrame:CGRectMake(2048, 0, 1024, 768)];
    thirdImg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-1.1.png"]];
    [scrlContent addSubview:thirdImg];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, 768-50, 1024, 50);
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor whiteColor];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:SinkinSansRegularFont size:18.0]];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(ContiNueClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"Continue" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"getstarted.png"] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [nextBtn setBackgroundColor:[UIColor clearColor]];
    [nextBtn setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];

    [self.view addSubview:nextBtn];


}

#pragma mark - UIButton Click Event
-(void)ContiNueClick
{
    if (page==0)
    {
        [scrlContent setContentOffset:CGPointMake(1024, 0) animated:YES];
        [nextBtn setTitle:@"Continue" forState:UIControlStateNormal];

    }
    else if (page==1)
    {
        [scrlContent setContentOffset:CGPointMake(2048, 0) animated:YES];
        [nextBtn setTitle:@"Get Started" forState:UIControlStateNormal];

 
    }
    else if (page==2)
    {
        [self finshsplash];
        [nextBtn setTitle:@"Continue" forState:UIControlStateNormal];

    }

}
-(void)finshsplash
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Login"] isEqualToString:@"Yes"])
    {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
        [UIView commitAnimations];
        
        AppDelegate * ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        splitViewController =[[UISplitViewController alloc] init];
        
        homeVC = [[UpComingEventVC alloc] init];
        
        mainNavController   = [[UINavigationController alloc] initWithRootViewController:homeVC];
        
        listViewController = [[Leftmenu alloc] init];
        listNavController   = [[UINavigationController alloc] initWithRootViewController:listViewController];
        listNavController.navigationBar.tintColor = [UIColor blackColor];
        listNavController.navigationBarHidden  = NO;
        
        
        if (IS_OS_8_OR_LATER)
        {
          
            splitViewController.viewControllers = [NSArray arrayWithObjects:listNavController,mainNavController, nil];
            splitViewController.delegate = self;
          //  ap.window.rootViewController = splitViewController;
            [ap.window addSubview:splitViewController.view];

        }
        else
        {
            splitViewController.viewControllers = [NSArray arrayWithObjects:listNavController,mainNavController, nil];
            splitViewController.delegate = self;
            ap.window.rootViewController = splitViewController;
          
            
        }
        
        
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
        [UIView commitAnimations];
        Welcome *welcome=[[Welcome alloc]init];
        [self.navigationController pushViewController:welcome animated:NO];
    }
    
}
#pragma mark - ScrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == scrlContent)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == scrlContent)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"page==%d",page);
        if (page==0)
        {
            [scrlContent setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
        else if (page==1)
        {
            [scrlContent setContentOffset:CGPointMake(1024, 0) animated:YES];
            
        }
        else if (page==2)
        {
            [scrlContent setContentOffset:CGPointMake(2048, 0) animated:YES];
            
        }
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y >=360.0f)
    {
        
    }
    else
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
