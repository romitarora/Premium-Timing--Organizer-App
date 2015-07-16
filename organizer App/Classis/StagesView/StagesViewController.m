//
//  StagesViewController.m
//  organizer App
//
//  Created by Romit on 12/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "StagesViewController.h"

@interface StagesViewController ()

@end

@implementation StagesViewController
@synthesize isFromEdit,stageDetailArr,selectedIndex,eventId,isAddstage,isEditstage,isFromDetail,stageId,eventStageDetailArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationController.navigationBarHidden = YES;
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Stages";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    UIImageView * backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 12, 22);;
    backimg.image = [UIImage imageNamed:@"back.png"];
    [navView addSubview:backimg];

    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 100, 30);
    backBtn.backgroundColor = [UIColor clearColor];
  //  [backBtn setTitle:@"< Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:backBtn];
    
    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(navView.frame.size.width-100, 30, 100, 30);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:saveBtn];
    
    if (isFromDetail == YES)
    {
        saveBtn.hidden = YES;
    }
    else
    {
        saveBtn.hidden = NO;
    }
    
    stageDetailTbl =[[UITableView alloc] initWithFrame:CGRectMake(10, 80, 704-20, 768-80) style:UITableViewStylePlain];
    stageDetailTbl.backgroundColor = [UIColor clearColor];
    [stageDetailTbl setDelegate:self];
    [stageDetailTbl setDataSource:self];
    [stageDetailTbl setSeparatorColor:[UIColor clearColor]];
    [stageDetailTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    stageDetailTbl.showsVerticalScrollIndicator=NO;
    [self.view addSubview:stageDetailTbl];
    
    
    splitsView = [[UIView alloc]init];
    splitsView.frame = CGRectMake(0, 768, 704, 768);
    splitsView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    splitsView.hidden = YES;
    [self.view addSubview:splitsView];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [splitsView addSubview:navView];
    
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Add Split";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(10, 30, 100, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:cancelBtn];
    
    
    UIView * tempview=[[UIView alloc]init];
    tempview.frame = CGRectMake(30, 100, 704-60, 400);
    tempview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [splitsView addSubview:tempview];
    
    int yy;
    yy = 20;
    
    
    UIView * nameView=[[UIView alloc]init];
    nameView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    nameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:nameView];
    
    UIImageView * nameIcon = [[UIImageView alloc]init];
    nameIcon.backgroundColor = [UIColor clearColor];
    nameIcon.image  =[UIImage imageNamed:@"username"];
    nameIcon.frame = CGRectMake(10, 12.05, 25, 25);
