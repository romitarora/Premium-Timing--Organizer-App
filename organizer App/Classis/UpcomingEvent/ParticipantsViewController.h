//
//  ParticipantsViewController.h
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "participantListCell.h"
#import "AddParticipantsView.h"
#import "URLManager.h"
@interface ParticipantsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,URLManagerDelegate>
{
    UIView * navView;
    UILabel * titleLbl;
    UIButton * backBtn;
    UITableView * participantListTbl;
    NSMutableArray *  detailArr;
    UIImageView * addImg;
    UIButton * addBtn;
    UIView * addparticipants;
    
    UITextField * txtemail;
    UITextField * txtName;
    UITextField * txtNumberId;
    UITextField * txtNationality;
    
    UILabel * emailLbl;
    UILabel * nameLbl;
    UILabel * numberIdLbl;
    UILabel * nationalityLbl;
    
    NSMutableDictionary * participantsDict;
    UIButton * saveBtn;
    UIButton * cancelBtn;
    BOOL isClick;
    BOOL  isedit;
    BOOL isFromAdd;
    
    NSArray * fieldArray;
    
    NSInteger  selectedRow;
}
@property(nonatomic,strong) NSMutableArray * totalParticipantsArr;
@property BOOL isFromDetail;
@property (nonatomic,strong)NSString * eventId;
@end
