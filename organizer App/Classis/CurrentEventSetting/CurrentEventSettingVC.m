//
//  CurrentEventSettingVC.m
//  organizer App
//
//  Created by Romit on 02/07/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "CurrentEventSettingVC.h"
#import "ParticipantsViewController.h"
#import "SponsorsViewController.h"
#import "StagesViewController.h"
#import "UICRouteOverlayMapView.h"
#import "UICRouteAnnotation.h"
#import "MyAnnotation.h"
#import "AMark.h"
#import "AMarkView.h"
#import "ExploreCell.h"
#import "Base64.h"
@interface CurrentEventSettingVC ()
{
    NSInteger tags;
    NSInteger previosTag;
    AMarkView *calloutView;
    int page;
}
@end
@implementation CurrentEventSettingVC
@synthesize mainId;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;

#pragma --viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    mainId=@"1";
    
    isClick = NO;//jam15-07
    selectedListArr = [[NSMutableArray alloc]init];
    detailDict = [[NSMutableDictionary alloc]init];
    detailArr = [[NSMutableArray alloc]init];
    
    totalStages = [[NSMutableArray alloc]init];
    NSMutableArray * tempdetailArr=[[NSMutableArray alloc]init];//jam15-07
    
    NSDateFormatter * frmtr =[[NSDateFormatter alloc] init];
    [frmtr setDateFormat:@"yyyy-MM-dd"];
    NSString * todaDate =[frmtr stringFromDate:[NSDate date]];
    
    
    NSMutableArray * totalArr =[[NSMutableArray alloc] init];
    NSString * strMessage = [NSString stringWithFormat:@"select event_id from Main_table where event_date='%@'",todaDate];
    [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:totalArr];

    
    mainId=[[totalArr lastObject] objectForKey:@"event_id"];

    
    NSString * strQueary = [NSString stringWithFormat:@"select * from GeneralInfo_Table where event_id = '%@'",mainId];
    [[DataBaseManager dataBaseManager] execute:strQueary resultsArray:tempdetailArr];

    NSString * strstage = [NSString stringWithFormat:@"select * from Stages_Table where event_id = '%@'",mainId];
    [[DataBaseManager dataBaseManager] execute:strstage resultsArray:totalStages];
    
    for (int i = 0; i<[totalStages count]; i++)
    {
        NSMutableArray * tempSplitsArr = [[NSMutableArray alloc]init];
        NSString * splitsStr = [NSString stringWithFormat:@"select * from Splits_Table where event_stage_id = '%@'",[[totalStages objectAtIndex:i]valueForKey:@"id"]];
        
        [[DataBaseManager dataBaseManager] execute:splitsStr resultsArray:tempSplitsArr];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        dict = [[totalStages objectAtIndex:i] mutableCopy];
        [dict setObject:[NSString stringWithFormat:@"%d",[tempSplitsArr count]] forKey:@"split_count"];
        [dict setObject:tempSplitsArr forKey:@"split"];
        
        [totalStages replaceObjectAtIndex:i withObject:dict];
        
        
    }
    
    eventDetailDict = [[NSMutableDictionary alloc]init];
    if (tempdetailArr.count == 0)
    {
        
    }
    else
    {
        eventDetailDict = [tempdetailArr objectAtIndex:0];
        NSString * str1 =[NSString stringWithFormat:@"select * from EventSponsors_Table where event_id = '%@'",mainId];
        
        NSString * str2 =[NSString stringWithFormat:@"select * from EventParticipants_Table where event_id = '%@'",mainId];
        
        
        NSMutableArray * totalspns =[[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:str1 resultsArray:totalspns];
        
        totalParticipants =[[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:str2 resultsArray:totalParticipants];
        
        totalImgs =[[NSMutableArray alloc] init];
        
        NSString * str3 =[NSString stringWithFormat:@"select * from Images_Table where event_id = '%@'",mainId];
        [[DataBaseManager dataBaseManager] execute:str3 resultsArray:totalImgs];
        
        totalImagesCount=0;
        if ([[[totalImgs objectAtIndex:0] objectForKey:@"event_photo1"] isEqualToString:@"(null)"]||[[totalImgs objectAtIndex:0] objectForKey:@"event_photo1"]!=[NSNull null])
        {
            
        }
        else
        {
            totalImagesCount++;
        }
        
        if ([[[totalImgs objectAtIndex:0] objectForKey:@"event_photo2"] isEqualToString:@"(null)"]||[[totalImgs objectAtIndex:0] objectForKey:@"event_photo2"]!=[NSNull null])
        {
            
        }
        else
        {
            totalImagesCount++;
            
        }
        if ([[[totalImgs objectAtIndex:0] objectForKey:@"event_photo2"] isEqualToString:@"(null)"]||[[totalImgs objectAtIndex:0] objectForKey:@"event_photo2"]!=[NSNull null])
        {
        }
        else
        {
            totalImagesCount++;
        }
        
        
        
        [eventDetailDict setObject:[NSString stringWithFormat:@"%d",[totalspns count]] forKey:@"totalSponsors"];
        
        [eventDetailDict setObject:[NSString stringWithFormat:@"%d",[totalParticipants count]] forKey:@"totalCompetitor"];
        
    }
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text =@"Bike Race Event";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];

    
    backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 12, 22);;
    backimg.image = [UIImage imageNamed:@"back.png"];
    backimg.hidden = YES;
    [navView addSubview:backimg];
    
    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 100, 30);
    backBtn.backgroundColor = [UIColor clearColor];
    // [backBtn setTitle:@"< Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    backBtn.hidden = YES;
    [navView addSubview:backBtn];
    
    
    editBtn = [[UIButton alloc]init];
    editBtn.frame = CGRectMake(navView.frame.size.width-100, 30, 100, 30);
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:editBtn];
    
    
    addParticipantBtn = [[UIButton alloc]init];
    addParticipantBtn.frame = CGRectMake(navView.frame.size.width-60, 30, 32, 32);
    addParticipantBtn.backgroundColor = [UIColor clearColor];
    [addParticipantBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addParticipantBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addParticipantBtn.hidden = YES;
    [navView addSubview:addParticipantBtn];
    
    settingImg = [[UIImageView alloc]init];
    settingImg.frame = CGRectMake(navView.frame.size.width-150, 30, 33, 33);
    settingImg.image = [UIImage imageNamed:@"settng"];
    settingImg.backgroundColor = [UIColor clearColor];
    [navView addSubview:settingImg];
    
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(navView.frame.size.width-150, 20, 50, 50);
    settingBtn.backgroundColor = [UIColor clearColor];
    [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:settingBtn];
    
    
    
    tapbarView = [[UIView alloc]init];
    tapbarView.frame = CGRectMake(20, 82, 704-40, 60);
    tapbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapbarView];
    
    currentEventLbl = [[UILabel alloc]init];
    currentEventLbl.frame = CGRectMake(0, 10, tapbarView.frame.size.width/3, 30);
    currentEventLbl.text = @"Live Event";//jam14-07-2015
    currentEventLbl.textColor = [UIColor yellowColor];
    currentEventLbl.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    currentEventLbl.backgroundColor = [UIColor clearColor];
    currentEventLbl.textAlignment = NSTextAlignmentCenter;
    [tapbarView addSubview:currentEventLbl];
    
    currentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    currentBtn.frame=CGRectMake(0, 0, tapbarView.frame.size.width/3, 50);
    [currentBtn addTarget:self action:@selector(currentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tapbarView addSubview:currentBtn];
    
    
    compititorLbl = [[UILabel alloc]init];
    compititorLbl.frame = CGRectMake(tapbarView.frame.size.width/3, 10, tapbarView.frame.size.width/3, 30);
    compititorLbl.text = @"Participants";
    compititorLbl.textColor = [UIColor whiteColor];
    compititorLbl.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    compititorLbl.backgroundColor = [UIColor clearColor];
    compititorLbl.textAlignment = NSTextAlignmentCenter;
    [tapbarView addSubview:compititorLbl];
    
    compititorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    compititorBtn.frame=CGRectMake(tapbarView.frame.size.width/3, 0, tapbarView.frame.size.width/3, 50);
    [compititorBtn addTarget:self action:@selector(stagesSplitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tapbarView addSubview:compititorBtn];
    
    
    
    
    routMapLbl = [[UILabel alloc]init];
    routMapLbl.frame = CGRectMake(tapbarView.frame.size.width*2/3, 10, tapbarView.frame.size.width/3, 30);
    routMapLbl.text = @"Route Map";
    routMapLbl.textColor = [UIColor whiteColor];
    routMapLbl.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    routMapLbl.backgroundColor = [UIColor clearColor];
    routMapLbl.textAlignment = NSTextAlignmentCenter;
    [tapbarView addSubview:routMapLbl];
    
    mapBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame=CGRectMake(tapbarView.frame.size.width*2/3, 0, tapbarView.frame.size.width/3, 50);
    [mapBtn addTarget:self action:@selector(mapBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tapbarView addSubview:mapBtn];
    
    
    
    selectedViewLbl = [[UILabel alloc]init];
    selectedViewLbl.frame = CGRectMake(0, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
    selectedViewLbl.backgroundColor = [UIColor yellowColor];
    [tapbarView addSubview:selectedViewLbl];
    
    
    if (IS_IPAD)
    {
        scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, 704, (768-140))];
        [scrlContent setContentSize:CGSizeMake(scrlContent.frame.size.width*3, 768-140)];
        
    }
    else
    {
        
    }
    [scrlContent setBackgroundColor:[UIColor clearColor]];
    scrlContent.pagingEnabled = YES;
    scrlContent.bounces = NO;
    scrlContent.delegate = self;
    scrlContent.userInteractionEnabled = YES;
    scrlContent.showsHorizontalScrollIndicator = NO;
    scrlContent.showsVerticalScrollIndicator = NO;
    scrlContent.scrollEnabled=NO;
    
   [self.view addSubview:scrlContent];
   [self.view bringSubviewToFront:scrlContent];
    
    noticeMsgLbl = [[UILabel alloc]init];
    noticeMsgLbl.frame = CGRectMake(30, 200, 704-60, 200);
    noticeMsgLbl.textColor = [UIColor whiteColor];
    noticeMsgLbl.backgroundColor = [UIColor clearColor];
    noticeMsgLbl.textAlignment = NSTextAlignmentCenter;
    noticeMsgLbl.text = @"Loading...";
    noticeMsgLbl.numberOfLines = 0;
    noticeMsgLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    noticeMsgLbl.hidden = NO;
    [self.view addSubview:noticeMsgLbl];
    
    
    int xx = 0;
    for (int i = 0; i<3; i++)
    {
        if (i==0)
        {
            
            
            backView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, scrlContent.frame.size.width-20, scrlContent.frame.size.height-100)];
            backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"smallbox.png"]];
            backView.userInteractionEnabled=YES;
            [scrlContent addSubview:backView];
            
            
            detailViewTbl =[[UITableView alloc] initWithFrame:CGRectMake(15, 10, backView.frame.size.width-30, 768-140-30-100) style:UITableViewStylePlain];
            detailViewTbl.backgroundColor = [UIColor clearColor];
            [detailViewTbl setDelegate:self];
            [detailViewTbl setDataSource:self];
            [detailViewTbl setSeparatorColor:[UIColor clearColor]];
            [detailViewTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            detailViewTbl.showsVerticalScrollIndicator=NO;
            [backView addSubview:detailViewTbl];
            
           
            btnStartRace=[[UIButton alloc]initWithFrame:CGRectMake(0, scrlContent.frame.size.height-100, 704, 100)];
            [btnStartRace setTitle:@"Start Race" forState:UIControlStateNormal];
            btnStartRace.titleLabel.textAlignment=NSTextAlignmentCenter;
            [btnStartRace setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnStartRace.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
            [btnStartRace addTarget:self action:@selector(startRaceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btnStartRace setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
            [scrlContent addSubview:btnStartRace];

            
        }
        else if (i == 1)
        {
            //---------jam bhavsang 14-07-2015------start-----------//
            
            UIView * header = [[UIView alloc]init];
            header.frame = CGRectMake(scrlContent.frame.size.width+10, 0, scrlContent.frame.size.width-20,50);
            header.backgroundColor = [UIColor yellowColor];
            header.alpha = 0.90;
            [scrlContent addSubview:header];
            
            UILabel * numberLbl = [[UILabel alloc]init];
            numberLbl.frame = CGRectMake(10, 10, 80, 30);
            numberLbl.text = @"No";
            numberLbl.textColor = [UIColor blackColor];
            numberLbl.textAlignment = NSTextAlignmentLeft;
            numberLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            numberLbl.backgroundColor = [UIColor clearColor];
            [header addSubview:numberLbl];
            
            
            UILabel * nameLbl1 = [[UILabel alloc]init];
            nameLbl1.frame = CGRectMake(110, 10, 100, 30);
            nameLbl1.text = @"Name";
            nameLbl1.textColor = [UIColor blackColor];
            nameLbl1.textAlignment = NSTextAlignmentLeft;
            nameLbl1.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            nameLbl1.backgroundColor = [UIColor clearColor];
            [header addSubview:nameLbl1];
            
            UILabel * countryLbl = [[UILabel alloc]init];
            countryLbl.frame = CGRectMake(430, 10, 100, 30);
            countryLbl.text = @"Country";
            countryLbl.textColor = [UIColor blackColor];
            countryLbl.textAlignment = NSTextAlignmentLeft;
            countryLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            countryLbl.backgroundColor = [UIColor clearColor];
            [header addSubview:countryLbl];
            
            UILabel * penaltyLbl = [[UILabel alloc]init];
            penaltyLbl.frame = CGRectMake(548, 10, 150, 30);
            penaltyLbl.text = @"Penalty Time";
            penaltyLbl.textColor = [UIColor blackColor];
            penaltyLbl.textAlignment = NSTextAlignmentLeft;
            penaltyLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            penaltyLbl.backgroundColor = [UIColor clearColor];
            [header addSubview:penaltyLbl];
            
            stageDetailTbl = [[UITableView alloc]init];
            stageDetailTbl.frame = CGRectMake(scrlContent.frame.size.width+10, 60, scrlContent.frame.size.width-20, scrlContent.frame.size.height-50-60);
            stageDetailTbl.backgroundColor = [UIColor clearColor];
            [stageDetailTbl setDelegate:self];
            [stageDetailTbl setDataSource:self];
            [stageDetailTbl setSeparatorColor:[UIColor clearColor]];
            [stageDetailTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            stageDetailTbl.backgroundColor = [UIColor clearColor];
            stageDetailTbl.userInteractionEnabled = YES;
            [scrlContent addSubview:stageDetailTbl];
            
            
            
            btnNext=[[UIButton alloc]initWithFrame:CGRectMake(0, scrlContent.frame.size.height-60, 704, 60)];
            [btnNext setTitle:@"Next" forState:UIControlStateNormal];
            btnNext.titleLabel.textAlignment=NSTextAlignmentCenter;
            [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnNext.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
            btnNext.hidden = YES;
            [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnNext setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
            [self.view addSubview:btnNext];
            
            
            //---------jam bhavsang 14-07-2015------end-----------//
            
        }
        else if (i == 2)
        {
          /*  _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(scrlContent.frame.size.width*2, 0, 710, 768)];
            _mapView.delegate=self;
            _mapView.mapType=MKMapTypeSatellite;
            [scrlContent addSubview:_mapView];
            
            
            
            // create the overlay
            [self loadRoute];
            
            // add the overlay to the map
            if (nil != self.routeLine) {
                [self.mapView addOverlay:self.routeLine];
            }
            
            // zoom in on the route.
            [self zoomInOnRoute];*/
            
            
        }
        xx = xx+scrlContent.frame.size.width;
        scrlContent.contentSize = CGSizeMake(704 * 3, scrlContent.frame.size.height);
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [detailViewTbl reloadData];
    });
    

    
    if([tempdetailArr count]==0)
    {
        noticeMsgLbl.hidden = NO;
        noticeMsgLbl.text=@"No Current Event";
        detailViewTbl.hidden=YES;
        scrlContent.hidden=YES;
    }else
    {
        noticeMsgLbl.hidden = YES;
        detailViewTbl.hidden=NO;
        scrlContent.hidden=NO;
        
    }

    
    totalParticipants=[[NSMutableArray alloc] init];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
    [dict setValue:@"Frank" forKey:@"name"];
    [dict setValue:@"ARGENTINA" forKey:@"country"];
    [dict setValue:@"13" forKey:@"compititorNumber"];
    [dict setValue:@"yes" forKey:@"verified"];
    [dict setValue:@"5" forKey:@"penalty_time"];//jam15-07
    
    NSMutableDictionary * dict1 =[[NSMutableDictionary alloc] init];
    [dict1 setValue:@"Aaron" forKey:@"name"];
    [dict1 setValue:@"ARGENTINA" forKey:@"country"];
    [dict1 setValue:@"14" forKey:@"compititorNumber"];
    [dict1 setValue:@"yes" forKey:@"verified"];
    [dict1 setValue:@"5" forKey:@"penalty_time"];//jam15-07
    
    NSMutableDictionary * dict2 =[[NSMutableDictionary alloc] init];
    [dict2 setValue:@"Albom" forKey:@"name"];
    [dict2 setValue:@"ARGENTINA" forKey:@"country"];
    [dict2 setValue:@"20" forKey:@"compititorNumber"];
    [dict2 setValue:@"yes" forKey:@"verified"];
     [dict2 setValue:@"5" forKey:@"penalty_time"];//jam15-07

    NSMutableDictionary * dict3 =[[NSMutableDictionary alloc] init];
    [dict3 setValue:@"Tariq" forKey:@"name"];
    [dict3 setValue:@"ARGENTINA" forKey:@"country"];
    [dict3 setValue:@"22" forKey:@"compititorNumber"];
    [dict3 setValue:@"yes" forKey:@"verified"];
    [dict3 setValue:@"5" forKey:@"penalty_time"];//jam15-07
    
    NSMutableDictionary * dict4 =[[NSMutableDictionary alloc] init];
    [dict4 setValue:@"Marsh" forKey:@"name"];
    [dict4 setValue:@"USA" forKey:@"country"];
    [dict4 setValue:@"24" forKey:@"compititorNumber"];
    [dict4 setValue:@"yes" forKey:@"verified"];
    [dict4 setValue:@"5" forKey:@"penalty_time"];//jam15-07

    [totalParticipants addObject:dict];
    [totalParticipants addObject:dict1];
    [totalParticipants addObject:dict2];
    [totalParticipants addObject:dict3];
    [totalParticipants addObject:dict4];
    
//--------------------jam15-07-2015 for Disclimer Start-----------------//
    
    disclimerView = [[UIView alloc]init];
    disclimerView.frame = CGRectMake(0, 768, 704, 768);
    disclimerView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    disclimerView.hidden = YES;
    [self.view addSubview:disclimerView];
    
    
    UIView * titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    titleView.backgroundColor = [UIColor blackColor];
    titleView.userInteractionEnabled=YES;
    [disclimerView addSubview:titleView];
    
    
    UILabel * title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 0, 704, 80);
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Disclaimer";
    title.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [titleView addSubview:title];
    
    
    closeBtn = [[UIButton alloc]init];
    closeBtn.frame = CGRectMake(10, 30, 100, 30);
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [titleView addSubview:closeBtn];
    

    UIView * tempview=[[UIView alloc]init];
    tempview.frame = CGRectMake(30, 150, 704-60, 550);
    tempview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [disclimerView addSubview:tempview];
    
    
    txtdiscDetail = [[UITextView alloc]init];
    txtdiscDetail.frame = CGRectMake(10, 10, tempview.frame.size.width-20, 150);
   
    txtdiscDetail.text = @"I declare that I am eligible under the Technical Regulations highlighted by the event organiser to participate in this event and that the information I have submitted is correct.";
    txtdiscDetail.delegate = self;
    txtdiscDetail.userInteractionEnabled = NO;
    txtdiscDetail.textColor = [UIColor whiteColor];
    txtdiscDetail.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    txtdiscDetail.textAlignment = NSTextAlignmentLeft;
    txtdiscDetail.backgroundColor = [UIColor clearColor];
    [tempview addSubview:txtdiscDetail];
    
    UITextView *  txtdiscDetail2 = [[UITextView alloc]init];
    txtdiscDetail2.frame = CGRectMake(10, 160, tempview.frame.size.width-20, 300);
    
    txtdiscDetail2.text = @"I understand and agree that I participate in this event entirely at my own risk, that I must rely on my own ability in dealing with all hazards and that I must ride in a manner which is safe for myself and others. I agree no liability whatsoever shall be attached to Event organiser or any member of the event organisers Team in respect of injury, loss or damage suffered by me or by reason of the event, however caused";
    txtdiscDetail2.delegate = self;
    txtdiscDetail2.userInteractionEnabled = NO;
    txtdiscDetail2.textColor = [UIColor whiteColor];
    txtdiscDetail2.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    txtdiscDetail2.textAlignment = NSTextAlignmentLeft;
    txtdiscDetail2.backgroundColor = [UIColor clearColor];
    [tempview addSubview:txtdiscDetail2];
    
    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(90, tempview.frame.size.height-60, 200, 50);
   
    agreeBtn.backgroundColor = [UIColor clearColor];
    [agreeBtn setTitle:@"Agree" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tempview addSubview:agreeBtn];
    
    disagree = [UIButton buttonWithType:UIButtonTypeCustom];
    disagree.frame = CGRectMake(350, tempview.frame.size.height-60, 200, 50);
    disagree.backgroundColor = [UIColor clearColor];
    [disagree setTitle:@"Disagree" forState:UIControlStateNormal];
    [disagree addTarget:self action:@selector(disagreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [disagree setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    disagree.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [disagree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tempview addSubview:disagree];
    
    //-----------------jam15-07-2015-------End----------------------------------//


    ////////////--------------------------------------------------------///////////
    
    addparticipants = [[UIView alloc]init];
    addparticipants.frame = CGRectMake(0, 768, 704, 768);
    addparticipants.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    addparticipants.hidden = YES;
    [self.view addSubview:addparticipants];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [addparticipants addSubview:navView];
    
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Add Participants";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(10, 30, 100, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:cancelBtn];
    
    
    
    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(navView.frame.size.width-100, 30, 100, 30);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:saveBtn];
    
    
    [PTsearchBar removeFromSuperview];
    PTsearchBar = [[UISearchBar alloc] init];
    [PTsearchBar setFrame:CGRectMake(20, 125, 600, 44)];
    PTsearchBar.delegate = self;
    PTsearchBar.showsCancelButton = NO;
    PTsearchBar.placeholder = @"Search here";
    PTsearchBar.tintColor = [UIColor whiteColor];
    
    [addparticipants addSubview:PTsearchBar];
    
    
    UIImageView * addnewImg = [[UIImageView alloc]init];
    addnewImg.frame =CGRectMake(635, 125, 40, 40);
    addnewImg.backgroundColor = [UIColor clearColor];
    addnewImg.image = [UIImage imageNamed:@"add_user"];
    [addparticipants addSubview:addnewImg];
    
    
    UIButton * addNew = [[UIButton alloc]init];
    addNew.frame = CGRectMake(625, 125, 90, 50);
    addNew.backgroundColor = [UIColor clearColor];
    [addNew addTarget:self action:@selector(addNewClick) forControlEvents:UIControlEventTouchUpInside];
    [addparticipants addSubview:addNew];
    
    participantListTbl = [[UITableView alloc]init];
    participantListTbl.frame = CGRectMake(20, 180, 704-40, 768-180);
    participantListTbl.backgroundColor = [UIColor clearColor];
    [participantListTbl setDelegate:self];
    [participantListTbl setDataSource:self];
    [participantListTbl setSeparatorColor:[UIColor clearColor]];
    [participantListTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [addparticipants addSubview:participantListTbl];
    
    
    //----------------------------addnewparticipants--------------------------//
    
    addNewComititor = [[UIView alloc]init];
    addNewComititor.frame = CGRectMake(0, 768, 704, 768);
    addNewComititor.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    addNewComititor.hidden = YES;
    [self.view addSubview:addNewComititor];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [addNewComititor addSubview:navView];
    
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Add New Participant";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(10, 30, 100, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelNewViewClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:cancelBtn];
    
    participantsDict = [[NSMutableDictionary alloc]init];
    [participantsDict setValue:@"required" forKey:@"email"];
    [participantsDict setValue:@"required" forKey:@"name"];
    [participantsDict setValue:@"required" forKey:@"country"];
    [participantsDict setValue:@"required" forKey:@"compititorNumber"];
    
    UIView * tempView1=[[UIView alloc]init];
    tempView1.frame = CGRectMake(30, 100, 704-60, 400);
    tempView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [addNewComititor addSubview:tempView1];
    
    int yy;
    yy = 20;
    
    UIView * emailview=[[UIView alloc]init];
    emailview.frame =CGRectMake(20 ,yy,tempView1.frame.size.width-40, 50);
    emailview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempView1 addSubview:emailview];
    
    
    txtemail=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,emailview.frame.size.width-20, 50)];
    txtemail.textColor=[UIColor whiteColor];
    txtemail.keyboardType=UIKeyboardTypeEmailAddress;
    txtemail.textAlignment = NSTextAlignmentLeft;
    txtemail.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtemail setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtemail.delegate = self;
    txtemail.placeholder = @"Enter Email Id";
    txtemail.returnKeyType=UIReturnKeyNext;
    txtemail.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtemail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [emailview addSubview:txtemail];
    
    emailLbl = [[UILabel alloc]init];
    emailLbl.frame = CGRectMake(emailview.frame.size.width/2+10, 10, emailview.frame.size.width/2-20, 30);
    emailLbl.backgroundColor = [UIColor clearColor];
    emailLbl.textColor = [UIColor yellowColor];
    emailLbl.textAlignment = NSTextAlignmentRight;
    emailLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [emailview addSubview:emailLbl];
    
    if ([[participantsDict valueForKey:@"email"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        emailLbl.text = [participantsDict valueForKey:@"email"];
    }
    
    yy = yy +70;
    
    UIView * nameView=[[UIView alloc]init];
    nameView.frame =CGRectMake(20 ,yy,tempView1.frame.size.width-40, 50);
    nameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempView1 addSubview:nameView];
    
    
    txtName=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,emailview.frame.size.width-20, 50)];
    txtName.textColor=[UIColor whiteColor];
    txtName.keyboardType=UIKeyboardTypeEmailAddress;
    txtName.textAlignment = NSTextAlignmentLeft;
    txtName.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtName.delegate = self;
    txtName.placeholder = @"Enter Name";
    txtName.returnKeyType=UIReturnKeyNext;
    txtName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [nameView addSubview:txtName];
    
    nameLbl = [[UILabel alloc]init];
    nameLbl.frame = CGRectMake(nameView.frame.size.width/2+10, 10, nameView.frame.size.width/2-20, 30);
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor yellowColor];
    nameLbl.textAlignment = NSTextAlignmentRight;
    nameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [nameView addSubview:nameLbl];
    
    if ([[participantsDict valueForKey:@"name"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        nameLbl.text = [participantsDict valueForKey:@"name"];
    }
    
    
    yy = yy +70;
    
    UIView * nationalityView=[[UIView alloc]init];
    nationalityView.frame =CGRectMake(20 ,yy,tempView1.frame.size.width-40, 50);
    nationalityView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempView1 addSubview:nationalityView];
    
    
    txtNationality=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,nationalityView.frame.size.width-20, 50)];
    txtNationality.textColor=[UIColor whiteColor];
    txtNationality.keyboardType=UIKeyboardTypeEmailAddress;
    txtNationality.textAlignment = NSTextAlignmentLeft;
    txtNationality.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtNationality setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtNationality.delegate = self;
    txtNationality.placeholder = @"Country";
    txtNationality.returnKeyType=UIReturnKeyNext;
    txtNationality.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtNationality setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [nationalityView addSubview:txtNationality];
    
    nationalityLbl = [[UILabel alloc]init];
    nationalityLbl.frame = CGRectMake(nationalityView.frame.size.width/2+10, 10, nationalityView.frame.size.width/2-20, 30);
    nationalityLbl.backgroundColor = [UIColor clearColor];
    nationalityLbl.textColor = [UIColor yellowColor];
    nationalityLbl.textAlignment = NSTextAlignmentRight;
    nationalityLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [nationalityView addSubview:nationalityLbl];
    
    if ([[participantsDict valueForKey:@"country"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        nationalityLbl.text = [participantsDict valueForKey:@"country"];
    }
    
    yy = yy +70;
    
    numberView=[[UIView alloc]init];
    numberView.frame =CGRectMake(20 ,yy,tempView1.frame.size.width-40, 50);
    numberView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempView1 addSubview:numberView];
    
    
    txtNumberId=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,numberView.frame.size.width-20, 50)];
    txtNumberId.textColor=[UIColor whiteColor];
    txtNumberId.keyboardType=UIKeyboardTypeNumberPad;
    txtNumberId.textAlignment = NSTextAlignmentLeft;
    txtNumberId.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtNumberId setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtNumberId.delegate = self;
    txtNumberId.placeholder = @"Enter Competitor Number";
    txtNumberId.returnKeyType=UIReturnKeyNext;
    txtNumberId.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtNumberId setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [numberView addSubview:txtNumberId];
    
    numberIdLbl = [[UILabel alloc]init];
    numberIdLbl.frame = CGRectMake(numberView.frame.size.width/2+10, 10, numberView.frame.size.width/2-20, 30);
    numberIdLbl.backgroundColor = [UIColor clearColor];
    numberIdLbl.textColor = [UIColor yellowColor];
    numberIdLbl.textAlignment = NSTextAlignmentRight;
    numberIdLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [numberView addSubview:numberIdLbl];
    
    if ([[participantsDict valueForKey:@"compititorNumber"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        numberIdLbl.text = [participantsDict valueForKey:@"compititorNumber"];
    }
    
    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(0, tempView1.frame.size.height-50, tempView1.frame.size.width, 50);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tempView1 addSubview:saveBtn];
    
    fieldArray=[[NSArray alloc]init];
    fieldArray = [NSArray arrayWithObjects: txtemail, txtName,txtNationality,txtNumberId, nil];
    
    if (selectedListArr.count == 0)
    {
        noticeMsgLbl.hidden = NO;
    }
    else
    {
        noticeMsgLbl.hidden = YES;
        
    }
    
    detailArr = [[NSMutableArray alloc]init];
    
    NSMutableArray * tempCmptArr =[[NSMutableArray alloc] init];
    
    NSString * str = [NSString stringWithFormat:@"select * from Participants_Table"];
    [[DataBaseManager dataBaseManager] execute:str resultsArray:tempCmptArr];
    
    
    if ([tempCmptArr count ]==0)
    {
        detailArr=[[NSMutableArray alloc] init];
    }
    else
    {
        detailArr=[tempCmptArr mutableCopy];
    }
    
    for (int i = 0; i <[detailArr count]; i++)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        dict =[[detailArr objectAtIndex:i] mutableCopy];
        
        [dict setValue:@"NA" forKey:@"compititorNumber"];
        [dict setValue:@"NO" forKey:@"Check"];
        
        [detailArr replaceObjectAtIndex:i withObject:dict];
        
    }
    
    isClick  = NO;
    isClickNew  = NO;
    
        for (int i = 0; i <[detailArr count]; i++)
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            dict =[[detailArr objectAtIndex:i] mutableCopy];
            
            [dict setValue:@"NO" forKey:@"Check"];
            [detailArr replaceObjectAtIndex:i withObject:dict];
            
        }
    
    [stageDetailTbl reloadData];

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [self purgeMapMemory];
    
}
- (void)purgeMapMemory
{
    // Switching map types causes cache purging, so switch to a different map type
    _mapView.mapType = MKMapTypeStandard;
    [_mapView removeFromSuperview];
    _mapView = nil;
}

