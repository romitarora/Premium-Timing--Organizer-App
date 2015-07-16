//
//  UpComingEventVC.h
//  organizer App
//
//  Created by Romit on 04/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomCalendarViewController.h"
#import "CreateEventViewController.h"
#import "Welcome.h"
#import "UpcomingEventCell.h"
#import "ParticipantsViewController.h"
#import "SponsorsViewController.h"
#import "ProfileSetUpVC.h"
#import "FindEventViewController.h"
#import "RaceResultViewController.h"
#import "NewsUpdateViewController.h"
#import "CurrentEventSettingVC.h"
#import "URLManager.h"

@class AppDelegate;
@interface UpComingEventVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISplitViewControllerDelegate,URLManagerDelegate>
{
    UIView * navView;
    AppDelegate * app;
    
    UIButton * backBtn;
    
    UILabel * titleLbl;
    UILabel * noticeMsgLbl;
    
    UITableView * EventListTbl;
    NSArray *myArray;
    NSMutableArray * eventListArr;
    NSInteger selectedRow;
   
    
}
@end