//    [nameView addSubview:nameIcon];
    
    txtsplitName=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,nameView.frame.size.width-50, 50)];
    txtsplitName.textColor=[UIColor whiteColor];
    txtsplitName.keyboardType=UIKeyboardTypeEmailAddress;
    txtsplitName.textAlignment = NSTextAlignmentLeft;
    txtsplitName.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtsplitName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtsplitName.delegate = self;
    txtsplitName.placeholder = @"Enter Split Name";
    txtsplitName.returnKeyType=UIReturnKeyNext;
    txtsplitName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtsplitName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [nameView addSubview:txtsplitName];
    
    splitNameValueLbl = [[UILabel alloc]init];
    splitNameValueLbl.frame = CGRectMake(nameView.frame.size.width/2+10, 10, nameView.frame.size.width/2-20, 30);
    splitNameValueLbl.backgroundColor = [UIColor clearColor];
    splitNameValueLbl.textColor = [UIColor yellowColor];
    splitNameValueLbl.textAlignment = NSTextAlignmentRight;
    splitNameValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    
    [nameView addSubview:splitNameValueLbl];
    
    
    if ([[splitDetailDict valueForKey:@"split_name"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        splitBleValueLbl.text = [splitDetailDict valueForKey:@"split_name"];
    }
    
    
    yy = yy +70;
    
    UIView * bluetoothview=[[UIView alloc]init];
    bluetoothview.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    bluetoothview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:bluetoothview];
    
    UIButton * bleChipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bleChipBtn.frame =CGRectMake(10 ,0,bluetoothview.frame.size.width-50, 50);
    bleChipBtn.backgroundColor = [UIColor clearColor];
    [bleChipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bleChipBtn setTitle:@"Enter Bluetooth Chip Number" forState:UIControlStateNormal];
    bleChipBtn.titleLabel.font =[UIFont fontWithName:@"Century Gothic" size:20.0f];
    [bleChipBtn addTarget:self action:@selector(bleChipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bleChipBtn.tag = 22;
    bleChipBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    bleChipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
    
    [bluetoothview addSubview:bleChipBtn];
    
    splitBleValueLbl = [[UILabel alloc]init];
    splitBleValueLbl.frame = CGRectMake(bluetoothview.frame.size.width/2+10, 10, bluetoothview.frame.size.width/2-20, 30);
    splitBleValueLbl.backgroundColor = [UIColor clearColor];
    splitBleValueLbl.textColor = [UIColor yellowColor];
    splitBleValueLbl.textAlignment = NSTextAlignmentRight;
    splitBleValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    
    [bluetoothview addSubview:splitBleValueLbl];
    
    
    if ([[splitDetailDict valueForKey:@"device_name"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        splitBleValueLbl.text = [splitDetailDict valueForKey:@"device_name"];
    }
    
    yy = yy +70;
    
    UIView * startView = [[UIView alloc]init];
    startView.frame = CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    startView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:startView];
    

    StartTimeBtn  = [[UIButton alloc]init];
    StartTimeBtn.frame = CGRectMake(10 ,0,startView.frame.size.width-10, 50);
    StartTimeBtn.backgroundColor = [UIColor clearColor];
    [StartTimeBtn setTitle:@"Split Start Time" forState:UIControlStateNormal];
    StartTimeBtn.tag = 1;
    [StartTimeBtn addTarget:self action:@selector(StagesStartTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    StartTimeBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [StartTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    StartTimeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    StartTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;

    [startView addSubview:StartTimeBtn];
    
    splitStartTimeLbl = [[UILabel alloc]init];
    splitStartTimeLbl.frame = CGRectMake(StartTimeBtn.frame.size.width/2+10, 10, StartTimeBtn.frame.size.width/2-10, 30);
    splitStartTimeLbl.backgroundColor = [UIColor clearColor];
    splitStartTimeLbl.textColor = [UIColor yellowColor];
    splitStartTimeLbl.textAlignment = NSTextAlignmentRight;
    splitStartTimeLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    
    [startView addSubview:splitStartTimeLbl];
    
//    splitPenaltyTimeLbl
    if ([[splitDetailDict valueForKey:@"start_time"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        splitBleValueLbl.text = [splitDetailDict valueForKey:@"start_time"];
    }
    
    
    yy = yy +70;
    
    UIView * penaltyView = [[UIView alloc]init];
    penaltyView.frame = CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    penaltyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:penaltyView];
    
    penaltyBtn = [[UIButton alloc]init];
    penaltyBtn.frame = CGRectMake(10 ,0,penaltyView.frame.size.width-10, 50);
    penaltyBtn.backgroundColor = [UIColor clearColor];
    [penaltyBtn setTitle:@"Penalty Time" forState:UIControlStateNormal];
    penaltyBtn.tag = 1;
    [penaltyBtn addTarget:self action:@selector(penaltyTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    penaltyBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    penaltyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [penaltyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    penaltyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;

    [penaltyView addSubview:penaltyBtn];
    
    
    splitPenaltyTimeLbl = [[UILabel alloc]init];
    splitPenaltyTimeLbl.frame = CGRectMake(penaltyBtn.frame.size.width/2+10, 10, penaltyBtn.frame.size.width/2-10, 30);
    splitPenaltyTimeLbl.backgroundColor = [UIColor clearColor];
    splitPenaltyTimeLbl.textColor = [UIColor yellowColor];
    splitPenaltyTimeLbl.textAlignment = NSTextAlignmentRight;
    splitPenaltyTimeLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    
    if ([[splitDetailDict valueForKey:@"penalty_time"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        splitPenaltyTimeLbl.text = [splitDetailDict valueForKey:@"penalty_time"];
    }
    
    [penaltyView addSubview:splitPenaltyTimeLbl];
    
    
    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(0, tempview.frame.size.height-50, tempview.frame.size.width, 50);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tempview addSubview:saveBtn];
    isClick  = NO;
    
    stageDetailDict=[[NSMutableDictionary alloc] init];
    splitDetailDict = [[NSMutableDictionary alloc]init];

    
    if (isFromEdit)
    {
        if (isAddstage == YES)
        {
            stageDetailDict = [[NSMutableDictionary alloc]init];
            [stageDetailDict setValue:@"required" forKey:@"stage_name"];
            [stageDetailDict setValue:@"required" forKey:@"start_time"];
            [stageDetailDict setValue:@"required" forKey:@"device_name"];
            [stageDetailDict setValue:@"required" forKey:@"penalty_time"];
            [stageDetailDict setValue:@"required" forKey:@"liason_time"];
            [stageDetailDict setValue:@"required" forKey:@"TotalSplits"];
            [stageDetailDict setValue:@"required" forKey:@"device_id"];
            
            splitDetailDict = [[NSMutableDictionary alloc]init];
            
            [splitDetailDict setValue:@"required" forKey:@"split_name"];
            [splitDetailDict setValue:@"required" forKey:@"device_name"];
            [splitDetailDict setValue:@"required" forKey:@"start_time"];
            [splitDetailDict setValue:@"required" forKey:@"penalty_time"];
            [splitDetailDict setValue:@"required" forKey:@"device_id"];
            
            totalSplits=[[NSMutableArray alloc] init];

        }
        else
        {
            [stageDetailDict setValue:[stageDetailArr valueForKey:@"stage_name"] forKey:@"stage_name"];
            [stageDetailDict setValue:[stageDetailArr valueForKey:@"start_time"] forKey:@"start_time"];
            [stageDetailDict setValue:[stageDetailArr valueForKey:@"device_name"] forKey:@"device_name"];
            [stageDetailDict setValue:[stageDetailArr valueForKey:@"penalty_time"] forKey:@"penalty_time"];
            [stageDetailDict setValue:[stageDetailArr valueForKey:@"liason_time"] forKey:@"liason_time"];
            [stageDetailDict setValue:[stageDetailArr valueForKey:@"device_id"] forKey:@"device_id"];
            [stageDetailDict setValue:@"" forKey:@"TotalSplits"];
            
            
            totalSplits=[[NSMutableArray alloc] init];
            totalSplits = [[stageDetailArr valueForKey:@"splits"] mutableCopy];
            
            if (totalSplits.count == 0)
            {
                
            }
            else
            {
                [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"split_name"] forKey:@"split_name"];
                
                [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"device_name"] forKey:@"device_name"];
                
                [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"start_time"] forKey:@"start_time"];
                
                [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"penalty_time"] forKey:@"penalty_time"];
                
                [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"device_id"] forKey:@"device_id"];
                
            }
            
        }
        
    }
    else if (isFromDetail == YES)
    {
        
        [stageDetailDict setValue:[eventStageDetailArr valueForKey:@"stage_name"] forKey:@"stage_name"];
        [stageDetailDict setValue:[eventStageDetailArr valueForKey:@"start_time"] forKey:@"start_time"];
        [stageDetailDict setValue:[eventStageDetailArr valueForKey:@"device_name"] forKey:@"device_name"];
        [stageDetailDict setValue:[eventStageDetailArr valueForKey:@"penalty_time"] forKey:@"penalty_time"];
        [stageDetailDict setValue:[eventStageDetailArr valueForKey:@"liason_time"] forKey:@"liason_time"];
        [stageDetailDict setValue:[eventStageDetailArr valueForKey:@"device_id"] forKey:@"device_id"];
        
        [stageDetailDict setValue:@"" forKey:@"TotalSplits"];
        
        
        totalSplits=[[NSMutableArray alloc] init];
        
        
        NSString * strSplit = [NSString stringWithFormat:@"select * from Splits_Table where event_stage_id = '%@'",[eventStageDetailArr valueForKey:@"id"]];
        
        [[DataBaseManager dataBaseManager] execute:strSplit resultsArray:totalSplits];
        
        
       // totalSplits = [[eventStageDetailArr valueForKey:@"splits"] mutableCopy];
        
        if (totalSplits.count == 0)
        {
            
        }
        else
        {
            [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"split_name"] forKey:@"split_name"];
            
            [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"device_name"] forKey:@"device_name"];
            
            [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"start_time"] forKey:@"start_time"];
            
            [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"penalty_time"] forKey:@"penalty_time"];
            
            [splitDetailDict setValue:[[totalSplits objectAtIndex:selectedSplit] valueForKey:@"device_id"] forKey:@"device_id"];
        }
        
    

    }
    else
    {
        stageDetailDict = [[NSMutableDictionary alloc]init];
        [stageDetailDict setValue:@"required" forKey:@"stage_name"];
        [stageDetailDict setValue:@"required" forKey:@"start_time"];
        [stageDetailDict setValue:@"required" forKey:@"device_name"];
        [stageDetailDict setValue:@"required" forKey:@"penalty_time"];
        [stageDetailDict setValue:@"required" forKey:@"liason_time"];
        [stageDetailDict setValue:@"required" forKey:@"TotalSplits"];
        [stageDetailDict setValue:@"required" forKey:@"device_id"];
        
        splitDetailDict = [[NSMutableDictionary alloc]init];
        
        [splitDetailDict setValue:@"required" forKey:@"split_name"];
        [splitDetailDict setValue:@"required" forKey:@"device_name"];
        [splitDetailDict setValue:@"required" forKey:@"start_time"];
        [splitDetailDict setValue:@"required" forKey:@"penalty_time"];
        [splitDetailDict setValue:@"required" forKey:@"device_id"];
        
        totalSplits=[[NSMutableArray alloc] init];
        
    }
    
    deviceListArr = [[NSMutableArray alloc]init];
    
    NSString * strDeivce = [NSString stringWithFormat:@"select * from EventDevices_Table"];
    [[DataBaseManager dataBaseManager] execute:strDeivce resultsArray:deviceListArr];
    
  /*  deviceListArr=[[NSMutableArray alloc] init];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
    [dict setValue:@"1" forKey:@"device_id"];
    [dict setValue:@"ABCDEF1" forKey:@"factory_id"];
    [dict setValue:@"Device 1" forKey:@"name"];
    [dict setValue:@"yes" forKey:@"verified"];
    [dict setValue:@"2 min" forKey:@"penalty_time"];
    
    NSMutableDictionary * dict1 =[[NSMutableDictionary alloc] init];
    [dict1 setValue:@"2" forKey:@"device_id"];
    [dict1 setValue:@"ABCDEF1" forKey:@"factory_id"];
    [dict1 setValue:@"Device 2" forKey:@"name"];
    [dict1 setValue:@"yes" forKey:@"verified"];
    [dict1 setValue:@"5 min" forKey:@"penalty_time"];
    
    NSMutableDictionary * dict2 =[[NSMutableDictionary alloc] init];
    [dict2 setValue:@"3" forKey:@"device_id"];
    [dict2 setValue:@"ABCDEF1" forKey:@"factory_id"];
    [dict2 setValue:@"Device 3" forKey:@"name"];
    [dict2 setValue:@"yes" forKey:@"verified"];
    [dict2 setValue:@"6 min" forKey:@"penalty_time"];
    
    NSMutableDictionary * dict3 =[[NSMutableDictionary alloc] init];
    [dict3 setValue:@"4" forKey:@"device_id"];
    [dict3 setValue:@"ABCDEF1" forKey:@"factory_id"];
    [dict3 setValue:@"Device 4" forKey:@"name"];
    [dict3 setValue:@"yes" forKey:@"verified"];
    [dict3 setValue:@"4 min" forKey:@"penalty_time"];
    
//    NSMutableDictionary * dict4 =[[NSMutableDictionary alloc] init];
//    [dict4 setValue:@"Marsh" forKey:@"device_id"];
//    [dict4 setValue:@"ABCDEF1" forKey:@"factory_id"];
//    [dict4 setValue:@"24" forKey:@"compititorNumber"];
//    [dict4 setValue:@"yes" forKey:@"verified"];
//    [dict4 setValue:@"5 min" forKey:@"penalty_time"];
    
    [deviceListArr addObject:dict];
    [deviceListArr addObject:dict1];
    [deviceListArr addObject:dict2];
    [deviceListArr addObject:dict3];
//    [deviceListArr addObject:dict4];*/

    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
}
#pragma mark Button Click Event
-(void)backBtnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setPaging" object:nil];

    [self.navigationController popViewControllerAnimated:YES];
     //[self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Pickerview Methods
-(void)StagesStartTimeClick:(id)sender
{
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    [pickerView removeFromSuperview];
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(192.5, 768, 320, 300)];
    
    [UIView transitionWithView:pickerView
                      duration:0.30
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        else
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        
                        
                    }
                    completion:nil];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pickerView.layer.borderWidth = 1.0f;
    [self.view addSubview:pickerView];
    
    UIView *backTitlt =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    backTitlt.backgroundColor=[UIColor darkGrayColor];
    [pickerView addSubview:backTitlt];
    
    //    For PickerView
    startTime = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,50, 320, 250)];
    startTime.datePickerMode=UIDatePickerModeTime;
    startTime.timeZone = [NSTimeZone localTimeZone];
    [pickerView addSubview:startTime];
    
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Date";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([sender tag]==1)
    {
        [btnDone addTarget:self action:@selector(splitStartDone:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btnDone addTarget:self action:@selector(StageDoneClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    [backTitlt addSubview:btnDone];
    
}
-(void)penaltyTimeClick:(id)sender
{
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    [pickerView removeFromSuperview];
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(192.5, 768, 320, 300)];
    
    [UIView transitionWithView:pickerView
                      duration:0.30
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        else
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        
                        
                    }
                    completion:nil];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pickerView.layer.borderWidth = 1.0f;
    [self.view addSubview:pickerView];
    
    UIView *backTitlt =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    backTitlt.backgroundColor=[UIColor darkGrayColor];
    [pickerView addSubview:backTitlt];
    
    //    For PickerView
    startTime = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,50, 320, 250)];
    startTime.datePickerMode=UIDatePickerModeTime;
    startTime.timeZone = [NSTimeZone localTimeZone];
    [pickerView addSubview:startTime];
    
    
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Date";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([sender tag]==1)
    {
        [btnDone addTarget:self action:@selector(paneltyDoneBtn1:) forControlEvents:UIControlEventTouchUpInside];

    }
    else
    {
        [btnDone addTarget:self action:@selector(paneltyDoneBtn:) forControlEvents:UIControlEventTouchUpInside];


    }
    [backTitlt addSubview:btnDone];
}

