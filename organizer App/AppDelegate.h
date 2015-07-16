//
//  AppDelegate.h
//  organizer App
//
//  Created by i-MaC on 5/26/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "splashview.h"
#import "CalendarView.h"
#import "CustomCalendarViewController.h"
#import "Leftmenu.h"
#import "UpComingEventVC.h"
#import "DataBaseManager.h"
#import "SplashVC.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

NSString * SinkinSansRegularFont;
NSString * SinkinSansBoldFont;
NSString * SinkinSansItalicFont;
NSString * SinkinSansBoldItalicFont;
NSString * SinkinSansLightFont;
NSString * SinkinSansLightItalicFont;
NSString * monthScroll;
NSString * selecatedDateStr;
NSString * unixDatestr;
UILabel * lblMonth;//jam30-05

// BY RAJU 9-7-2015
NSDate *lastdate;

BOOL isFromSignUp;//jam
BOOL isEventEditView;
BOOL isEventSavedCorrect;

NSMutableArray * selectedListArr;
NSMutableArray * selectedSponsorList;
@class UpComingEventVC;
@class Leftmenu;

UISplitViewController *splitViewController;
UINavigationController *listNavController;
Leftmenu * listViewController;
UINavigationController *mainNavController;
UpComingEventVC *homeVC;
@class SplashVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UISplitViewControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD  *HUD;
    SplashVC * spl;
    UINavigationController * nav;
}

@property (strong, nonatomic) UIWindow *window;
-(void)hudForprocessMethod:(NSString *)text;
-(void)hudEndProcessMethod;
@end
