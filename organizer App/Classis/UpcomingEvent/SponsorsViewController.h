//
//  SponsorsViewController.h
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "URLManager.h"
@interface SponsorsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,URLManagerDelegate>
{
    UIView * navView;
    UILabel * titleLbl;
    UIButton * backBtn;
    
    UILabel* websiteLbl;
    UILabel * sponsorNameLbl;
    
    UITableView * sponsorsListTbl;
    UIView * backView;
    NSInteger selectedRow;
    NSMutableArray * detailArr;
    
    UIImageView * addImg;
    UIButton * addBtn;
    
    UIButton * saveBtn;
    UIButton * cancelBtn;
    
    UIView * sponsorsView;
    BOOL isClick;
    
    UITextField * txtName;
    UITextField * txtUrl;
    
    NSMutableDictionary * sponsorDetailDict;
}
@property BOOL isFromDetail;
@property (nonatomic,strong)NSString * eventId;
@end