-(void)liasonTimeClick:(id)sender
{
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    [pickerView removeFromSuperview];
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(192.5, 768, 320, 300)];
    
    [UIView transitionWithView:pickerView
                      duration:0.30
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        else
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        
                        
                    }
                    completion:nil];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pickerView.layer.borderWidth = 1.0f;
    [self.view addSubview:pickerView];
    
    UIView *backTitlt =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    backTitlt.backgroundColor=[UIColor darkGrayColor];
    [pickerView addSubview:backTitlt];
    
    //    For PickerView
    startTime = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,50, 320, 250)];
    startTime.datePickerMode=UIDatePickerModeTime;
    startTime.timeZone = [NSTimeZone localTimeZone];
    [pickerView addSubview:startTime];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Date";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnDone addTarget:self action:@selector(liasonDone:) forControlEvents:UIControlEventTouchUpInside];
    [backTitlt addSubview:btnDone];
}

-(void)bleChipBtnClick:(id)sender
{
    [pickerView removeFromSuperview];
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    
    if ([sender tag]==22)
    {
        isFromSplit = YES;
        isFromStage = NO;
    }
    else if ([sender tag]==44)
    {
        isFromStage = YES;
        isFromSplit = NO;
    }

    pickerView = [[UIView alloc]initWithFrame:CGRectMake(192.5, 768, 320, 300)];
    
    [UIView transitionWithView:pickerView
                      duration:0.30
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        else
                        {
                            [pickerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                        }
                        
                        
                    }
                    completion:nil];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pickerView.layer.borderWidth = 1.0f;
    [self.view addSubview:pickerView];
    
    UIView *backTitlt =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    backTitlt.backgroundColor=[UIColor darkGrayColor];
    [pickerView addSubview:backTitlt];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Device";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone addTarget:self action:@selector(deviceDoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backTitlt addSubview:btnDone];
    
    bleDeviceTbl =[[UITableView alloc] initWithFrame:CGRectMake(0 ,50, 320, 250) style:UITableViewStylePlain];
    bleDeviceTbl.backgroundColor = [UIColor clearColor];
    [bleDeviceTbl setDelegate:self];
    [bleDeviceTbl setDataSource:self];
    [bleDeviceTbl setSeparatorColor:[UIColor clearColor]];
    [bleDeviceTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    bleDeviceTbl.showsVerticalScrollIndicator=NO;
    [pickerView addSubview:bleDeviceTbl];

}

#pragma mark - Done Method Click


-(void)paneltyDoneBtn:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:startTime.date];
    [stageDetailDict setValue:currentTime forKey:@"penalty_time"];
    [pickerView setHidden:YES];
    
    [stageDetailTbl reloadData];

}
-(void)paneltyDoneBtn1:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:startTime.date];
    [pickerView setHidden:YES];
    splitPenaltyTimeLbl.text=currentTime;
    
    [stageDetailTbl reloadData];
    
}

