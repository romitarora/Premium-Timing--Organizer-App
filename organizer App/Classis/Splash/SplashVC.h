//
//  SplashVC.h
//  organizer App
//
//  Created by one click IT consultany on 6/19/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Welcome.h"
#import "Leftmenu.h"
#import "UpComingEventVC.h"
#import "AppDelegate.h"

@interface SplashVC : UIViewController<UIScrollViewDelegate,UISplitViewControllerDelegate>
{
    
    UIScrollView *scrlContent;
    UIButton *btnNext;
    UIPageControl *pageControl;
    
    UIView * tempv;
    UIButton * nextBtn,*secondBtn,*thirdBtn;
    UIView * firstImg,* secondImg,* thirdImg;
}

@end
