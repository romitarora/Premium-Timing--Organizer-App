//
//  splashview.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "splashview.h"
#import "CustomCalendarViewController.h"
@interface splashview ()

@end

@implementation splashview

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    
   [super viewDidLoad];
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-bg.png"]]];
    
    tempv= [[UIView alloc]init];
    tempv.frame = CGRectMake(0, 0, 1024, 768);
    tempv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-bg.png"]];
    [self.view addSubview:tempv];
    
    self.navigationController.navigationBarHidden=YES;
    
    
        if (IS_IPAD)
        {
            scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [scrlContent setContentSize:CGSizeMake(scrlContent.frame.size.width*3, 768)];
        }
        else
        {
           
        }
        
        [scrlContent setBackgroundColor:[UIColor clearColor]];
        scrlContent.pagingEnabled = YES;
        scrlContent.bounces = NO;
        scrlContent.delegate = self;
        scrlContent.showsHorizontalScrollIndicator = NO;
        scrlContent.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scrlContent];
        
        [self.view bringSubviewToFront:scrlContent];
        
        UIImageView * backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrlContent.frame.size.width, scrlContent.frame.size.height)];
        [backImg setImage:[UIImage imageNamed:@"w1_iPhone_5_bg.png"]];
        
        int xx = 0;
        UIView * contentView;
       contentView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, scrlContent.frame.size.width, scrlContent.frame.size.height)];
       [scrlContent addSubview:contentView];
    
       UIImageView * imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
       [contentView addSubview:imgBg];
    
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake(0,768-50, 1024, 50)];
    [btnNext setBackgroundColor:[UIColor clearColor]];
    [btnNext setBackgroundImage:[UIImage imageNamed:@"sky_blue_btn.png"] forState:UIControlStateNormal];
    btnNext.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [btnNext setTitle:NSLocalizedString(@"CONTINUE", nil) forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(btnNextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setBackgroundImage:[UIImage imageNamed:@"getstarted"] forState:UIControlStateNormal];
    [contentView addSubview:btnNext];
    [btnNext setHidden:NO];
    
        for (int i = 0; i<3; i++)
        {
           
            if (i==0)
            {
                [imgBg setFrame:CGRectMake(0, 0, 1024, 768)];
                [imgBg setImage:[UIImage imageNamed:@"SPLASH-3-bg"]];
                
            }
            else if (i==1)
            {
                [imgBg setFrame:CGRectMake(0, 0, 1024, 768)];
                [imgBg setImage:[UIImage imageNamed:@"SPLASH-5-bg"]];
                
                
            }
            else if (i==2)
            {
                
                [imgBg setFrame:CGRectMake(0, 0, 1024, 768)];
                [imgBg setImage:[UIImage imageNamed:@"SPLASH-1.1.png"]];
                
                [btnNext setHidden:YES];
                
                UIButton * btnGetStared = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnGetStared setFrame:CGRectMake(0,768-50, 1024, 50)];
                [btnGetStared setBackgroundColor:[UIColor clearColor]];
                [btnGetStared setBackgroundImage:[UIImage imageNamed:@"sky_blue_btn.png"] forState:UIControlStateNormal];
                btnGetStared.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
                [btnGetStared setTitle:NSLocalizedString(@"GET STARTED", nil) forState:UIControlStateNormal];
                [btnGetStared setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btnGetStared addTarget:self action:@selector(finshsplash) forControlEvents:UIControlEventTouchUpInside];
                [btnGetStared setBackgroundImage:[UIImage imageNamed:@"getstarted"] forState:UIControlStateNormal];
                [contentView addSubview:btnGetStared];
                
                [btnGetStared setFrame:CGRectMake(0,768-50, 1024, 50)];
                
            }
            
            xx = xx+scrlContent.frame.size.width;
        }
        
        if (IS_IPAD)
        {
            
            if (IS_OS_8_OR_LATER)
            {
                pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(367, scrlContent.frame.size.height - 150, 300, 60)];
            }
            else
            {
                pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrlContent.frame.size.height - 150, 800, 60)];
            }
            
            
        }
        else
        {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, contentView.frame.size.height - 100, 100, 20)];
            
        }
        pageControl.numberOfPages = 3;
        pageControl.tintColor = [UIColor blackColor];
        pageControl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"scroller-dot"]];
        pageControl.pageIndicatorTintColor=[UIColor blackColor];
        [self.view addSubview:pageControl];
        
    
}
-(void)btnNextClicked:(id)sender
{
    
    int numberOFProduct = 4 - 1;
    
    CGPoint scrollPoint = CGPointMake(scrlContent.contentOffset.x + scrlContent.frame.size.width ,0);
    

    if (scrlContent.contentOffset.x < scrlContent.frame.size.width*numberOFProduct
        ){
        
        //change the scroll view offset the the 3rd page so it will start from there
        [scrlContent setContentOffset:scrollPoint animated:YES];
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
        
        splitViewController.viewControllers = [NSArray arrayWithObjects:listNavController,mainNavController, nil];
        splitViewController.delegate = self;
        ap.window.rootViewController = splitViewController;
        

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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