-(void)liasonDone:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:startTime.date];
    [stageDetailDict setValue:currentTime forKey:@"liason_time"];
    [pickerView setHidden:YES];
    
    [stageDetailTbl reloadData];

}

-(void)StageDoneClick:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:startTime.date];
    stageTimeLbl.text = currentTime;
    [stageDetailDict setObject:currentTime forKey:@"start_time"];
    [pickerView setHidden:YES];
    
    [stageDetailTbl reloadData];
    
}

-(void)splitStartDone:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:startTime.date];
    [pickerView setHidden:YES];
    
    splitStartTimeLbl.text=currentTime;
    [stageDetailTbl reloadData];
    
}
-(void)deviceDoneClick:(id)sender
{
    [stageDetailTbl reloadData];
     [pickerView setHidden:YES];
}
#pragma mark - Other Button Click
-(void)cancelBtnClick
{
    [pickerView removeFromSuperview];
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    isClick=NO;
    
    [UIView transitionWithView:splitsView
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [splitsView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [splitsView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;
    
}

-(void)addBtnClick:(id)sender
{
    isEdit = NO;
    isAdd = YES;
    splitNameValueLbl.text = @"";
    splitStartTimeLbl.text  = @"";
    splitPenaltyTimeLbl.text = @"";
    splitBleValueLbl.text =@"";
    
    [pickerView removeFromSuperview];
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    
    if (isClick==NO)
    {
        isClick=YES;
        splitsView.hidden = NO;
        
        [UIView transitionWithView:splitsView
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [splitsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            else
                            {
                                [splitsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            
                            
                        }
                        completion:nil];
        ;
    }
    
}
-(void)editSplitDetail:(id)sender
{
    
    if (isFromEdit == YES)
    {
        isEdit = YES;
        isAdd = NO;
        splitNameValueLbl.text = [splitDetail valueForKey:@"split_name"];
        splitStartTimeLbl.text  = [splitDetail valueForKey:@"start_time"];
        splitPenaltyTimeLbl.text = [splitDetail valueForKey:@"penalty_time"];
        splitBleValueLbl.text =[splitDetail valueForKey:@"device_name"];
        
    }
    [pickerView removeFromSuperview];
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    
    if (isClick==NO)
    {
        isClick=YES;
        splitsView.hidden = NO;
        
        [UIView transitionWithView:splitsView
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [splitsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            else
                            {
                                [splitsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            
                            
                        }
                        completion:nil];
        ;
    }
    
}
-(void)saveBtnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setPaging" object:nil];

    [pickerView removeFromSuperview];
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    
    if ([[stageDetailDict valueForKey:@"stage_name"] isEqualToString:@"required"]|[stageNameLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Stage Name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([[stageDetailDict valueForKey:@"start_time"] isEqualToString:@"required"]|[startTimeValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Start Time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([[stageDetailDict valueForKey:@"device_name"] isEqualToString:@"required"]|[bleChipValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Bluetooth Chip Number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([[stageDetailDict valueForKey:@"penalty_time"] isEqualToString:@"required"]|[penaltyValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Penalty Time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([stageNameLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Stage Name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([bleChipValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Bluetooth Chip Number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([[stageDetailDict valueForKey:@"liason_time"] isEqualToString:@"required"]|[liasonValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Liason Time" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary * totalStagesDict =[[NSMutableDictionary alloc] init];
        [totalStagesDict setObject:stageNameLbl.text forKey:@"stage_name"];
        [totalStagesDict setObject:startTimeValueLbl.text forKey:@"start_time"];
        [totalStagesDict setObject:penaltyValueLbl.text forKey:@"penalty_time"];
        [totalStagesDict setObject:bleChipValueLbl.text forKey:@"device_name"];
        [totalStagesDict setObject:liasonValueLbl.text forKey:@"liason_time"];
        [totalStagesDict setObject:[stageDetailDict valueForKey:@"device_id"] forKey:@"device_id"];
        
        if (totalSplits.count == 0)
        {
            
        }
        else
        {
            [totalStagesDict setObject:totalSplits forKey:@"splits"];

        }
        
        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
        tempArr=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"totalStage"] mutableCopy];
        
        if (isFromEdit == YES)
        {
            if ([tempArr count]==0)
            {
                tempArr=[[NSMutableArray alloc] init];
                [tempArr addObject:totalStagesDict];
            }
            else
            {
                if (isAddstage == YES)
                {
                    [totalStagesDict setValue:eventId forKey:@"event_id"];
                   NSInteger stage_id = [[DataBaseManager dataBaseManager] insertStagesDetail:totalStagesDict];
                    
                   NSString * newstageId = [NSString stringWithFormat:@"%d",stage_id];
                    
                    for (int k = 0; k<[totalSplits count]; k++)
                    {
                        NSMutableDictionary * dict1 = [[NSMutableDictionary alloc]init];
                        dict1 =[[totalSplits objectAtIndex:k] mutableCopy];
                        
                        [dict1 setValue:newstageId forKey:@"stage_id"];
                        [totalSplits replaceObjectAtIndex:k withObject:dict1];
                        
                        [[DataBaseManager dataBaseManager] insertSplitsDetail:[totalSplits objectAtIndex:k]];
                    }

                    [tempArr addObject:totalStagesDict];
                }
                else if (isEditstage == YES)
                {
                    [totalStagesDict setValue:[[tempArr objectAtIndex:selectedIndex] valueForKey:@"event_id"] forKey:@"event_id"];
                    
                    [totalStagesDict setValue:[[tempArr objectAtIndex:selectedIndex] valueForKey:@"id"] forKey:@"id"];
                    
                    [tempArr removeObjectAtIndex:selectedIndex];
                    [tempArr insertObject:totalStagesDict atIndex:selectedIndex];
                }
            }
        }
        else
        {
            if ([tempArr count]==0)
            {
                tempArr=[[NSMutableArray alloc] init];
                [tempArr addObject:totalStagesDict];
            }
            else
            {
                [tempArr addObject:totalStagesDict];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:tempArr forKey:@"totalStage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatingView" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
-(void)saveUser
{
    [pickerView removeFromSuperview];
    [txtsplitName resignFirstResponder];
    [txtstageName resignFirstResponder];
    
    if ([splitNameValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Split Name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([splitStartTimeLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Split Start Time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([splitPenaltyTimeLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Split Penalty Time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([splitNameValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter  Split Name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([splitBleValueLbl.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Split Bluetooth Chip Number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        {
            isClick=NO;
            splitsView.hidden = NO;
            
            [UIView transitionWithView:splitsView
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [splitsView setFrame:CGRectMake(0, 768, 704,768)];
                                }
                                else
                                {
                                    [splitsView setFrame:CGRectMake(0, 768, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            
            ;
        }
        
        NSMutableDictionary * tempDict =[[NSMutableDictionary alloc] init];
        [tempDict setObject:splitNameValueLbl.text forKey:@"split_name"];
        [tempDict setObject:splitStartTimeLbl.text forKey:@"start_time"];
        [tempDict setObject:splitPenaltyTimeLbl.text forKey:@"penalty_time"];
        [tempDict setObject:splitBleValueLbl.text forKey:@"device_name"];
        [tempDict setObject:[splitDetailDict valueForKey:@"device_id"] forKey:@"device_id"];
        
        if (isFromEdit == YES)
        {
            if ([totalSplits count]==0)
            {
                if (stageDetailArr.count == 0)
                {
                    totalSplits=[[NSMutableArray alloc] init];
                    [totalSplits addObject:tempDict];
                }
                else
                {
                    totalSplits=[[NSMutableArray alloc] init];
                    [tempDict setObject:[stageDetailArr valueForKey:@"id"] forKey:@"stage_id"];
                    [[DataBaseManager dataBaseManager] insertSplitsDetail:tempDict];
                    [totalSplits addObject:tempDict];
                }
                
            }
            else
            {
                if (isAdd == YES)
                {
                    
                   [tempDict setObject:[stageDetailArr valueForKey:@"id"] forKey:@"stage_id"];
                    [[DataBaseManager dataBaseManager] insertSplitsDetail:tempDict];
                    [totalSplits addObject:tempDict];
                }
                else if (isEdit == YES)
                {
                    [tempDict setValue:[[totalSplits objectAtIndex:selectedSplit-6] valueForKey:@"id"] forKey:@"id"];
                      [tempDict setValue:[[totalSplits objectAtIndex:selectedSplit-6] valueForKey:@"stage_id"] forKey:@"stage_id"];
                    
                    [totalSplits removeObjectAtIndex:selectedSplit-6];
                    [totalSplits insertObject:tempDict atIndex:selectedSplit-6];
                    
                    [[DataBaseManager dataBaseManager] updateSplits:tempDict with:[[totalSplits objectAtIndex:selectedSplit-6] valueForKey:@"id"]];
                }
            }
        }
        else
        {
            if ([totalSplits count]==0)
            {
                totalSplits=[[NSMutableArray alloc] init];
                [totalSplits addObject:tempDict];
            }
            else
            {
                [totalSplits addObject:tempDict];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:totalSplits forKey:@"totalSplit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        splitNameValueLbl.text=@"";
        splitStartTimeLbl.text=@"";
        splitPenaltyTimeLbl.text=@"";
        splitBleValueLbl.text=@"";
        
        [stageDetailTbl reloadData];
    }
   
}
-(void)deleteBtnClick:(id)sender

{
    splitIndex = [sender tag];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this split?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 5;
    [alert show];
   
}
#pragma mark AlertView Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            NSString * splitDelete = [NSString stringWithFormat:@"Delete from Splits_Table where id = '%@'",[[totalSplits objectAtIndex:splitIndex] valueForKey:@"id"]];
            
            [[DataBaseManager dataBaseManager]execute:splitDelete];
            [totalSplits removeObjectAtIndex:splitIndex];
            
            [[NSUserDefaults standardUserDefaults] setObject:totalSplits forKey:@"totalSplit"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [stageDetailTbl reloadData];
        }
        else
        {
            
        }
    }
}
#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == bleDeviceTbl)
    {
        return 50;
    }
    else
    {
        if (indexPath.row==0||indexPath.row==1||indexPath.row==2||indexPath.row==3||indexPath.row==4||indexPath.row==5)
        {
            return 50;
        }
        else
        {
            return 100;
        }

    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == bleDeviceTbl)
    {
        return [deviceListArr count];
    }
    else
    {
        return 6+[totalSplits count];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier=nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (tableView == bleDeviceTbl)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell.textLabel.text =[[deviceListArr objectAtIndex:indexPath.row]valueForKey:@"name"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel * line = [[UILabel alloc]init];
        line.frame = CGRectMake(0, 49, cell.frame.size.width, 1);
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
    }
    else
    {
        if (indexPath.row == 0)
        {
            txtstageName=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,stageDetailTbl.frame.size.width-20, 50)];
            txtstageName.textColor=[UIColor whiteColor];
            txtstageName.textAlignment = NSTextAlignmentLeft;
            txtstageName.contentVerticalAlignment =
            UIControlContentVerticalAlignmentCenter;
            [txtstageName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            txtstageName.delegate = self;
            txtstageName.placeholder = @"Enter Stage Name";
            //        txtstageName.text=@"Enter Stage Name";
            txtstageName.returnKeyType=UIReturnKeyNext;
            txtstageName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [txtstageName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell.contentView addSubview:txtstageName];
            
            stageNameLbl = [[UILabel alloc]init];
            stageNameLbl.frame = CGRectMake(stageDetailTbl.frame.size.width/2+10, 10, stageDetailTbl.frame.size.width/2-20, 30);
            stageNameLbl.backgroundColor = [UIColor clearColor];
            stageNameLbl.textColor = [UIColor yellowColor];
            stageNameLbl.textAlignment = NSTextAlignmentRight;
            stageNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [cell.contentView addSubview:stageNameLbl];
            
            
            if ([[stageDetailDict valueForKey:@"stage_name"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                stageNameLbl.text = [stageDetailDict valueForKey:@"stage_name"];
            }
            
            if (isFromDetail == YES)
            {
                txtstageName.userInteractionEnabled = NO;
            }
        }
        else if (indexPath.row == 1)
        {
            stageTimeLbl = [[UILabel alloc]init];
            stageTimeLbl.frame = CGRectMake(10 ,0,stageDetailTbl.frame.size.width-20, 50);
            stageTimeLbl.text = @"Enter Stage Time";
            stageTimeLbl.backgroundColor = [UIColor clearColor];
            stageTimeLbl.textAlignment = NSTextAlignmentLeft;
            stageTimeLbl.textColor = [UIColor whiteColor];
            stageTimeLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [cell.contentView addSubview:stageTimeLbl];
            
            
            startTimeValueLbl = [[UILabel alloc]init];
            startTimeValueLbl.frame = CGRectMake(stageDetailTbl.frame.size.width/2+10, 10, stageDetailTbl.frame.size.width/2-20, 30);
            startTimeValueLbl.backgroundColor = [UIColor clearColor];
            startTimeValueLbl.textColor = [UIColor yellowColor];
            startTimeValueLbl.textAlignment = NSTextAlignmentRight;
            startTimeValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [cell.contentView addSubview:startTimeValueLbl];
            
            if ([[stageDetailDict valueForKey:@"start_time"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                startTimeValueLbl.text = [stageDetailDict valueForKey:@"start_time"];
            }
        }
        else if (indexPath.row == 2)
        {
            
            UIButton * bleChipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bleChipBtn.frame =CGRectMake(10 ,0,stageDetailTbl.frame.size.width-20, 50);
            bleChipBtn.backgroundColor = [UIColor clearColor];
            [bleChipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bleChipBtn setTitle:@"Enter Bluetooth Chip Number" forState:UIControlStateNormal];
            bleChipBtn.titleLabel.font =[UIFont fontWithName:@"Century Gothic" size:20.0f];
            [bleChipBtn addTarget:self action:@selector(bleChipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            bleChipBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            bleChipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            bleChipBtn.tag = 44;
            [cell.contentView addSubview:bleChipBtn];
            
            
            bleChipValueLbl = [[UILabel alloc]init];
            bleChipValueLbl.frame = CGRectMake(stageDetailTbl.frame.size.width/2+10, 10, stageDetailTbl.frame.size.width/2-20, 30);
            bleChipValueLbl.backgroundColor = [UIColor clearColor];
            bleChipValueLbl.textColor = [UIColor yellowColor];
            bleChipValueLbl.textAlignment = NSTextAlignmentRight;
            bleChipValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [cell.contentView addSubview:bleChipValueLbl];
            
            if ([[stageDetailDict valueForKey:@"device_name"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                bleChipValueLbl.text = [stageDetailDict valueForKey:@"device_name"];
            }
            
            if (isFromDetail == YES)
            {
                bleChipBtn.userInteractionEnabled = NO;
            }
        }
        else if (indexPath.row == 3)
        {
            penaltyTimeLbl = [[UILabel alloc]init];
            penaltyTimeLbl.frame = CGRectMake(10 ,0,stageDetailTbl.frame.size.width-20, 50);
            penaltyTimeLbl.text = @"Enter Penalty Time";
            penaltyTimeLbl.backgroundColor = [UIColor clearColor];
            penaltyTimeLbl.textAlignment = NSTextAlignmentLeft;
            penaltyTimeLbl.textColor = [UIColor whiteColor];
            [penaltyTimeLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            [cell.contentView addSubview:penaltyTimeLbl];
            
            
            penaltyValueLbl = [[UILabel alloc]init];
            penaltyValueLbl.frame = CGRectMake(stageDetailTbl.frame.size.width/2+10, 10, stageDetailTbl.frame.size.width/2-20, 30);
            penaltyValueLbl.backgroundColor = [UIColor clearColor];
            penaltyValueLbl.textColor = [UIColor yellowColor];
            penaltyValueLbl.textAlignment = NSTextAlignmentRight;
            penaltyValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [cell.contentView addSubview:penaltyValueLbl];
            
            if ([[stageDetailDict valueForKey:@"penalty_time"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                penaltyValueLbl.text = [stageDetailDict valueForKey:@"penalty_time"];
            }
        }
        else if (indexPath.row == 4)
        {
            
            liasonTimeLbl = [[UILabel alloc]init];
            liasonTimeLbl.frame = CGRectMake(10 ,0,stageDetailTbl.frame.size.width-20, 50);
            liasonTimeLbl.text = @"Enter Liason Time";
            liasonTimeLbl.backgroundColor = [UIColor clearColor];
            liasonTimeLbl.textAlignment = NSTextAlignmentLeft;
            liasonTimeLbl.textColor = [UIColor whiteColor];
            [liasonTimeLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            [cell.contentView addSubview:liasonTimeLbl];
            
            
            
            liasonValueLbl = [[UILabel alloc]init];
            liasonValueLbl.frame = CGRectMake(stageDetailTbl.frame.size.width/2+10, 10, stageDetailTbl.frame.size.width/2-20, 30);
            liasonValueLbl.backgroundColor = [UIColor clearColor];
            liasonValueLbl.textColor = [UIColor yellowColor];
            liasonValueLbl.textAlignment = NSTextAlignmentRight;
            liasonValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [cell.contentView addSubview:liasonValueLbl];
            
            if ([[stageDetailDict valueForKey:@"liason_time"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                liasonValueLbl.text = [stageDetailDict valueForKey:@"liason_time"];
            }
        }
        else if (indexPath.row == 5)
        {
            UIImageView * addImg =[[UIImageView alloc] init];
            addImg.frame=CGRectMake(140, 9, 32, 32);
            addImg.image=[UIImage imageNamed:@"create_Ipad"];
            [cell.contentView addSubview:addImg];
            
            addSplitsLbl = [[UILabel alloc]init];
            addSplitsLbl.frame = CGRectMake(10 ,0,stageDetailTbl.frame.size.width-20, 50);
            addSplitsLbl.text = @"Add Split";
            addSplitsLbl.backgroundColor = [UIColor clearColor];
            addSplitsLbl.textAlignment = NSTextAlignmentLeft;
            addSplitsLbl.textColor = [UIColor whiteColor];
            [addSplitsLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            [cell.contentView addSubview:addSplitsLbl];
            
            totalSplitValueLbl = [[UILabel alloc]init];
            totalSplitValueLbl.frame = CGRectMake(stageDetailTbl.frame.size.width/2+10, 10, stageDetailTbl.frame.size.width/2-20, 30);
            totalSplitValueLbl.backgroundColor = [UIColor clearColor];
            totalSplitValueLbl.textColor = [UIColor yellowColor];
            totalSplitValueLbl.textAlignment = NSTextAlignmentRight;
            totalSplitValueLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [cell.contentView addSubview:totalSplitValueLbl];
            
            if ([[stageDetailDict valueForKey:@"TotalSplits"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                totalSplitValueLbl.text = [stageDetailDict valueForKey:@"TotalSplits"];
            }
            
            if (isFromDetail == YES)
            {
                addSplitsLbl.text = @"Splits";
                addImg.hidden = YES;
            }
            else
            {
                addImg.hidden = NO;
            }
            
        }
        else
        {
            UILabel *  splitName = [[UILabel alloc]init];
            splitName.frame = CGRectMake(10 ,15,300, 30);
            splitName.text = [[totalSplits objectAtIndex:indexPath.row-6] objectForKey:@"split_name"];
            splitName.backgroundColor = [UIColor clearColor];
            splitName.textAlignment = NSTextAlignmentCenter;
            splitName.textColor = [UIColor whiteColor];
            [splitName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            splitName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield"]];
            [cell.contentView addSubview:splitName];
            
            
            UILabel *  chipLbl = [[UILabel alloc]init];
            chipLbl.frame = CGRectMake(320 ,15,300, 30);
            chipLbl.text = [NSString stringWithFormat:@"BLE Chip : %@",[[totalSplits objectAtIndex:indexPath.row-6] objectForKey:@"device_name"]];
            
            chipLbl.backgroundColor = [UIColor clearColor];
            chipLbl.textAlignment = NSTextAlignmentCenter;
            chipLbl.textColor = [UIColor whiteColor];
            [chipLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            chipLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield"]];
            [cell.contentView addSubview:chipLbl];
            
            UILabel *  startTimeLbl = [[UILabel alloc]init];
            startTimeLbl.frame = CGRectMake(10 ,55,300, 30);
            startTimeLbl.text = [NSString stringWithFormat:@"Start Time : %@",[[totalSplits objectAtIndex:indexPath.row-6] objectForKey:@"start_time"]];
            
            startTimeLbl.backgroundColor = [UIColor clearColor];
            startTimeLbl.textAlignment = NSTextAlignmentCenter;
            startTimeLbl.textColor = [UIColor whiteColor];
            [startTimeLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            startTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield"]];
            [cell.contentView addSubview:startTimeLbl];
            
            
            UILabel *  PenaltyTimeLbl = [[UILabel alloc]init];
            PenaltyTimeLbl.frame = CGRectMake(320 ,55,300, 30);
            PenaltyTimeLbl.text = [NSString stringWithFormat:@"Penalty Time : %@",[[totalSplits objectAtIndex:indexPath.row-6] objectForKey:@"penalty_time"]];
            PenaltyTimeLbl.backgroundColor = [UIColor clearColor];
            PenaltyTimeLbl.textAlignment = NSTextAlignmentCenter;
            PenaltyTimeLbl.textColor = [UIColor whiteColor];
            [PenaltyTimeLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            PenaltyTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield"]];
            [cell.contentView addSubview:PenaltyTimeLbl];
            
            UIButton * deleteBtn = [[UIButton alloc]init];
            deleteBtn.frame = CGRectMake(stageDetailTbl.frame.size.width-50, 35, 30, 30);
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            deleteBtn.backgroundColor = [UIColor clearColor];
            deleteBtn.tag = indexPath.row-6;
            [deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:deleteBtn];
            
            if (indexPath.row %2)
            {
                splitName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
                
                chipLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
                
                startTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
                
                PenaltyTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
            }
            else
            {
                splitName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
                
                chipLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
                
                startTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
                
                PenaltyTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
            }
            
            if (isFromDetail == YES)
            {
                deleteBtn.hidden = YES;
            }
            else
            {
                deleteBtn.hidden = NO;
            }
            
            
        }

    }
        return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == bleDeviceTbl)
    {
        cell.backgroundColor =[UIColor whiteColor];
        
    }
    else
    {
        if (indexPath.row == 0 || indexPath.row == 1||indexPath.row == 2 || indexPath.row == 3 ||indexPath.row == 4 || indexPath.row == 5)
        {
            if (indexPath.row %2)
            {
                cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellLine1.png"]];
            }
            else
            {
                cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellLine2.png"]];
            }
            
        }
        else
        {
            if (indexPath.row %2)
            {
                cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"light.png"]];
            }
            else
            {
                
                cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark.png"]];
            }
        }
        

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFromDetail == YES)
    {
        
    }
    else
    {
        if (tableView == bleDeviceTbl)
        {
            if (isFromSplit == YES)
            {
                
                splitBleValueLbl.text =[[deviceListArr objectAtIndex:indexPath.row] valueForKey:@"name"];
                [splitDetailDict setValue:[[deviceListArr objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"device_name"];
                [splitDetailDict setValue:[[deviceListArr objectAtIndex:indexPath.row] valueForKey:@"device_id"] forKey:@"device_id"];
               
                
            }
            else if (isFromStage == YES)
            {
                [stageDetailDict setValue:[[deviceListArr objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"device_name"];
                
                [stageDetailDict setValue:[[deviceListArr objectAtIndex:indexPath.row] valueForKey:@"device_id"] forKey:@"device_id"];
                
            }
            
        }
        else
        {
            if (indexPath.row == 1)
            {
                [self StagesStartTimeClick:nil];
            }
            else if (indexPath.row == 3)
            {
                [self penaltyTimeClick:nil];
            }
            else if (indexPath.row == 4)
            {
                [self liasonTimeClick:nil];
            }
            else if (indexPath.row == 5)
            {
                [self addBtnClick:nil];
            }
            else
            {
                isFromEdit = YES;
                selectedSplit = indexPath.row;
                splitDetail = [[NSMutableDictionary alloc]init];
                splitDetail = [totalSplits objectAtIndex:indexPath.row-6];
                [self editSplitDetail:nil];
            }

        }
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [pickerView removeFromSuperview];
    if (textField == txtstageName)
    {
        stageNameLbl.hidden = YES;
        txtstageName.text = stageNameLbl.text;
        [stageDetailDict setValue:textField.text forKey:@"stage_name"];
        
    }
   else if (textField == txtsplitName)
    {
        splitNameValueLbl.hidden = YES;
        txtsplitName.text = splitNameValueLbl.text;
        [splitDetailDict setValue:textField.text forKey:@"split_name"];
        
    }
   
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txtstageName)
    {
        stageNameLbl.hidden = NO;
        stageNameLbl.text = textField.text;
        [stageDetailDict setValue:textField.text forKey:@"stage_name"];
        txtstageName.text=@"";
    }
    else if (textField == txtsplitName)
    {
        splitNameValueLbl.hidden = NO;
        splitNameValueLbl.text = textField.text;
        [splitDetailDict setValue:textField.text forKey:@"split_name"];
        txtsplitName.text=@"";

        
    }
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtstageName)
    {
        
    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Time
- (void)generateTimes1
{
    times = [[NSMutableArray alloc] init];
    NSString *current;
    for (int i=0 ;i<24; i++)
    {
        
        for (int j=0; j<4; j++)
        {
            if (i<10)
            {
                switch (j)
                {
                    case 0:
                        current = [NSString stringWithFormat:@"0%d:00",i];
                        break;
                    case 1:
                        current = [NSString stringWithFormat:@"0%d:15",i];
                        break;
                    case 2:
                        current = [NSString stringWithFormat:@"0%d:30",i];
                        break;
                    case 3:
                        current = [NSString stringWithFormat:@"0%d:45",i];
                        break;
                    default:
                        break;
                }
            }
            else {
                switch (j) {
                    case 0:
                        current = [NSString stringWithFormat:@"%d:00",i];
                        break;
                    case 1:
                        current = [NSString stringWithFormat:@"%d:15",i];
                        break;
                    case 2:
                        current = [NSString stringWithFormat:@"%d:30",i];
                        break;
                    case 3:
                        current = [NSString stringWithFormat:@"%d:45",i];
                        break;
                    default:
                        break;
                }
            }
            [times addObject:current];
        }
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
