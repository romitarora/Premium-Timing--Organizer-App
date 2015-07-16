//
//  StagesViewController.h
//  organizer App
//
//  Created by Romit on 12/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface StagesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView * navView;
    UIView * splitsView;
    UIView * pickerView;
   
    UITableView * bleDeviceTbl;
    UITableView * stageDetailTbl;
    
    UITextField * txtstageName;
    UITextField * txtbluetooth;
    UITextField * txtsplitName;
    UITextField * txtsplitbluetooth;
   
    UIButton * cancelBtn;
    UIButton * saveBtn;
    UIButton * StartTimeBtn;
    UIButton * penaltyBtn;
    UIButton * backBtn;

    UIDatePicker * startTime;
    
    
    UILabel * titleLbl;
    UILabel * liasonTimeLbl;
    UILabel * liasonValueLbl;
    UILabel * startTimeValueLbl;
    UILabel * bleChipValueLbl;
    UILabel * penaltyValueLbl;
    UILabel * totalSplitValueLbl;
    UILabel * splitNameValueLbl;
    UILabel * splitBleValueLbl;
    UILabel * splitStartTimeLbl;
    UILabel * splitPenaltyTimeLbl;
    UILabel * stageNameLbl;
    UILabel * stageTimeLbl;
    UILabel * penaltyTimeLbl;
    UILabel * addSplitsLbl;

    NSMutableArray * times;
    NSMutableArray * deviceListArr;
    NSMutableArray * totalSplits;
    NSMutableDictionary * stageDetailDict;
    NSMutableDictionary * splitDetailDict;
    NSMutableDictionary * splitDetail;

    NSInteger selectedSplit;
    NSInteger splitIndex;
    NSString * stageId;
    
    UIView * chipPikerView;
    
    BOOL isClick;
    BOOL isEdit;
    BOOL isAdd;
    BOOL isFromSplit;
    BOOL isFromStage;

}
@property BOOL isFromEdit;
@property BOOL isEditstage;
@property BOOL isAddstage;
@property BOOL isFromDetail;
@property (nonatomic,strong)NSMutableArray * stageDetailArr;
@property (nonatomic,strong)NSMutableArray * eventStageDetailArr;

@property NSInteger selectedIndex;
@property (nonatomic,strong)NSString * eventId;
@property (nonatomic,strong)NSString * stageId;

@end
