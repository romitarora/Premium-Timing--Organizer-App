//
//  splashview.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Welcome.h"
#import "Leftmenu.h"
#import "UpComingEventVC.h"
#import "AppDelegate.h"

@interface splashview : UIViewController<UIScrollViewDelegate,UISplitViewControllerDelegate>
{
   
    UIScrollView *scrlContent;
    UIButton *btnNext;
    UIPageControl *pageControl;
    
    UIView * tempv;
}
@end
@class Welcome;
