//
//  AddParticipantsView.h
//  organizer App
//
//  Created by Romit on 11/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "URLManager.h"
@interface AddParticipantsView : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,URLManagerDelegate>
{
    UIView * numberView;
    
    BOOL isedit;
    
    UIView * navView;
    UIView * addparticipants;
    UIView * addNewComititor;
    
    UILabel * titleLbl;
    UILabel * noticeMsgLbl;
    UILabel * emailLbl;
    UILabel * nameLbl;
    UILabel * numberIdLbl;
    UILabel * nationalityLbl;
    
    NSMutableDictionary * participantsDict;
    
    UIButton * backBtn;
    UIButton * saveBtn;
    UIButton * cancelBtn;
    UIButton * addBtn;
    
    UIImageView * addImg;
    
    UITextField * txtemail;
    UITextField * txtName;
    UITextField * txtNumberId;
    UITextField * txtNationality;
    
    UISearchBar * PTsearchBar;
    UITableView * participantListTbl;
    UITableView * SelectedListTbl;
    
    
    NSMutableArray *filteredContentArray;
    NSMutableArray * detailArr ;
    NSMutableArray * newAddedArr;
    NSArray * myArray;
    NSArray * fieldArray;
    
    BOOL isClick;
    BOOL isSearching;
    BOOL isFromAdd;
    BOOL isClickNew;
    
    NSInteger selectedRow;
    
}
@property(nonatomic,strong)NSMutableArray *selectedArr;
@property BOOL isagainCome;
@property BOOL isFromEdit;

@end
