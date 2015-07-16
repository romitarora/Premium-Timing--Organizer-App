//
//  AddSponsorsView.h
//  organizer App
//
//  Created by Romit on 11/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "URLManager.h"
@interface AddSponsorsView : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate,URLManagerDelegate>
{
    UIView * navView;
    UIView * addSponsorsView;
    UIView * addNewSponsors;
    
    UILabel * titleLbl;
    UILabel * noticeMsgLbl;
    UILabel* websiteLbl;
    UILabel * sponsorNameLbl;
    
    UIButton * backBtn;
    UIButton * addBtn;
    UIButton * saveBtn;
    UIButton * cancelBtn;
    
    UITextField * txtWebUrl;
    UITextField * txtName;
    
    UIImageView * addImg;
    
    UITableView * sponsorsListTbl;
    UITableView * SelectedListTbl;

    UISearchBar * PTsearchBar;
    
    NSMutableArray *filteredContentArray;
    NSMutableArray * detailArr ;
    NSMutableArray * addSponsorArr;
    NSArray * myArray;
    NSArray * fieldArray;
    
    BOOL isClick;
    BOOL isSearching;
    BOOL isFromAdd;
    BOOL isClickNew;
    
    NSInteger selectedRow;
   NSMutableDictionary* sponsorDetailDict;
}
@property(nonatomic,strong)NSMutableArray *selectedArr;
@property BOOL isagainCome;
@property BOOL isFromEdit;
@end
