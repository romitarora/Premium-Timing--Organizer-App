//
//  FindEventViewController.h
//  organizer App
//
//  Created by Romit on 25/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Leftmenu.h"
@interface FindEventViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
   
    UISearchBar * eventSearchBar;
    
    UILabel * titleLbl;
    UILabel * noticeMsgLbl;
   
    UIImageView * searchImg;
    UIImageView * filterImg;
    
    UIButton * filterBtn;
    
    UITableView * EventListTbl;

    NSMutableArray *filteredContentArray;
    NSMutableArray * eventListArr;
    NSArray *myArray;

    BOOL isSearching;
}
@end
