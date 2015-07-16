//
//  EventScheduleVC.h
//  organizer App
//
//  Created by One Click IT Consultancy  on 5/30/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomCalendarViewController.h"
#import "EventViewCell.h"
@interface EventScheduleVC : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UIButton * backBtn;
    UILabel * titleLbl;
    UILabel *  noticeMsgLbl;
    UISearchBar * eventSearchBar;
    UITableView * eventViewTbl;
    UILabel * dateLbl;
    NSMutableArray * tempEventArr ;
    NSArray *myArray;
    BOOL isSearching;
    NSMutableArray *filteredContentArray;

}
@property (nonatomic,strong)NSString *selectedDate;
@end