#pragma mark Button Click Event
-(void)backBtnClick:(id)sender
{
    if (page == 0)
    {
        isEventEditView = NO;
        
            backBtn.hidden = YES;
            backimg.hidden = YES;
        
            addParticipantBtn.hidden = YES;
        
    }
    else if (page == 1)
    {
        backBtn.hidden = YES;
        backimg.hidden = YES;
        btnNext.hidden = YES;//jam15-07-2015
        btnStartRace.hidden = NO;//jam15-07
        
        settingImg.hidden = NO;
        settingBtn.hidden = NO;
        editBtn.hidden = NO;
        addParticipantBtn.hidden = YES;
       
        [scrlContent setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (page == 2)
    {
        
        btnNext.hidden = NO;//jam15-07-2015
        
        btnStartRace.hidden = YES;//jam15-07-2015
        settingImg.hidden = YES;
        settingBtn.hidden = YES;
        editBtn.hidden = YES;
        addParticipantBtn.hidden = NO;
        [btnNext setTitle:@"Next" forState:UIControlStateNormal];
        [scrlContent setContentOffset:CGPointMake(704, 0) animated:YES];
        
    }
    
}

-(void)startRaceBtn:(id)sender//jam15-07-2015
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to start this event?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 12;
    [alert show];
    
}
-(void)btnNextClick:(id)sender
{
    if (page == 0)
    {
        btnStartRace.hidden = NO;//jam15-07
        btnNext.hidden = YES;//jam15-07
       
        addParticipantBtn.hidden = NO;
        settingBtn.hidden = YES;
        settingImg.hidden = YES;
        editBtn.hidden = YES;
        [scrlContent setContentOffset:CGPointMake(704, 0) animated:YES];
    }
    else if (page == 1)
    {
        [scrlContent setContentOffset:CGPointMake(704*2, 0) animated:YES];
        
        addParticipantBtn.hidden = YES;
        settingBtn.hidden = NO;
        settingImg.hidden = NO;
        editBtn.hidden = NO;
    }
    else if (page == 2)
    {
        addParticipantBtn.hidden = YES;
    }
    
}

-(void)addBtnClick:(id)sender
{
    
    if (isClick==NO)
    {
        isClick=YES;
        addparticipants.hidden = NO;
        
        [UIView transitionWithView:addparticipants
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addparticipants setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            else
                            {
                                [addparticipants setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            
                            
                        }
                        completion:nil];
        
        
        ;
    }
    else
    {
        isClick=NO;
        
        
        [UIView transitionWithView:addparticipants
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addparticipants setFrame:CGRectMake(0,768, 704, 768)];
                            }
                            else
                            {
                                [addparticipants setFrame:CGRectMake(0,768, 704, 768)];
                            }
                        }
                        completion:nil];
        
        ;
        
    }
    
    
}
-(void)cancelNewViewClick
{
    [txtemail resignFirstResponder];
    [txtName resignFirstResponder];
    [txtNationality resignFirstResponder];
    [txtNumberId resignFirstResponder];
    isedit=NO;
    
    emailLbl.text = @"";
    nameLbl.text = @"";
    nationalityLbl.text = @"";
    numberIdLbl.text = @"";
    
    
    isClickNew=NO;
    
    
    [UIView transitionWithView:addNewComititor
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [addNewComititor setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [addNewComititor setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;
    
    
}
-(void)cancelBtnClick
{
    [txtemail resignFirstResponder];
    [txtName resignFirstResponder];
    [txtNationality resignFirstResponder];
    [txtNumberId resignFirstResponder];
    
    
    [PTsearchBar resignFirstResponder];
    isClick=NO;
    
    
    [UIView transitionWithView:addparticipants
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [addparticipants setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [addparticipants setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;
    
    
}
-(void)settingBtnClick:(id)sender
{
    
}
-(void)competitorBtnClick:(id)sender
{
    
}
-(void)editBtnClick:(id)sender
{
    
    /*CreateEventViewController * view =[[CreateEventViewController alloc]init];
    view.isFromEdit = YES;
    view.editDict = eventDetailDict;
    //    view.mainId = [[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"];
    //    view.eventName =[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_name"];
    view.mainId = [eventDetailDict valueForKey:@"event_id"];
    view.eventName =[eventDetailDict  valueForKey:@"event_name"];
    
    [self.navigationController pushViewController:view animated:YES];*/
    
}

-(void)disclaimerBtnClick:(id)sender//jam15-07
{
    
    if (isClick==NO)
    {
        if (isedit)
        {
            
                  disclimerView.hidden = NO;
            
            [UIView transitionWithView:disclimerView
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                //                            [myview removeFromSuperview];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [disclimerView setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                else
                                {
                                    [disclimerView setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            
            
            ;
            
        }
        else
        {
            
            
            isClick=YES;
            disclimerView.hidden = NO;
            [UIView transitionWithView:disclimerView
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                //                            [myview removeFromSuperview];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [disclimerView setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                else
                                {
                                    [disclimerView setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            ;
            
        }
        
        ;
    }
    
}

-(void)closeBtnClick//jam15-07
{
    isClick=NO;
    
    
    [UIView transitionWithView:disclimerView
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [disclimerView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [disclimerView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;

}
-(void)disagreeBtnClick//jam15-07
{
    [self cancelBtnClick];
}
-(void)agreeBtnClick//jam15-07
{
    [self cancelBtnClick];
}

-(void)saveBtnClick:(id)sender
{
    
    if (isedit)
    {
        
        //electedListArr
    }
    
    else
    {
        [txtemail resignFirstResponder];
        [txtName resignFirstResponder];
        [txtNationality resignFirstResponder];
        [txtNumberId resignFirstResponder];
        
        
        isFromAdd  = YES;
        
        [self cancelBtnClick];
        
        [stageDetailTbl reloadData];
        int i = selectedListArr.count;
        
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"totalNumber"];
        [[NSUserDefaults standardUserDefaults] setValue:selectedListArr forKey:@"selected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
    }
    
    
    
    
}
-(void)saveUser
{
    
    
    if (isedit)
    {
        [txtemail resignFirstResponder];
        [txtName resignFirstResponder];
        [txtNationality resignFirstResponder];
        [txtNumberId resignFirstResponder];
        isedit=NO;
        
        if ([emailLbl.text isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 12;
            [alert show];
            
        }
        else if ([self validateEmail:emailLbl.text]==NO)
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            altfname.tag = 12;
            [altfname show];
            
        }
        else if ([nameLbl.text isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 12;
            [alert show];
        }
        else if ([nationalityLbl.text isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Country" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 12;
            [alert show];
        }
        else if ([numberIdLbl.text isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 12;
            [alert show];
        }
        else
        {
            [[totalParticipants objectAtIndex:selectedRow] setObject:emailLbl.text forKey:@"emailId"];
            
            [[totalParticipants objectAtIndex:selectedRow] setObject:nameLbl.text forKey:@"name"];
            [[totalParticipants objectAtIndex:selectedRow] setObject:nationalityLbl.text forKey:@"country"];
            
            [[totalParticipants objectAtIndex:selectedRow] setObject:numberIdLbl.text forKey:@"compititorNumber"];
            isedit=NO;
            [self cancelNewViewClick];
            [stageDetailTbl reloadData];
        }
        
            
        
        
            
        
    }
    else
    {
        [txtemail resignFirstResponder];
        [txtName resignFirstResponder];
        [txtNationality resignFirstResponder];
        [txtNumberId resignFirstResponder];
        
        
        if ([[participantsDict valueForKey:@"email"] isEqualToString:@""]||[[participantsDict valueForKey:@"email"] isEqualToString:@"required"])
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            altfname.tag = 12;
            [altfname show];
            
        }
        else if ([self validateEmail:[participantsDict valueForKey:@"email"]]==NO)
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            altfname.tag = 12;
            [altfname show];
            
            
        }
        else if ([[participantsDict valueForKey:@"name"] isEqualToString:@""]||[[participantsDict valueForKey:@"name"] isEqualToString:@"required"])
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            altfname.tag = 12;
            [altfname show];
        }
        else if ([[participantsDict valueForKey:@"country"] isEqualToString:@""]||[[participantsDict valueForKey:@"country"] isEqualToString:@"required"])
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Nationality" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            altfname.tag = 12;
            [altfname show];
            
        }
        
        else
        {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[participantsDict valueForKey:@"email"] forKey:@"email"];
            [dict setValue:[participantsDict valueForKey:@"name"] forKey:@"name"];
            [dict setValue:[participantsDict valueForKey:@"country"] forKey:@"country"];
            [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] forKey:@"login_user_id"];
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"addCompititors";
            manager.delegate = self;
            [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/addCompetitors" withParameters:dict];
            
        }
        
        
    }
    
    
}
-(void)addNewClick
{

    if (isClickNew==NO)
    {
        
        if (isedit)
        {
            
            isClickNew=YES;
            emailLbl.text=[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"emailId"];
            
            
            
            participantsDict = [[NSMutableDictionary alloc]init];
            [participantsDict setValue:[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"emailId"] forKey:@"email"];
            [participantsDict setValue:@"required" forKey:@"name"];
            [participantsDict setValue:[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"country"] forKey:@"country"];
            [participantsDict setValue:@"" forKey:@"compititorNumber"];
            
            
            
            emailLbl.text=[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"emailId"];
            
            nameLbl.text=[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"name"];
            nationalityLbl.text=[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"country"] ;
            
            numberIdLbl.text=[[totalParticipants objectAtIndex:selectedRow]valueForKey:@"compititorNumber"];
            numberIdLbl.hidden=NO;
            
            numberView.hidden=NO;
            
            
            //            numberView.hidden=YES;
            
            
            
            
            addNewComititor.hidden = NO;
            
            [UIView transitionWithView:addNewComititor
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                //                            [myview removeFromSuperview];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [addNewComititor setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                else
                                {
                                    [addNewComititor setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            
            
            ;
            
        }
        else
        {
            numberView.hidden=YES;
            
            txtNumberId.hidden=YES;
            isClickNew=YES;
            addNewComititor.hidden = NO;
            [UIView transitionWithView:addNewComititor
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                //                            [myview removeFromSuperview];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [addNewComititor setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                else
                                {
                                    [addNewComititor setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            
            ;
            
        }
    }
    else
    {
        isClickNew=NO;
        
        numberView.hidden=YES;
        
        [UIView transitionWithView:addNewComititor
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addNewComititor setFrame:CGRectMake(0,768, 704, 768)];
                            }
                            else
                            {
                                [addNewComititor setFrame:CGRectMake(0,768, 704, 768)];
                            }
                        }
                        completion:nil];
        
        ;
        
    }
    
    
}
#pragma mark- Header Button Click Event
-(void)currentBtnClick
{
   
    backBtn.hidden = NO;
    backimg.hidden = NO;
    pageNo=@"1";
    btnStartRace.hidden = NO;//jam15-07
    btnNext.hidden = YES;//jam15-07
    settingBtn.hidden = NO;
    settingImg.hidden = NO;
    editBtn.hidden = NO;
    addParticipantBtn.hidden = YES;
    
    [scrlContent setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)stagesSplitBtnClick
{
    noticeMsgLbl.hidden=YES;
    
    if ([detailArr count]==0)
    {
        
    }
    else
    {
        
    }
    pageNo=@"2";

    backBtn.hidden = NO;
    backimg.hidden = NO;
    btnStartRace.hidden = YES;//jam15-07
    btnNext.hidden = NO;//jam15-07
    settingBtn.hidden = YES;
    settingImg.hidden = YES;
    editBtn.hidden = YES;
    addParticipantBtn.hidden = NO;
    
    [scrlContent setContentOffset:CGPointMake(704, 0) animated:YES];
    
}
-(void)mapBtnClick
{
    pageNo=@"3";
   
    settingBtn.hidden = YES;
    settingImg.hidden = YES;
    editBtn.hidden = YES;
    addParticipantBtn.hidden = YES;

    btnStartRace.hidden = YES;//jam15-07
    btnNext.hidden = NO;//jam15-07
    
    _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(scrlContent.frame.size.width*2, 0, 710, 768)];
    _mapView.delegate=self;
    _mapView.mapType=MKMapTypeSatellite;
    [scrlContent addSubview:_mapView];
    _mapView.showsUserLocation=YES;
    
    [self addStagesButtonToMap];
    // add the overlay to the map
    if (nil != self.routeLine)
    {
        [self.mapView addOverlay:self.routeLine];
    }
    
    // zoom in on the route.
    [self zoomInOnRoute];
    
    
    [scrlContent setContentOffset:CGPointMake(704*2, 0) animated:YES];
    
}

-(void)editClick:(id)sender
{
    
    /*if (isClick==NO)
    {
        if (isedit)
        {
            
            isFromAdd = NO;
            
            isClick=YES;
            
            emailLbl.text=[[detailArr objectAtIndex:selectedRow]valueForKey:@"emailId"];
            
            participantsDict = [[NSMutableDictionary alloc]init];
            [participantsDict setValue:[[detailArr objectAtIndex:selectedRow]valueForKey:@"emailId"] forKey:@"email"];
            [participantsDict setValue:[[detailArr objectAtIndex:selectedRow]valueForKey:@"name"] forKey:@"name"];
            [participantsDict setValue:[[detailArr objectAtIndex:selectedRow]valueForKey:@"country"] forKey:@"country"];
            [participantsDict setValue:@"" forKey:@"compititorNumber"];
            
            
            
            emailLbl.text=[[detailArr objectAtIndex:selectedRow]valueForKey:@"emailId"];
            
            nameLbl.text=[[detailArr objectAtIndex:selectedRow]valueForKey:@"name"];
            nationalityLbl.text=[[detailArr objectAtIndex:selectedRow]valueForKey:@"country"] ;
            
            numberIdLbl.text=[[detailArr objectAtIndex:selectedRow]valueForKey:@"compititorNumber"];
            numberIdLbl.hidden=NO;
            
            
            
            
            
            
            addparticipants.hidden = NO;
            
            [UIView transitionWithView:addparticipants
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                //                            [myview removeFromSuperview];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [addparticipants setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                else
                                {
                                    [addparticipants setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            
            
            ;
            
        }
        else
        {
            isFromAdd = YES;
            isedit = NO;
            
            
            txtNumberId.hidden=YES;
            isClick=YES;
            addparticipants.hidden = NO;
            [UIView transitionWithView:addparticipants
                              duration:0.50
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                //                            [myview removeFromSuperview];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                {
                                    [addparticipants setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                else
                                {
                                    [addparticipants setFrame:CGRectMake(0, 0, 704,768)];
                                }
                                
                                
                            }
                            completion:nil];
            ;
            
        }
        
        ;
    }*/
    
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    if (scrollView == scrlContent)
    {
        if (page == 0)
        {
            
            
            backBtn.hidden = YES;
            backimg.hidden = YES;
            btnStartRace.hidden = NO;//jam15-07
            btnNext.hidden = YES;//jam15-07

            settingBtn.hidden = NO;
            settingImg.hidden = NO;
            editBtn.hidden = NO;
            addParticipantBtn.hidden = YES;
            
            selectedViewLbl.frame = CGRectMake(0, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            currentEventLbl.textColor = [UIColor yellowColor];
            compititorLbl.textColor = [UIColor whiteColor];
            routMapLbl.textColor = [UIColor whiteColor];
            
        }
        else if (page == 1)
        {
            backBtn.hidden = NO;
            backimg.hidden = NO;
            settingBtn.hidden = YES;
            settingImg.hidden = YES;
            editBtn.hidden = YES;
            
            btnNext.hidden = NO;//jam15-07
            btnStartRace.hidden = YES;//jam15-07
            
            addParticipantBtn.hidden = NO;
            selectedViewLbl.frame = CGRectMake(tapbarView.frame.size.width/3, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            currentEventLbl.textColor = [UIColor whiteColor];
            compititorLbl.textColor = [UIColor yellowColor];
            routMapLbl.textColor = [UIColor whiteColor];
             btnNext.frame = CGRectMake (0, 768-50, 704, 50);
            
            
        }
        else if (page == 2)
        {
            backBtn.hidden = NO;
            backimg.hidden = NO;
            settingBtn.hidden = YES;
            settingImg.hidden = YES;
            editBtn.hidden = YES;
            btnStartRace.hidden = YES;//jam15-07
            btnNext.hidden = YES;//jam15-07
            
            addParticipantBtn.hidden = YES;
            currentEventLbl.textColor = [UIColor whiteColor];
            routMapLbl.textColor = [UIColor yellowColor];
            compititorLbl.textColor = [UIColor whiteColor];
            selectedViewLbl.frame = CGRectMake(tapbarView.frame.size.width*2/3, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            
        }
    }
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == detailViewTbl)
    {
        return 1;
    }
    else if (tableView == stageDetailTbl)
    {
        return 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == stageDetailTbl)
    {
        return  0;
    }
    else
    {
        return NO;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailViewTbl)
    {
        if (indexPath.row == 0)
        {
            return 280;
        }
        else if (indexPath.row == 1)
        {
            return 50;
        }
        else if (indexPath.row == 2)
        {
            return 50;
        }
        else if (indexPath.row == 3)
        {
            return 50;
        }
        else if (indexPath.row == 4)
        {
            return 50;
        }
        else if (indexPath.row == 5)
        {
            return 50;
        }
        else if (indexPath.row == 6)
        {
            return 50;
        }
        else if (indexPath.row == 7)
        {
            return 50;
        }
        else
        {
            return 50;
        }
        
    }
    else if (tableView == stageDetailTbl)
    {
        return 50;
    }
    
    return 50;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailViewTbl)
    {
        return 5;
    }
    else if (tableView == stageDetailTbl)
    {
        return [totalParticipants count];
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == stageDetailTbl)
    {
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, stageDetailTbl.frame.size.width, 50)];
        headerView.backgroundColor=[UIColor clearColor];
        
        headerView.backgroundColor = [UIColor clearColor];
        headerView.alpha = 0.6f;
        return headerView;
    }
    else
    {
        return NO;
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==detailViewTbl)
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
        
        if (tableView == detailViewTbl)
        {
            if (indexPath.row==0)
            {
                
                    AsyncImageView * imgProduct;
                    imgProduct = [[AsyncImageView alloc] initWithFrame:CGRectMake(20, 20, detailViewTbl.frame.size.width-40, 240)];
                    [imgProduct setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                    imgProduct.clipsToBounds=YES;
                    imgProduct.image = [UIImage imageNamed:@"raceimg"];
                    imgProduct.userInteractionEnabled=YES;
                    imgProduct.contentMode = UIViewContentModeScaleAspectFill;
                    [cell.contentView addSubview:imgProduct];//jam15-07-2015
                    
                
                return cell;
                
                
            }
            
            else if (indexPath.row == 1)
            {
                
                UIImageView * dateIcon = [[UIImageView alloc]init];
                dateIcon.frame = CGRectMake(20, 10, 30, 30);
                dateIcon.backgroundColor = [UIColor clearColor];
                dateIcon.image = [UIImage imageNamed:@"dateicon.png"];
                [cell.contentView addSubview:dateIcon];
                
                NSArray * tempArr = [[NSArray alloc]init];
                //            tempArr = [[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_end_date"] componentsSeparatedByString:@" "];
                
                tempArr = [[eventDetailDict valueForKey:@"event_end_date"]  componentsSeparatedByString:@" "];
                
                NSString *endDate = [tempArr objectAtIndex:0];
                endTime = [tempArr objectAtIndex:1];
                
                dateLbl = [[UILabel alloc]init];
                dateLbl.backgroundColor = [UIColor clearColor];
                dateLbl.text = @"StartDate: 12-06-2015  &  EndDate: 24-06-2015";
                //            dateLbl.text = [NSString stringWithFormat:@"StartDate: %@ & EndDate: %@",[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_date"],endDate];
                
                
                dateLbl.text = [NSString stringWithFormat:@"StartDate: %@ & EndDate: %@",[eventDetailDict valueForKey:@"event_date"],endDate];
                
                
                dateLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
                dateLbl.textColor = [UIColor whiteColor];
                dateLbl.textAlignment = NSTextAlignmentLeft;
                dateLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
                [cell.contentView addSubview:dateLbl];
                
            }
            else if (indexPath.row == 2)
            {
                UIImageView * timeIcon = [[UIImageView alloc]init];
                timeIcon.frame = CGRectMake(20, 11, 30, 28);
                timeIcon.backgroundColor = [UIColor clearColor];
                timeIcon.image = [UIImage imageNamed:@"time.png"];
                [cell.contentView addSubview:timeIcon];
                
                
                NSArray * tempArr = [[NSArray alloc]init];
                //            tempArr = [[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_start_date"] componentsSeparatedByString:@" "];
                tempArr = [[eventDetailDict valueForKey:@"event_start_date"] componentsSeparatedByString:@" "];
                
                NSString *strStartTime = [tempArr objectAtIndex:1];
                
                
                timeLbl = [[UILabel alloc]init];
                timeLbl.backgroundColor = [UIColor clearColor];
                timeLbl.text = @"StartTime: 03:40:00  &  EndTime: 10:30:00";
                timeLbl.text = [NSString stringWithFormat:@"StartTime: %@ & EndTime: %@",strStartTime,endTime];
                timeLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
                timeLbl.textColor = [UIColor whiteColor];
                timeLbl.textAlignment = NSTextAlignmentLeft;
                timeLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
                
                [cell.contentView addSubview:timeLbl];
                
                
            }
            else if (indexPath.row == 3)
            {
                UIImageView * raceIcon = [[UIImageView alloc]init];
                raceIcon.frame = CGRectMake(20, 17, 30, 16);
                raceIcon.backgroundColor = [UIColor clearColor];
                raceIcon.image = [UIImage imageNamed:@"race-type.png"];
                [cell.contentView addSubview:raceIcon];
                
                racetypeLbl = [[UILabel alloc]init];
                racetypeLbl.backgroundColor = [UIColor clearColor];
                racetypeLbl.text = @"Enduro";
                racetypeLbl.text = [eventDetailDict valueForKey:@"race_name"];
                racetypeLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
                racetypeLbl.textColor = [UIColor whiteColor];
                racetypeLbl.textAlignment = NSTextAlignmentLeft;
                racetypeLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
                
                [cell.contentView addSubview:racetypeLbl];
                
                
            }
            else if (indexPath.row == 4)
            {
                UIImageView * categoryIcon = [[UIImageView alloc]init];
                categoryIcon.frame = CGRectMake(20, 12.05f, 25, 25);
                categoryIcon.backgroundColor = [UIColor clearColor];
                categoryIcon.image = [UIImage imageNamed:@"category.png"];
                [cell.contentView addSubview:categoryIcon];
                
                
                categoryLbl = [[UILabel alloc]init];
                categoryLbl.backgroundColor = [UIColor clearColor];
                categoryLbl.text = @"Bike Race";
                categoryLbl.text = [eventDetailDict valueForKey:@"cat_name"];
                categoryLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
                categoryLbl.textColor = [UIColor whiteColor];
                categoryLbl.textAlignment = NSTextAlignmentLeft;
                categoryLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
                
                [cell.contentView addSubview:categoryLbl];
                
            }
            
            
        }
        cell.contentView.userInteractionEnabled = NO;
        
        return cell;
    }
    else if (tableView == stageDetailTbl)
    {
        NSString *cellIdentifier=nil;
        
        participantListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[participantListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        cell.temp.frame = CGRectMake(110,5,250,40);//jam15-07-2015
        cell.temp.backgroundColor=[UIColor clearColor];
        
        cell.nameLbl.frame = CGRectMake(120,5,200,40);//jam15-07-2015
        cell.nameLbl.textAlignment=NSTextAlignmentLeft;
        cell.nameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:cell.nameLbl];
        
        cell.checkImg.hidden = YES;
        
        cell.headerView.frame = CGRectMake(0, 0, stageDetailTbl.frame.size.width, 60);
        cell.nameLbl.text = [[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        cell.idLbl.textAlignment = NSTextAlignmentLeft;
        cell.idLbl.text = [[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"compititorNumber"];//jam14-07-2015.
        cell.idLbl.hidden=NO;
        
        
        UILabel *lblpanl=[[UILabel alloc]initWithFrame:CGRectMake(550,10,120, 30)];
        lblpanl.text=@"5 Min";
        lblpanl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        lblpanl.textColor=[UIColor whiteColor];
        lblpanl.textAlignment=NSTextAlignmentCenter;
        lblpanl.backgroundColor=[UIColor clearColor];
        lblpanl.layer.borderColor = [UIColor yellowColor].CGColor;
        lblpanl.layer.borderWidth = 1.0f;
        [cell.contentView addSubview:lblpanl];
        
        lblpanl.text = [NSString stringWithFormat:@"%@ min",[[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"penalty_time"]];//jam15-07-2015
        
        cell.nationalityLbl.text =  @"country";
        
        cell.unverifiedLbl.text = [[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"country"];
        
        NSString * strCountry = [NSString stringWithFormat:@"%@",[[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"country"]];//jam15-07-2015

        
        NSString *trimmedString=[strCountry substringToIndex:3];
        cell.unverifiedLbl.text =trimmedString;//jam15-07-2015
        cell.unverifiedLbl.frame = CGRectMake(430, 05, 100, 40);
        [cell.contentView addSubview:cell.unverifiedLbl];
        
        cell.nationalityLbl.hidden=YES;
        cell.contentView.userInteractionEnabled = NO;
        
        NSString * strVerify =[[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"verified"];
        
        UIImageView *TEMP=[[UIImageView alloc]initWithFrame:CGRectMake(0,05,280,30)];
        TEMP.image=[UIImage imageNamed:@"arrow1"];
        TEMP.userInteractionEnabled = YES;
        [cell.temp addSubview:TEMP];
        
        
        if ([strVerify isEqualToString:@"(null)"]|| [[totalParticipants objectAtIndex:indexPath.row] valueForKey:@"verified"] ==[NSNull null])
        {
            TEMP.hidden=NO;
            TEMP.image=[UIImage imageNamed:@"arrow1"];

        }
        else
        {
            TEMP.hidden=NO;
            TEMP.image=[UIImage imageNamed:@"arrow1"];
            
        }
        
        UIButton *disclaimerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        disclaimerBtn.frame = CGRectMake(310,05,65,40);
        disclaimerBtn.backgroundColor = [UIColor clearColor];
        [disclaimerBtn addTarget:self action:@selector(disclaimerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        disclaimerBtn.tag = indexPath.row;
        disclaimerBtn.userInteractionEnabled = YES;
        [disclaimerBtn setImage:[UIImage imageNamed:@"disclaimer"] forState:UIControlStateNormal];
        [cell.contentView addSubview:disclaimerBtn];//jam15-07-2015
        
        UIImageView * disclaimerImg = [[UIImageView alloc]init];
        disclaimerImg.frame = CGRectMake(220,3,27,24);
        disclaimerImg.backgroundColor = [UIColor clearColor];
        disclaimerImg.image = [UIImage imageNamed:@"disclaimer"];
        disclaimerImg.userInteractionEnabled = YES;
        [TEMP addSubview:disclaimerImg];//jam15-07-2015

       
        return cell;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailViewTbl)
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
    else if (tableView == stageDetailTbl)
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailViewTbl)
    {
        if (indexPath.row == 7)
        {
            ParticipantsViewController * view = [[ParticipantsViewController alloc]init];
            view.isFromDetail = YES;
            view.eventId=mainId;
            [self.navigationController pushViewController:view animated:YES];
        }
        else if (indexPath.row == 8)
        {
            SponsorsViewController * view = [[SponsorsViewController alloc]init];
            view.isFromDetail = YES;
            view.eventId=mainId;
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    else if (tableView == stageDetailTbl)
    {
      
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    if (tableView ==detailViewTbl)
    {
        return NO;
    }
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //jam14-07-2015.--------start-----------------//
    selectedRow = indexPath.row;
    if (tableView == detailViewTbl)
    {
        return NO;
    }
    else
    {
        UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Add Penalty" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
        {
            isedit=NO;
            selectedRow=indexPath.row;
            
            [self addpenaltyClick];
            
            [stageDetailTbl setEditing:NO];
        }];
        moreAction.backgroundColor = [UIColor darkGrayColor];
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
        {
            isedit=YES;
            selectedRow=indexPath.row;
            
            [self addNewClick];//jam15-07
            [stageDetailTbl setEditing:NO];
        }];
        editAction.backgroundColor = [UIColor lightGrayColor];
        
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                              {
                                                  selectedRow=indexPath.row;
                                                  
                                                  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this Participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                                                  alert.tag = 5;
                                                  [alert show];
                                                  
                                              }];
        
        return @[deleteAction, editAction,moreAction];
    }
    //jam14-07-2015.--------end-----------------//
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //jam14-07-2015.--------start-----------------//
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this Participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 5;
        [alert show];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
        
        
    }
    
    //jam14-07-2015.--------end-----------------//
    
    
}
-(void)addpenaltyClick//jam14-07-2015
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Penalty Time" message:@"Please Enter Penalty Time" delegate:self cancelButtonTitle:@"Add" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    alertTextField.placeholder = @" Enter Penalty Time";
    
    alert.tag=selectedRow;
    
    [alert show];
}

#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"addCompititors"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            if (tempArr.count == 0)
            {
                
            }
            else
            {
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                [dict setValue:[[tempArr valueForKey:@"User"] valueForKey:@"email"] forKey:@"email"];
                [dict setValue:[[tempArr valueForKey:@"User"] valueForKey:@"first_name"] forKey:@"name"];
                [dict setValue:[[tempArr valueForKey:@"User"] valueForKey:@"country"] forKey:@"country"];
                [dict setValue:[[tempArr valueForKey:@"User"] valueForKey:@"id"] forKey:@"user_id"];
                
                [dict setValue:@"no" forKey:@"verified"];
                
                [detailArr addObject:dict];
                
                [[DataBaseManager dataBaseManager] insertTotalParticipantsDetail:dict];
                
                [[NSUserDefaults standardUserDefaults] setObject:detailArr forKey:@"TotalCompetitor"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [participantListTbl reloadData];
                
                
                for (int i = 0; i <[detailArr count]; i++)
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    dict =[[detailArr objectAtIndex:i] mutableCopy];
                    [dict setValue:@"NO" forKey:@"Check"];
                    [detailArr replaceObjectAtIndex:i withObject:dict];
                    
                }
                [participantListTbl reloadData];
                [self cancelNewViewClick];
                
                
            }
            
        }
        else
        {
            NSString * strMsg = [NSString stringWithFormat:@"%@",[[result valueForKey:@"result"]valueForKey:@"msg"]];
            UIAlertView * message = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            message.tag = 12;;
            [message show];
            
            
        }
    }
    
}

- (void)onError:(NSError *)error
{
    
    NSLog(@"The error is...%@", error);
    int ancode = [error code];
    
    if (ancode == -1009)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connectivity" message:@"There is no network connectivity. This application requires a network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    else if(ancode == -1001)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The request time out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark AlertView Delegate
//jam14-07-2015
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            [totalParticipants removeObjectAtIndex:selectedRow];
            [stageDetailTbl reloadData];//jam15-07-2015
        }
        else
        {
            
        }
    }
    else if (alertView.tag== 12)//jam15-07-2015
    {
        
    }
    if (alertView.tag == selectedRow)
    {
        if (buttonIndex == 0)
        {
            [[totalParticipants objectAtIndex:alertView.tag]setObject:[[alertView textFieldAtIndex:0] text] forKey:@"penalty_time"];
            [stageDetailTbl reloadData];//jam15-07-2015
        }
        else
        {
            [stageDetailTbl reloadData];
        }
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Email validation
-(BOOL)validateEmail:(NSString*)email
{
    
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) ){
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return FALSE;
        }
        
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return FALSE;
        }
        
        return TRUE;
    }
    else
    {// no '@' or '.' present
        return FALSE;
    }
}



#pragma mark -  UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText1
{
    
    NSArray *allViews = [searchBar subviews];
    
    for(UIView *obj in allViews)
    {
        NSArray *allViews1 = [obj subviews];
        for(UIView *obj in allViews1)
        {
            if ([obj isKindOfClass:[UITextField class ]])
            {
                //                NSLog(@"textField Found");
                
                UITextField *temp =(UITextField *)obj;
                temp.textColor = [UIColor blackColor];
                
            }
            
        }
    }
    
    if ([searchText1 length]>0)
    {
        [self filterContentForSearchText:searchText1];
        searchBar.showsCancelButton = YES;
        
    }
    else
    {
        searchBar.showsCancelButton = NO;
        [searchBar resignFirstResponder];
        isSearching = NO;
        [participantListTbl reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchStr1 = [NSString stringWithFormat:@"%@",searchBar.text];
    
    if (searchStr1.length >0)
    {
        
        //        [HUD show:YES];
        
        //        [self searchUserWebService:searchStr1];
        searchBar.showsCancelButton = YES;
        
    }
    [searchBar resignFirstResponder];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        PTsearchBar.frame=CGRectMake(20, 125, 600, 44);//jam12-9.
    }
    else
    {
        PTsearchBar.frame=CGRectMake(20, 125, 600, 44);
    }
    [self prefersStatusBarHidden];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
    [searchBar resignFirstResponder];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        PTsearchBar.frame=CGRectMake(20, 125, 600, 44);
    }
    else
    {
        PTsearchBar.frame=CGRectMake(20, 125, 600, 44);
    }
}
- (BOOL)prefersStatusBarHidden
{
    return NO;//jam
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    // if you want the keyboard to go away
    searchBar.text = @"";
    isSearching=NO;
    [participantListTbl reloadData];
    [searchBar resignFirstResponder];
    
}

-(void)filterContentForSearchText:(NSString *)searchText
{
    // Remove all objects from the filtered search array
    [filteredContentArray removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",searchText];
    
    NSArray *tempArray =[[NSArray alloc] init];
    
    
    tempArray = [detailArr filteredArrayUsingPredicate:predicate];
    
    
    if (filteredContentArray)
    {
        filteredContentArray = nil;
    }
    filteredContentArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    //    NSLog(@"filteredListContent:%@",filteredContentArray);
    
    if (searchText == nil || [searchText isEqualToString:@""])
        isSearching = NO;
    else
        isSearching = YES;
    
    [participantListTbl reloadData];
}


#pragma mark - Route Map Methods
#pragma mark - Route Map Methods


-(void)addStagesButtonToMap
{
    
    routeMapArr=[[NSMutableArray alloc] init];
    NSString * sqlQueryStr = [NSString stringWithFormat:@"select * from Map_Table where event_id ='%@'",mainId];
    [[DataBaseManager dataBaseManager] execute:sqlQueryStr resultsArray:routeMapArr];
    
    [self loadRoute];
    
    UILabel * lblSplit =[[UILabel alloc] init];
    lblSplit.frame=CGRectMake(10, 10, 150, 50);
    lblSplit.font=[UIFont systemFontOfSize:20];
    lblSplit.backgroundColor=[UIColor blackColor];
    lblSplit.text=@"Stages";
    lblSplit.textColor=[UIColor whiteColor];
    lblSplit.layer.cornerRadius=5;
    lblSplit.layer.borderColor=[UIColor blackColor].CGColor;
    lblSplit.layer.borderWidth=1.0;
    [self.mapView addSubview:lblSplit];
    lblSplit.layer.shadowColor = [UIColor blackColor].CGColor;
    lblSplit.layer.shadowOpacity = 0.4f;
    lblSplit.layer.shadowOffset = CGSizeMake(0, 2);
    lblSplit.textAlignment=NSTextAlignmentCenter;
    
    int i=0,i1=0;
    NSInteger n;
    
    
    
    n = totalStages.count;
    
    
    
    
    
    
    
    
    int j=0;
    for(j=0; j<2;j++)
    {
        
        while(i<n)
        {
            int y1 = i1*50;
            
            
            CGRect rectframe = CGRectMake(40*j+20+j*20, y1+80, 40, 40);
            UIButton * stagesBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            stagesBtn.frame = rectframe;
            stagesBtn.hidden=NO;
            stagesBtn.backgroundColor=[UIColor blueColor];
            stagesBtn.layer.cornerRadius=20.0f;
            stagesBtn.layer.borderWidth=1.0;
            stagesBtn.layer.borderColor = [UIColor blueColor].CGColor;
            stagesBtn.tag=i;
            //                [stagesBtn addTarget:self action:@selector(StagePinDropFromStages:) forControlEvents:UIControlEventTouchUpInside];
            stagesBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            stagesBtn.layer.shadowOpacity = 0.4f;
            stagesBtn.layer.shadowOffset = CGSizeMake(0, 2);
            
            stagesBtn.enabled=NO;
            
            if ([[totalStages objectAtIndex:i] valueForKey:@"stage_name"] != [NSNull null])
            {
                NSArray * arrName = [[[totalStages objectAtIndex:i] valueForKey:@"stage_name"] componentsSeparatedByString:@" "];
                if ([arrName count]>0)
                {
                    [stagesBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
                }
            }
            
            if ([[[totalStages objectAtIndex:i] objectForKey:@"stage_lat"] isEqualToString:@"Lat"])
            {
                stagesBtn.enabled=YES;
                stagesBtn.alpha=1.0;
            }
            else
            {
                stagesBtn.enabled=NO;
                stagesBtn.alpha=0.5;
                
                
                NSString * latStr =[NSString stringWithFormat:@"%f",[[[totalStages objectAtIndex:i] valueForKey:@"stage_lat"] floatValue]];
                
                NSString * longStr =[NSString stringWithFormat:@"%f",[[[totalStages objectAtIndex:i] valueForKey:@"stage_lon"] floatValue]];
                
                NSString * stageName;
                if ([[totalStages objectAtIndex:i] objectForKey:@"stage_name"])
                {
                    stageName=[[totalStages objectAtIndex:i] objectForKey:@"stage_name"];
                }
                else
                {
                    stageName=[NSString stringWithFormat:@"Stage %d",i+1];
                }
                
                CLLocationCoordinate2D lc =CLLocationCoordinate2DMake([latStr floatValue], [longStr floatValue]);
                
                AMark *mark1 =[[AMark alloc] initWithCoordinate:lc title:stageName lat:latStr long:longStr type:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:[[totalStages objectAtIndex:i] objectForKey:@"id"]];
                
                
                mark1.title=stageName;
                [self.mapView addAnnotation:mark1];
                [self.mapView selectAnnotation:mark1 animated:YES];
                
                
                
            }
            
            [self.mapView addSubview:stagesBtn];
            i++;
            
            
            
            
            i1 = i1+1;
            
        }
        
        
    }
    
    [self addSplitsButtonToMap];
}
-(void)addSplitsButtonToMap
{
    UILabel * lblSplit =[[UILabel alloc] init];
    lblSplit.frame=CGRectMake(704-150-10, 10, 150, 50);
    lblSplit.font=[UIFont systemFontOfSize:20];
    lblSplit.backgroundColor=[UIColor blackColor];
    lblSplit.text=@"Splits";
    lblSplit.textColor=[UIColor whiteColor];
    lblSplit.layer.cornerRadius=5;
    lblSplit.layer.borderColor=[UIColor blackColor].CGColor;
    lblSplit.layer.borderWidth=1.0;
    [self.mapView addSubview:lblSplit];
    
    lblSplit.layer.shadowColor = [UIColor blackColor].CGColor;
    lblSplit.layer.shadowOpacity = 0.4f;
    lblSplit.layer.shadowOffset = CGSizeMake(0, 2);
    lblSplit.textAlignment=NSTextAlignmentCenter;
    
    
    NSMutableArray * mapSplitsArr =[[NSMutableArray alloc] init];
    int i=0,i1=0;
    NSInteger n;
    for (int k=0; k<[totalStages count]; k++)
    {
        NSMutableArray * mySplitsArr =[[NSMutableArray alloc] init];
        
        NSString * strRace = [NSString stringWithFormat:@"SELECT * FROM Splits_Table where event_stage_id = '%@'",[[totalStages objectAtIndex:k] objectForKey:@"id"]];
        [[DataBaseManager dataBaseManager] execute:strRace resultsArray:mySplitsArr];
        for (int j=0; j<[mySplitsArr count]; j++)
        {
            [mapSplitsArr addObject:[mySplitsArr objectAtIndex:j]];
        }
        
    }
    
    n = mapSplitsArr.count;
    
    
    
    
    int j=0;
    for(j=0; j<2;j++)
    {
        
        while(i<n)
        {
            int y1 = i1*50;
            
            
            CGRect rectframe = CGRectMake(40*j+20+j*20+704-150-10, y1+80, 40, 40);
            UIButton * stagesBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            stagesBtn.frame = rectframe;
            stagesBtn.hidden=NO;
            stagesBtn.backgroundColor=[UIColor yellowColor];
            stagesBtn.layer.cornerRadius=20.0f;
            stagesBtn.layer.borderWidth=1.0;
            stagesBtn.layer.borderColor = [UIColor yellowColor].CGColor;
            [stagesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            stagesBtn.tag=i;
            //                [stagesBtn addTarget:self action:@selector(SplitsPinDropFromStages:) forControlEvents:UIControlEventTouchUpInside];
            stagesBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            stagesBtn.layer.shadowOpacity = 0.4f;
            stagesBtn.layer.shadowOffset = CGSizeMake(0, 2);
            stagesBtn.enabled=NO;
            
            if ([[mapSplitsArr objectAtIndex:i] valueForKey:@"split_name"] != [NSNull null])
            {
                NSArray * arrName = [[[mapSplitsArr objectAtIndex:i] valueForKey:@"split_name"] componentsSeparatedByString:@" "];
                if ([arrName count]>0)
                {
                    [stagesBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
                }
            }
            
            if ([[[mapSplitsArr objectAtIndex:i] objectForKey:@"split_lat"] isEqualToString:@"Lat"])
            {
                stagesBtn.enabled=YES;
                stagesBtn.alpha=1.0;
            }
            else
            {
                stagesBtn.enabled=NO;
                stagesBtn.alpha=0.5;
                
                
                
                NSString * latStr =[NSString stringWithFormat:@"%@",[[mapSplitsArr objectAtIndex:i] objectForKey:@"split_lat"] ];
                
                NSString * longStr =[NSString stringWithFormat:@"%@",[[mapSplitsArr objectAtIndex:i] objectForKey:@"split_lon"] ];
                
                NSString * stageName;
                if ([[mapSplitsArr objectAtIndex:i] objectForKey:@"stage_name"])
                {
                    stageName=[[mapSplitsArr objectAtIndex:i] objectForKey:@"split_name"];
                }
                else
                {
                    stageName=[NSString stringWithFormat:@"Split %d",i+1];
                }
                
                CLLocationCoordinate2D lc =CLLocationCoordinate2DMake([latStr floatValue], [longStr floatValue]);
                
                AMark *mark1 =[[AMark alloc] initWithCoordinate:lc title:stageName lat:latStr long:longStr type:@"Splits" withSesstionToken:@"" andSessionId:@"" withUserId:[[mapSplitsArr objectAtIndex:i] objectForKey:@"id"]];
                
                
                mark1.title=stageName;
                [self.mapView addAnnotation:mark1];
                [self.mapView selectAnnotation:mark1 animated:YES];
                
                
            }
            
            
            [self.mapView addSubview:stagesBtn];
            i++;
            i1 = i1+1;
            
        }
    }
    
    
    
}


- (void)addPinAnnotation:(id)sender
{
    routeStagesTotal=routeStagesTotal+1;
    
    NSString * latStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].latitude];
    
    NSString * longStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].longitude];
    
    //    AMark *mark1 = [[AMark alloc]initWithCoordinate:[self.mapView centerCoordinate] title:@"kp" entryLbl:latStr passesLbl:longStr ingStr:@"Stages" withSesstionToken:@"kp4" andSessionId:@"kp5" withUserId:@"kp6"];
    
    AMark *mark1 =[[AMark alloc] initWithCoordinate:[self.mapView centerCoordinate] title:@"Start Point" lat:latStr long:longStr type:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
    
    mark1.title=[NSString stringWithFormat:@"Stage %d",routeStagesTotal];
    [self.mapView addAnnotation:mark1];
    [self.mapView selectAnnotation:mark1 animated:YES];
    
}

- (void)addSplitsAnnotaions:(id)sender
{
    NSString * latStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].latitude];
    
    NSString * longStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].longitude];
    
    routeSplitsTotal=routeSplitsTotal+1;
    //    AMark *mark1 = [[AMark alloc]initWithCoordinate:[self.mapView centerCoordinate] title:@"" entryLbl:latStr passesLbl:longStr ingStr:@"Splits" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
    
    AMark *mark1 =[[AMark alloc] initWithCoordinate:[self.mapView centerCoordinate] title:@"Start Point" lat:latStr long:longStr type:@"Start" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
    
    
    mark1.title=[NSString stringWithFormat:@"Splits %d",routeSplitsTotal];
    [self.mapView addAnnotation:mark1];
    [self.mapView selectAnnotation:mark1 animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        
        
    }
}
// creates the route (MKPolyline) overlay
-(void) loadRoute
{
    /*  NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
     NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
     NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];*/
    
    
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = (malloc(sizeof(CLLocationCoordinate2D) * routeMapArr.count));
    
    
    
    for(int idx = 0; idx < routeMapArr.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        /*NSString* currentPointString = [pointStrings objectAtIndex:idx];
         NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];*/
        
        CLLocationDegrees latitude  = [[[routeMapArr objectAtIndex:idx] objectForKey:@"lat"] doubleValue];
        CLLocationDegrees longitude = [[[routeMapArr objectAtIndex:idx] objectForKey:@"long"] doubleValue];
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        /*if (idx==0)
         {
         
         AMark *mark1 =[[AMark alloc] initWithCoordinate:coordinate title:@"Start Point" lat:[NSString stringWithFormat:@"%f",latitude] long:[NSString stringWithFormat:@"%f",longitude] type:@"Start" withSesstionToken:@"" andSessionId:@"" withUserId:mainId];
         
         mark1.title=@"Start Point";
         [self.mapView addAnnotation:mark1];
         
         [self.mapView selectAnnotation:mark1 animated:YES];
         }
         else if (idx ==[routeMapArr count]-1)
         {
         
         AMark *mark1 =[[AMark alloc] initWithCoordinate:coordinate title:@"End Point" lat:@"" long:@"" type:@"End" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
         
         mark1.title=@"End Point";
         [self.mapView addAnnotation:mark1];
         [self.mapView selectAnnotation:mark1 animated:YES];
         }
         else
         {
         
         }*/
        
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        
        //
        // adjust the bounding box
        //
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
        
    }
    
    // create the polyline based on the array of points.
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:routeMapArr.count];
    
    
    
    _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    // clear the memory allocated earlier for the points
    free(pointArr);
    
}


-(void) zoomInOnRoute
{
    [self.mapView setVisibleMapRect:_routeRect];
}


#pragma mark - Statically Add Stages/Splits
-(void)addStages
{
    
    
    for (int i=0; i<=1; i++)
    {
        CLLocationCoordinate2D coordinate;
        
        NSString * latStr;
        NSString * longStr;
        
        if (i==0)
        {
            coordinate = CLLocationCoordinate2DMake(37.337383,-122.029736);
            latStr=@"37.337383";
            longStr=@"-122.029736";
            
        }
        else
        {
            coordinate = CLLocationCoordinate2DMake(37.334440,-122.041564);
            latStr=@"37.334440";
            longStr=@"-122.041564";
        }
        
        //        AMark *mark1 = [[AMark alloc]initWithCoordinate:coordinate title:@"" entryLbl:latStr passesLbl:longStr ingStr:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
        
        AMark *mark1 =[[AMark alloc] initWithCoordinate:coordinate title:@"Start Point" lat:latStr long:longStr type:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
        
        mark1.title=[NSString stringWithFormat:@"Stage %d",i+1];
        [self.mapView addAnnotation:mark1];
        [self.mapView selectAnnotation:mark1 animated:YES];
        
    }
    
    for (int i=0; i<=2; i++)
    {
        CLLocationCoordinate2D coordinate;
        
        NSString * latStr;
        NSString * longStr;
        
        if (i==0)
        {
            coordinate = CLLocationCoordinate2DMake(37.335284, -122.032376);
            latStr=@"37.335284";
            longStr=@"-122.032376";
        }
        else if(i==1)
        {
            coordinate = CLLocationCoordinate2DMake(37.334627, -122.036904);
            latStr=@"37.334627";
            longStr=@"-122.036904";
        }
        
        else
        {
            coordinate = CLLocationCoordinate2DMake(37.334388,	-122.045431);
            latStr=@"37.334388";
            longStr=@"-122.045431";
        }
        
        //        AMark *mark1 = [[AMark alloc]initWithCoordinate:coordinate title:@"" entryLbl:latStr passesLbl:longStr ingStr:@"Splits" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
        
        AMark *mark1 =[[AMark alloc] initWithCoordinate:coordinate title:@"" lat:latStr long:longStr type:@"Splits" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
        
        mark1.title=[NSString stringWithFormat:@"Splipt %d",i+1];
        [self.mapView addAnnotation:mark1];
        [self.mapView selectAnnotation:mark1 animated:YES];
        
    }
    
    
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine] ;
            self.routeLineView.fillColor = [UIColor yellowColor];
            self.routeLineView.strokeColor = [UIColor yellowColor];
            self.routeLineView.lineWidth = 15;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != _mapView.userLocation)
    {
        static NSString *defaultPinID = @"myPin";
        pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID] ;
        
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = NO;
        pinView.animatesDrop = YES;
        pinView.draggable=NO;
        
        NSArray * mapType =[[annotation title] componentsSeparatedByString:@" "];
        NSLog(@"trrer=%@",mapType);
        
        
        if ([[mapType objectAtIndex:0] isEqualToString:@"Stage"])
        {
            pinView.pinColor = MKPinAnnotationColorRed;
            
        }
        else if([[mapType objectAtIndex:0] isEqualToString:@"Splits"])
        {
            pinView.pinColor = MKPinAnnotationColorGreen;
            
        }
        else
        {
            pinView.pinColor = MKPinAnnotationColorPurple;
            
        }
        
        
    }
    else
    {
        [_mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        //        [calloutView removeFromSuperview];
        
        calloutView = (AMarkView *)[[[NSBundle mainBundle] loadNibNamed:@"AMarkView" owner:self options:nil] objectAtIndex:0];
        previosTag=tags;
        
        calloutView.tag = tags ++;
        
        
        
        CGRect calloutViewFrame = calloutView.frame;
        
        
        if ([[(AMark*)[view annotation] title] isEqualToString:@"Start Point"]||[[(AMark*)[view annotation] title] isEqualToString:@"End Point"])
        {
            calloutViewFrame.size.width=105;
            calloutViewFrame.size.height=30;
            calloutView.titleLbl.textColor=[UIColor whiteColor];
            calloutView.backgroundColor=[UIColor yellowColor];
            calloutView.latLbl.hidden=YES;
            calloutView.longLbl.hidden=YES;
        }
        else
        {
            calloutViewFrame.size.width=105;
            calloutViewFrame.size.height=70;
            calloutView.titleLbl.textColor=[UIColor blackColor];
            calloutView.backgroundColor=[UIColor blackColor];
            calloutView.latLbl.hidden=NO;
            calloutView.longLbl.hidden=NO;
            
            
        }
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        
        [calloutView.titleLbl setText:[(AMark*)[view annotation] title]];
        [calloutView.latLbl setText:[(AMark*)[view annotation] latStr]];
        [calloutView.longLbl setText:[(AMark*)[view annotation] longStr]];
        
        calloutView.latLbl.textColor=[UIColor blackColor];
        calloutView.longLbl.textColor=[UIColor blackColor];
        
        CLLocationCoordinate2D droppedAt = view.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        calloutView.latLbl.text=[NSString stringWithFormat:@"Lat : %f",droppedAt.latitude];
        
        calloutView.longLbl.text=[NSString stringWithFormat:@"Long : %f",droppedAt.longitude];
        
        if ([[(AMark*)[view annotation] type] isEqualToString:@"Stages"])
        {
            calloutView.backgroundColor=[UIColor colorWithRed:91.0/255.0 green:249.0/255.0 blue:61.0/255.0 alpha:1];
            
        }
        else if ([[(AMark*)[view annotation] type] isEqualToString:@"Splits"])
        {
            calloutView.backgroundColor=[UIColor colorWithRed:7.0/255.0 green:246.0/255.0 blue:251.0/255.0 alpha:1];
            
        }
        else if ([[(AMark*)[view annotation] type] isEqualToString:@"Start"])
        {
            calloutView.backgroundColor=[UIColor greenColor];
            
        }
        else if ([[(AMark*)[view annotation] type] isEqualToString:@"End"])
        {
            calloutView.backgroundColor=[UIColor redColor];
            
        }
        
        calloutView.titleLbl.textAlignment=NSTextAlignmentCenter;
        calloutView.layer.borderColor=[UIColor blackColor].CGColor;
        calloutView.layer.borderWidth=1.0;
        
        
        [view addSubview:calloutView];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                          animationWithKeyPath:@"transform"];
        
        CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
        CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
        CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
        CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
        
        NSArray *frameValues = [NSArray arrayWithObjects:
                                [NSValue valueWithCATransform3D:scale1],
                                [NSValue valueWithCATransform3D:scale2],
                                [NSValue valueWithCATransform3D:scale3],
                                [NSValue valueWithCATransform3D:scale4],
                                nil];
        [animation setValues:frameValues];
        
        NSArray *frameTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:0.9],
                               [NSNumber numberWithFloat:1.0],
                               nil];
        [animation setKeyTimes:frameTimes];
        
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = .2;
        
        
        [view.layer addAnimation:animation forKey:@"popup"];
        
        
        calloutView.callOutButton.hidden=YES;
        [calloutView.callOutButton addTarget:self action:@selector(onCallOut:) forControlEvents:UIControlEventTouchUpInside];
        [calloutView.callOutButton setBackgroundColor:[UIColor redColor]];
        calloutView.callOutButton.tag = calloutView.tag;
    }
    
}


#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (IS_IPAD)
    {
        
        BOOL didResign = [textField resignFirstResponder];
        if (!didResign) return NO;
        
        NSUInteger index = [fieldArray indexOfObject:textField];
        if (index == NSNotFound || index + 1 == fieldArray.count)
        {
            return NO;
        }
        id nextField = [fieldArray objectAtIndex:index + 1];
        //activeField = nextField;
        [nextField becomeFirstResponder];
        if (textField==txtNumberId)
        {
            [textField resignFirstResponder];
        }
        else
        {
            
        }
        return NO;
        
    }
    else
    {
        
        BOOL didResign = [textField resignFirstResponder];
        if (!didResign) return NO;
        
        NSUInteger index = [fieldArray indexOfObject:textField];
        if (index == NSNotFound || index + 1 == fieldArray.count)
        {
            return NO;
        }
        id nextField = [fieldArray objectAtIndex:index + 1];
        //activeField = nextField;
        [nextField becomeFirstResponder];
        return NO;
        
        
        [textField resignFirstResponder];
        return YES;
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtemail)
    {
        emailLbl.hidden = YES;
        txtemail.text = emailLbl.text;
        [participantsDict setValue:textField.text forKey:@"email"];
    }
    else if (textField == txtName)
    {
        nameLbl.hidden = YES;
        txtName.text = nameLbl.text;
        [participantsDict setValue:textField.text forKey:@"name"];
    }
    else if (textField == txtNationality)
    {
        nationalityLbl.hidden = YES;
        txtNationality.text = nationalityLbl.text;
        [participantsDict setValue:textField.text forKey:@"country"];
    }
    else if (textField == txtNumberId)
    {
        numberIdLbl.hidden = YES;
        txtNumberId.text = numberIdLbl.text;
        [participantsDict setValue:textField.text forKey:@"compititorNumber"];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txtemail)
    {
        emailLbl.hidden = NO;
        emailLbl.text = textField.text;
        [participantsDict setValue:textField.text forKey:@"email"];
        txtemail.text=@"";
    }
    else if (textField == txtName)
    {
        nameLbl.hidden = NO;
        nameLbl.text = textField.text;
        [participantsDict setValue:textField.text forKey:@"name"];
        txtName.text=@"";
        
    }
    else if (textField == txtNationality)
    {
        nationalityLbl.hidden = NO;
        nationalityLbl.text = textField.text;
        [participantsDict setValue:textField.text forKey:@"country"];
        txtNationality.text=@"";
        
    }
    else if (textField == txtNumberId)
    {
        numberIdLbl.hidden = NO;
        numberIdLbl.text = textField.text;
        [participantsDict setValue:textField.text forKey:@"compititorNumber"];
        txtNumberId.text=@"";
        
    }
    
    return YES;
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
