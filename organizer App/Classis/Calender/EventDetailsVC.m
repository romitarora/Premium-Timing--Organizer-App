//
//  EventDetailsVC.m
//  organizer App
//
//  Created by One Click IT Consultancy  on 5/30/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "EventDetailsVC.h"
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
@interface EventDetailsVC ()
{
    NSInteger tags;
    NSInteger previosTag;
    AMarkView *calloutView;
    int page;

}
@end
@implementation EventDetailsVC
@synthesize mainId;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView,eventName;
@synthesize tableId,organiserName;//jam15-07-2015

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    selectedListArr = [[NSMutableArray alloc]init];
    detailDict = [[NSMutableDictionary alloc]init];
    
    detailArr = [[NSMutableArray alloc]init];
    
    
    /*
    NSString * strQueary = [NSString stringWithFormat:@"select * from GeneralInfo_Table where event_id = '%@'",tableId];
    [[DataBaseManager dataBaseManager] execute:strQueary resultsArray:detailArr];

    totalStages=[[NSMutableArray alloc] init];
    NSString * stagesStr = [NSString stringWithFormat:@"select * from Stages_Table where event_id = '%@'",tableId];
    [[DataBaseManager dataBaseManager] execute:stagesStr resultsArray:totalStages];
    
    
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
    
    if (detailArr.count == 0)
    {
    }
    else
    {
        eventDetailDict = [detailArr objectAtIndex:0];
        NSString * str1 =[NSString stringWithFormat:@"select * from EventSponsors_Table where event_id = '%@'",tableId];
        
        NSString * str2 =[NSString stringWithFormat:@"select * from EventParticipants_Table where event_id = '%@'",tableId];
        
        
        NSMutableArray * totalspns =[[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:str1 resultsArray:totalspns];
        
        NSMutableArray * totalcmptr =[[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:str2 resultsArray:totalcmptr];
        
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
        
        [eventDetailDict setObject:[NSString stringWithFormat:@"%d",[totalcmptr count]] forKey:@"totalCompetitor"];
        
    }
    
    */
    
    [self gettingDataFromDatabase:mainId];
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navView];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text =eventName;
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    UIImageView * backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 12, 22);;
    backimg.image = [UIImage imageNamed:@"back.png"];
    [navView addSubview:backimg];
    
    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 100, 30);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:backBtn];
    
    editBtn = [[UIButton alloc]init];
    editBtn.frame = CGRectMake(navView.frame.size.width-100, 30, 100, 30);
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:editBtn];
    
    tapbarView = [[UIView alloc]init];
    tapbarView.frame = CGRectMake(20, 82, 704-40, 60);
    tapbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapbarView];
    
    genralLbl = [[UILabel alloc]init];
    genralLbl.frame = CGRectMake(0, 10, tapbarView.frame.size.width/3, 30);
    genralLbl.text = @"General Info";
    genralLbl.textColor = [UIColor yellowColor];
    genralLbl.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    genralLbl.backgroundColor = [UIColor clearColor];
    genralLbl.textAlignment = NSTextAlignmentCenter;
    [tapbarView addSubview:genralLbl];
    
    generalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    generalBtn.frame=CGRectMake(0, 0, tapbarView.frame.size.width/3, 50);
    [generalBtn addTarget:self action:@selector(generalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tapbarView addSubview:generalBtn];
    
    
    stagesLbl = [[UILabel alloc]init];
    stagesLbl.frame = CGRectMake(tapbarView.frame.size.width/3, 10, tapbarView.frame.size.width/3, 30);
    stagesLbl.text = @"Stages & Splits";
    stagesLbl.textColor = [UIColor whiteColor];
    stagesLbl.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    stagesLbl.backgroundColor = [UIColor clearColor];
    stagesLbl.textAlignment = NSTextAlignmentCenter;
    [tapbarView addSubview:stagesLbl];
    
    stageSplitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    stageSplitBtn.frame=CGRectMake(tapbarView.frame.size.width/3, 0, tapbarView.frame.size.width/3, 50);
    [stageSplitBtn addTarget:self action:@selector(stagesSplitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tapbarView addSubview:stageSplitBtn];
    
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
        scrlContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, 704, 768-140)];
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
    [self.view addSubview:scrlContent];
    [self.view bringSubviewToFront:scrlContent];
    
    btnNext=[[UIButton alloc]initWithFrame:CGRectMake(0, 768-50, 704, 50)];
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    btnNext.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnNext.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    [self.view addSubview:btnNext];
    
    
    
    int xx = 0;
    for (int i = 0; i<3; i++)
    {
        if (i==0)
        {
            
            
            backView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, scrlContent.frame.size.width-20, scrlContent.frame.size.height-50)];
            backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"box.png"]];
            backView.userInteractionEnabled=YES;
            [scrlContent addSubview:backView];
            
            
         
            
            //            [self setViewFrame];
            
            
            detailViewTbl =[[UITableView alloc] initWithFrame:CGRectMake(15, 10, backView.frame.size.width-30, 768-140-30-50) style:UITableViewStylePlain];
            detailViewTbl.backgroundColor = [UIColor clearColor];
            [detailViewTbl setDelegate:self];
            [detailViewTbl setDataSource:self];
            [detailViewTbl setSeparatorColor:[UIColor clearColor]];
            [detailViewTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            detailViewTbl.showsVerticalScrollIndicator=NO;
            [backView addSubview:detailViewTbl];
            
            noticeMsgLbl = [[UILabel alloc]init];
            noticeMsgLbl.frame = CGRectMake(30, 200, 704-60, 200);
            noticeMsgLbl.textColor = [UIColor whiteColor];
            noticeMsgLbl.backgroundColor = [UIColor clearColor];
            noticeMsgLbl.textAlignment = NSTextAlignmentCenter;
            noticeMsgLbl.text = @"Loading...";
            noticeMsgLbl.numberOfLines = 0;
            noticeMsgLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
            noticeMsgLbl.hidden = NO;
            [backView addSubview:noticeMsgLbl];
            
            NSString * strQueary = [NSString stringWithFormat:@"select * from GeneralInfo_Table where event_id = '%@'",tableId];
            detailArr=[[NSMutableArray alloc] init];
            [[DataBaseManager dataBaseManager] execute:strQueary resultsArray:detailArr];
            if ([detailArr count]==0)
            {
                
                
                detailViewTbl.hidden=YES;
            }
            else
            {
                detailViewTbl.hidden=NO;
                
            }
            
            
        }
        else if (i == 1)
        {
            stageDetailTbl = [[UITableView alloc]init];
            stageDetailTbl.frame = CGRectMake(scrlContent.frame.size.width+10, 0, scrlContent.frame.size.width-20, scrlContent.frame.size.height);
            stageDetailTbl.backgroundColor = [UIColor clearColor];
            [stageDetailTbl setDelegate:self];
            [stageDetailTbl setDataSource:self];
            [stageDetailTbl setSeparatorColor:[UIColor clearColor]];
            [stageDetailTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            stageDetailTbl.backgroundColor = [UIColor clearColor];
            [scrlContent addSubview:stageDetailTbl];
        }
        else if (i == 2)
        {
            /*
             _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(scrlContent.frame.size.width*2, 0, 710, 768)];
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
             [self zoomInOnRoute];
             */
            
        }
        xx = xx+scrlContent.frame.size.width;
        scrlContent.contentSize = CGSizeMake(704 * 3, scrlContent.frame.size.height);
        
    }
    
    [self getGenaralDetail];
    
    scrlContent.scrollEnabled=NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [detailViewTbl reloadData];
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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
-(void)btnNextClick:(id)sender
{
    if (page == 0)
    {
        btnNext.hidden = NO;
        [scrlContent setContentOffset:CGPointMake(704, 0) animated:YES];
    }
    else if (page == 1)
    {
        [scrlContent setContentOffset:CGPointMake(704*2, 0) animated:YES];
        btnNext.hidden = YES;
    }
    else if (page == 2)
    {
        
    }
    
}
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)competitorBtnClick:(id)sender
{
    
}
-(void)editBtnClick:(id)sender
{
    
    CreateEventViewController * view =[[CreateEventViewController alloc]init];
    view.isFromEdit = YES;
    view.editDict = eventDetailDict;
    //    view.mainId = [[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"];
    //    view.eventName =[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_name"];
    view.mainId = [eventDetailDict valueForKey:@"event_id"];
    view.eventName =[eventDetailDict  valueForKey:@"event_name"];
    view.tableId =[eventDetailDict  valueForKey:@"id"];

//
    
    [self.navigationController pushViewController:view animated:YES];
    
}
-(void)setViewFrame
{
    if (IS_IPAD)
    {
        scrlImages = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 0, backView.frame.size.width-40, 280)];
        [scrlImages setContentSize:CGSizeMake(scrlImages.frame.size.width*4, 280)];
        
    }
    else
    {
        
    }
    [scrlImages setBackgroundColor:[UIColor clearColor]];
    scrlImages.pagingEnabled = YES;
    scrlImages.bounces = NO;
    scrlImages.delegate = self;
    scrlImages.userInteractionEnabled = NO;
    scrlImages.showsHorizontalScrollIndicator = NO;
    scrlImages.showsVerticalScrollIndicator = NO;
    [backView addSubview:scrlImages];
    [self.view bringSubviewToFront:scrlImages];
    
    UIImageView * imgBg;
    int xx = 0;
    for (int i = 0; i<4; i++)
    {
        
        imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(xx, 20, scrlImages.frame.size.width, scrlImages.frame.size.height-40)];
        [scrlImages addSubview:imgBg];
        
        
        if (i==0)
        {
            if (IS_IPAD)
            {
                [imgBg setFrame:CGRectMake(xx, 20, scrlImages.frame.size.width, scrlImages.frame.size.height-40)];
                [imgBg setImage:[UIImage imageNamed:@"raceimg.png"]];
                imgBg.contentMode = UIViewContentModeScaleAspectFill;
                imgBg.backgroundColor = [UIColor blueColor];
                
            }
            else
            {
                if (IS_IPHONE_5)
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 568)];
                    [imgBg setImage:[UIImage imageNamed:@"w1_iPhone_5_bg.png"]];
                    
                    
                    
                }
                else
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 480)];
                    [imgBg setImage:[UIImage imageNamed:@"w1_iPhone_4_bg.png"]];
                    
                    
                }
            }
            
            
        }
        else if (i==1)
        {
            if (IS_IPAD)
            {
                [imgBg setFrame:CGRectMake(xx, 20, scrlImages.frame.size.width, scrlImages.frame.size.height-40)];
                [imgBg setImage:[UIImage imageNamed:@"w2_iPhone_4_bg.png"]];
                imgBg.backgroundColor = [UIColor orangeColor];
                
            }
            else
            {
                if (IS_IPHONE_5)
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 568)];
                    [imgBg setImage:[UIImage imageNamed:@"w2_iPhone_5_bg.png"]];
                    
                    
                }
                else
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 480)];
                    [imgBg setImage:[UIImage imageNamed:@"w2_iPhone_4_bg.png"]];
                    
                }
            }
            
        }
        else if (i==2)
        {
            if (IS_IPAD)
            {
                [imgBg setFrame:CGRectMake(xx, 20, scrlImages.frame.size.width, scrlImages.frame.size.height-40)];
                [imgBg setImage:[UIImage imageNamed:@"w3_iPhone_4_bg.png"]];
                imgBg.backgroundColor = [UIColor darkGrayColor];
                
            }
            else
            {
                if (IS_IPHONE_5)
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 568)];
                    [imgBg setImage:[UIImage imageNamed:@"w3_iPhone_5_bg.png"]];
                    
                }
                else
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 480)];
                    [imgBg setImage:[UIImage imageNamed:@"w3_iPhone_4_bg.png"]];
                    
                }
            }
            
        }
        
        else if (i==3)
        {
            if (IS_IPAD)
            {
                [imgBg setFrame:CGRectMake(xx, 20, scrlImages.frame.size.width, scrlImages.frame.size.height-40)];
                [imgBg setImage:[UIImage imageNamed:@"w6_iPhone_4_bg.png"]];
                imgBg.backgroundColor = [UIColor redColor];
            }
            else
            {
                if (IS_IPHONE_5)
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 568)];
                    [imgBg setImage:[UIImage imageNamed:@"w6_iPhone_5_bg.png"]];
                }
                else
                {
                    [imgBg setFrame:CGRectMake(0, 0, 320, 480)];
                    [imgBg setImage:[UIImage imageNamed:@"w6_iPhone_4_bg.png"]];
                }
            }
            
            
        }
        
        if (IS_IPAD)
        {
            [imgBg setFrame:CGRectMake(xx, 20, scrlImages.frame.size.width, scrlImages.frame.size.height-40)];
            
            
        }
        else
        {
            if (IS_IPHONE_5)
            {
                [imgBg setFrame:CGRectMake(0, 0, 320, 568)];
                
                
            }
            else
            {
                [imgBg setFrame:CGRectMake(0, 0, 320, 480)];
                
                
            }
        }
        
        xx = xx+scrlImages.frame.size.width;
        
    }
    if (IS_IPAD)
    {
        if (IS_OS_8_OR_LATER)
        {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(192, 250, 300, 60)];
        }
        else
        {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(230, 370, 300, 60)];
        }
    }
    else
    {
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110,380, 100, 20)];
    }
    pageControl.numberOfPages = 4;
    pageControl.tintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"scroller-dot"]];
    pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    [backView addSubview:pageControl];
}
#pragma mark- Header Button Click Event
-(void)generalBtnClick
{
    [self purgeMapMemory];
    
    [scrlContent setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)stagesSplitBtnClick
{
    [self purgeMapMemory];
    
     NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
     [dict setObject:mainId forKey:@"event_id"];
     
     URLManager *manager = [[URLManager alloc] init];
     manager.commandName = @"getStagesDetail";
     manager.delegate = self;
     [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getStagesofEvent" withParameters:dict];
    
    
    [stageDetailTbl reloadData];
    
    
    [scrlContent setContentOffset:CGPointMake(704, 0) animated:YES];
    
}
-(void)mapBtnClick
{
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
#pragma mark - Route Map Methods


-(void)addStagesButtonToMap
{
    
    routeMapArr=[[NSMutableArray alloc] init];
    NSString * sqlQueryStr = [NSString stringWithFormat:@"select * from Map_Table where event_id ='%@'",tableId];
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


#pragma mark Webservice Method

-(void)getGenaralDetail
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:mainId forKey:@"event_id"];
    [dict setObject:@"" forKey:@"updated_date"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getGenaralDetail";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getEventDetails" withParameters:dict];
}

#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"getGenaralDetail"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            [app hudEndProcessMethod];

            detailViewTbl.hidden=NO;

            detailArr = [[NSMutableArray alloc]init];
            detailArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            eventDetailDict =[[detailArr objectAtIndex:0] mutableCopy];
//            [detailViewTbl reloadData];
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"] forKey:@"event_id"];
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_name"] forKey:@"event_name"];
            [dict setValue:[[eventDetailDict valueForKey:@"pt_event_category"] valueForKey:@"event_category_id"] forKey:@"cat_name"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"age_category"] forKey:@"age_category"];
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"location"] forKey:@"location"];
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_date"] forKey:@"event_date"];
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_start_date"] forKey:@"event_start_date"];
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_end_date"] forKey:@"event_end_date"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"manual_start"] forKey:@"manual_start"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"race_description"] forKey:@"race_description"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"0"] valueForKey:@"competitors_count"] forKey:@"competitors_count"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"0"] valueForKey:@"sponser_count"] forKey:@"sponser_count"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"website_url"] forKey:@"website_url"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"start_method"] forKey:@"start_method"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"pt_race_type"] valueForKey:@"race_name"] forKey:@"race_name"];
            
            [dict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"updated_date"] forKey:@"updated_date"];
            
            [dict setValue:organiserName forKey:@"organiser_name"];//jam15-07-2015
            
            NSString * str = [NSString stringWithFormat:@"delete from GeneralInfo_Table where event_id = '%@'",[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"]];
            
            
            [[DataBaseManager dataBaseManager] execute:str];
            
            [[DataBaseManager dataBaseManager] insertGeneralInfoDetail:dict];
            
           
            NSString* strdelete = [NSString stringWithFormat:@"delete from Images_Table where event_id = '%@'",[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"]];
            
            [[DataBaseManager dataBaseManager] execute:strdelete];
            
            
            NSMutableDictionary * imgDict = [[NSMutableDictionary alloc]init];
            
            if ([[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_photo1"] isEqualToString:@""])
            {
                
            }
            else
            {
                
                NSString * strPhoto =[NSString stringWithFormat:@"%@%@",[[eventDetailDict valueForKey:@"0"] valueForKey:@"event_path"],[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_photo1"]];
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strPhoto]];
                
                NSString * encoded = [imageData base64Encoding];
                
                
                [imgDict setValue:encoded forKey:@"event_photo1"];
            }
            
            if ([[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_photo2"] isEqualToString:@""])
            {
                
            }
            else
            {
                
                NSString * strPhoto =[NSString stringWithFormat:@"%@%@",[[eventDetailDict valueForKey:@"0"] valueForKey:@"event_path"],[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_photo2"]];
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strPhoto]];
                
                NSString * encoded = [imageData base64Encoding];
                
                [imgDict setValue:encoded forKey:@"event_photo2"];
            }
            
            if ([[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_photo3"] isEqualToString:@""])
            {
                
            }
            else
            {
                
                NSString * strPhoto =[NSString stringWithFormat:@"%@%@",[[eventDetailDict valueForKey:@"0"] valueForKey:@"event_path"],[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_photo3"]];
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strPhoto]];
                
                NSString * encoded = [imageData base64Encoding];
                
                [imgDict setValue:encoded forKey:@"event_photo3"];
                
            }
            
            
            [imgDict setValue:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"] forKey:@"event_id"];
            
            [[DataBaseManager dataBaseManager] insertImagesDetail:imgDict];
            
            
            totalImgs =[[NSMutableArray alloc] init];
            
            NSString * str3 =[NSString stringWithFormat:@"select * from Images_Table where event_id = '%@'",[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"]];
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
            

            
            [self gettingDataFromDatabase:[[eventDetailDict valueForKey:@"event"] valueForKey:@"event_id"]];
            
            
        }
        else
        {
            
            
        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"getStagesDetail"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Stages_Table where event_id = '%@'",[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"event_id"]];
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            for (int k=0; k<[tempArr count]; k++)
            {
                NSMutableDictionary * dict  = [[NSMutableDictionary alloc]init];
                
                [dict setValue:[[[tempArr objectAtIndex:0]valueForKey:@"pt_event_stages"] valueForKey:@"event_id"] forKey:@"event_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"]valueForKey:@"event_stage_id"] forKey:@"event_stage_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"]  valueForKey:@"stage_name"] forKey:@"stage_name"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"start_time"] forKey:@"start_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_bluetooth_device_master"] valueForKey:@"device_name"] forKey:@"device_name"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"]  valueForKey:@"device_id"] forKey:@"device_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"penalty_time"] forKey:@"penalty_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"liason_time"] forKey:@"liason_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"rest_time"] forKey:@"rest_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"created_date"] forKey:@"created_date"];
                
                [dict setValue:[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"updated_date"] forKey:@"updated_date"];
                
                [dict setValue:[[tempArr objectAtIndex:0] valueForKey:@"split_count"] forKey:@"split_count"];
                
                
                [[DataBaseManager dataBaseManager] insertStagesDetail:dict];
            }
            
            
            
            
            
            
            totalStages = [[NSMutableArray alloc]init];
            NSString * strstage = [NSString stringWithFormat:@"select * from Stages_Table where event_id = '%@'",[[[tempArr objectAtIndex:0] valueForKey:@"pt_event_stages"] valueForKey:@"event_id"]];
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
            
            [stageDetailTbl reloadData];
            
            
        }
        else
        {
            
        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"getSplitsDetail"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Splits_Table where event_stage_id = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"stage_id"]];
            
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            
            for (int i =0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"event_stage_id"] forKey:@"event_stage_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"stage_split_id"] forKey:@"stage_split_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"split_name"] forKey:@"split_name"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"start_time"] forKey:@"start_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_bluetooth_device_master"] valueForKey:@"device_name"] forKey:@"device_name"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"device_id"] forKey:@"device_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"penalty_time"] forKey:@"penalty_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"created_date"] forKey:@"created_date"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_stage_splits"] valueForKey:@"updated_date"] forKey:@"updated_date"];
                
                
                
                [[DataBaseManager dataBaseManager] insertSplitsDetail:dict];
                
            }
            
        }
        else
        {
            
        }
        
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"getCompetitorsByEventId"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from EventParticipants_Table where event_id = '%@'",[eventDetailDict valueForKey:@"event_id"]];
            
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            
            for (int i =0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event_competitors"] valueForKey:@"event_id"] forKey:@"event_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event_competitors"] valueForKey:@"user_id"] forKey:@"user_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"first_name"] forKey:@"name"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"email"] forKey:@"emailId"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"country"] forKey:@"country"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"competitor_number"] forKey:@"compititorNumber"];
                
                [[DataBaseManager dataBaseManager] insertEventParticipantsDetail:dict];
                
               
                
                
            }
            
            ParticipantsViewController * view = [[ParticipantsViewController alloc]init];
            view.isFromDetail = YES;
            view.eventId=mainId;
            [self.navigationController pushViewController:view animated:YES];
            
        }
        else
        {
            
        }
        
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"getSponsersByEventId"])
    {
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from EventSponsors_Table where event_id = '%@'",[eventDetailDict valueForKey:@"event_id"]];
            
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            
            for (int i =0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event_sponsers"] valueForKey:@"event_id"] forKey:@"event_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event_sponsers"] valueForKey:@"sponser_id"] forKey:@"sponser_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_sponsers"] valueForKey:@"sponser_name"] forKey:@"sponser_name"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_sponsers"] valueForKey:@"address"] forKey:@"address"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_sponsers"] valueForKey:@"contact_no"] forKey:@"contact_no"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event_sponsers"] valueForKey:@"created_date"] forKey:@"created_date"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_sponsers"] valueForKey:@"email"] forKey:@"email"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_sponsers"] valueForKey:@"photo"] forKey:@"photo"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_sponsers"] valueForKey:@"website"] forKey:@"website"];
                
                
                [[DataBaseManager dataBaseManager] insertEventSponsorsDetail:dict];
                
               
                
            }
            
            SponsorsViewController * view = [[SponsorsViewController alloc]init];
            view.isFromDetail = YES;
            view.eventId=mainId;
            [self.navigationController pushViewController:view animated:YES];
        }
        else
        {
            
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

-(void)gettingDataFromDatabase :(NSString *)tableId
{
    NSString * strQueary = [NSString stringWithFormat:@"select * from GeneralInfo_Table where event_id = '%@'",tableId];
    detailArr=[[NSMutableArray alloc] init];
    [[DataBaseManager dataBaseManager] execute:strQueary resultsArray:detailArr];
    eventDetailDict = [[NSMutableDictionary alloc]init];
    if ([detailArr count]==0)
    {
        
        noticeMsgLbl.hidden=NO;

//        detailViewTbl.hidden=YES;
    }
    else
    {
        noticeMsgLbl.hidden=YES;

//        detailViewTbl.hidden=NO;

        eventDetailDict=[[detailArr objectAtIndex:0] mutableCopy];
    }
    
    [detailViewTbl reloadData];
    
    
    /*totalStages=[[NSMutableArray alloc] init];
    NSString * stagesStr = [NSString stringWithFormat:@"select * from Stages_Table where event_id = '%@'",mainId];
    [[DataBaseManager dataBaseManager] execute:stagesStr resultsArray:totalStages];
    
    
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
    
    if (detailArr.count == 0)
    {
        
    }
    else
    {
        eventDetailDict = [detailArr objectAtIndex:0];
        NSString * str1 =[NSString stringWithFormat:@"select * from EventSponsors_Table where event_id = '%@'",mainId];
        
        NSString * str2 =[NSString stringWithFormat:@"select * from EventParticipants_Table where event_id = '%@'",mainId];
        
        
        NSMutableArray * totalspns =[[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:str1 resultsArray:totalspns];
        
        NSMutableArray * totalcmptr =[[NSMutableArray alloc] init];
        [[DataBaseManager dataBaseManager] execute:str2 resultsArray:totalcmptr];
        
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
        
        [eventDetailDict setObject:[NSString stringWithFormat:@"%d",[totalcmptr count]] forKey:@"totalCompetitor"];
        
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
            
            selectedViewLbl.frame = CGRectMake(0, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            genralLbl.textColor = [UIColor yellowColor];
            stagesLbl.textColor = [UIColor whiteColor];
            routMapLbl.textColor = [UIColor whiteColor];
            
        }
        else if (page == 1)
        {
            
            selectedViewLbl.frame = CGRectMake(tapbarView.frame.size.width/3, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            genralLbl.textColor = [UIColor whiteColor];
            stagesLbl.textColor = [UIColor yellowColor];
            routMapLbl.textColor = [UIColor whiteColor];
            
            
            
        }
        else if (page == 2)
        {
            genralLbl.textColor = [UIColor whiteColor];
            routMapLbl.textColor = [UIColor yellowColor];
            stagesLbl.textColor = [UIColor whiteColor];
            selectedViewLbl.frame = CGRectMake(tapbarView.frame.size.width*2/3, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            
        }
    }
    else
    {
        
        {
            CGFloat pageWidth =scrollView.frame.size.width;
            int page1 = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            pageController1.currentPage = page1;
            
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
        return [totalStages count];
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == stageDetailTbl)
    {
        return  40;
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
            return 150;
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
        return 100;
    }
    
    return 50;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailViewTbl)
    {
        return 9;
    }
    else if (tableView == stageDetailTbl)
    {
        return 1;
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == stageDetailTbl)
    {
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, stageDetailTbl.frame.size.width, 50)];
        headerView.backgroundColor=[UIColor whiteColor];
        
        headerView.backgroundColor = [UIColor yellowColor];
        headerView.alpha = 0.6f;
        
        UILabel * stageTitle = [[UILabel alloc]init];
        stageTitle.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 40);
        stageTitle.textColor = [UIColor blackColor];
        stageTitle.backgroundColor = [UIColor clearColor];
        stageTitle.textAlignment = NSTextAlignmentLeft;
        stageTitle.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [headerView addSubview:stageTitle];
        stageTitle.text = [NSString stringWithFormat:@"Stage :%d",(section)+1];
        
        return headerView;
    }
    else
    {
        return NO;
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
    
    if (tableView==detailViewTbl)
    {
        if (indexPath.row==0)
        {
            ExploreCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ReusableCellID"];
            if (cell == nil) {
                cell = [[ExploreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReusableCellID"];
            }
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.scrolImag.frame=CGRectMake(20, 0, 704-90, 240);
            cell.scrolImag.backgroundColor=[UIColor lightGrayColor];
            cell.scrolImag.userInteractionEnabled=YES;
            cell.scrolImag.bounces = NO;
            cell.scrolImag.delegate=self;
            
            
            int x= 0;
            
            for (int i = 0; i<=totalImagesCount; i++)
            {
                
                AsyncImageView * imgProduct;
                imgProduct = [[AsyncImageView alloc] initWithFrame:CGRectMake(x, 0, 704-90, 240)];
                
                
                [imgProduct setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                imgProduct.clipsToBounds=YES;
                imgProduct.userInteractionEnabled=YES;
                imgProduct.contentMode = UIViewContentModeScaleAspectFill;
                [cell.scrolImag addSubview:imgProduct];
                
                if (i==0)
                {
                    
                    NSData * data1=[NSData dataWithBase64EncodedString:[NSString stringWithFormat:@"%@",[[totalImgs objectAtIndex:0] objectForKey:@"event_photo1"]]];
                    [imgProduct setImage:[UIImage imageWithData:data1]];
                    
                }
                else if (i==1)
                {
                    NSData * data1=[NSData dataWithBase64EncodedString:[NSString stringWithFormat:@"%@",[[totalImgs objectAtIndex:0] objectForKey:@"event_photo2"]]];
                    [imgProduct setImage:[UIImage imageWithData:data1]];

                    
                }
                else
                {
                    NSData * data1=[NSData dataWithBase64EncodedString:[NSString stringWithFormat:@"%@",[[totalImgs objectAtIndex:0] objectForKey:@"event_photo3"]]];
                    [imgProduct setImage:[UIImage imageWithData:data1]];

                    
                }
                
                x = x+704-90;
            }
            [pageController1 removeFromSuperview];
            pageController1 = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 220, 704-90, 20)];
            
            pageController1.tintColor = [UIColor blackColor];
            //  pageControl.backgroundColor = [UIColor blackColor];
            pageController1.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageController1.currentPageIndicatorTintColor = [UIColor blackColor];
            [cell.contentView addSubview:pageController1];
            
            pageController1.numberOfPages = totalImagesCount;
            
            [cell.scrolImag setContentSize:CGSizeMake(x, 240)];
            
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
            UIImageView * locationIcon = [[UIImageView alloc]init];
            locationIcon.frame = CGRectMake(20, 10, 23, 30);
            locationIcon.backgroundColor = [UIColor clearColor];
            locationIcon.image = [UIImage imageNamed:@"location.png"];
            [cell.contentView addSubview:locationIcon];
            
            locationLbl = [[UILabel alloc]init];
            locationLbl.backgroundColor = [UIColor clearColor];
            locationLbl.text = @"Aberdeen,UK";
            //            locationLbl.text = [[eventDetailDict valueForKey:@"event"] valueForKey:@"location"];
            locationLbl.text = [eventDetailDict  valueForKey:@"location"];
            
            locationLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
            locationLbl.textColor = [UIColor whiteColor];
            locationLbl.textAlignment = NSTextAlignmentLeft;
            locationLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            
            [cell.contentView addSubview:locationLbl];
            
            
        }
        else if (indexPath.row == 4)
        {
            
            UIImageView * detailIcon = [[UIImageView alloc]init];
            detailIcon.frame = CGRectMake(20, 25, 24, 28);
            detailIcon.backgroundColor = [UIColor clearColor];
            detailIcon.image = [UIImage imageNamed:@"detail.png"];
            [cell.contentView addSubview:detailIcon];
            
            
            txtDetail = [[UITextView alloc]init];
            txtDetail.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 130);
            txtDetail.textAlignment = NSTextAlignmentLeft;
            txtDetail.text = @"Saturday includes classic tests such as Mokkipera and Jukojarvi, while Sunday’s final leg features just two passes over the fast and demanding roads of Myhinpaa.";
            //            txtDetail.text = [[eventDetailDict valueForKey:@"event"] valueForKey:@"race_description"];
            txtDetail.text = [eventDetailDict  valueForKey:@"race_description"];
            
            txtDetail.textColor = [UIColor whiteColor];
            txtDetail.backgroundColor = [UIColor clearColor];
            txtDetail.delegate = self;
            txtDetail.userInteractionEnabled = NO;
            txtDetail.font = [UIFont systemFontOfSize:18.0f];
            txtDetail.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            
            [cell.contentView addSubview:txtDetail];
            
        }
        
        else if (indexPath.row == 5)
        {
            UIImageView * categoryIcon = [[UIImageView alloc]init];
            categoryIcon.frame = CGRectMake(20, 12.05f, 25, 25);
            categoryIcon.backgroundColor = [UIColor clearColor];
            categoryIcon.image = [UIImage imageNamed:@"category.png"];
            [cell.contentView addSubview:categoryIcon];
            
            
            categoryLbl = [[UILabel alloc]init];
            categoryLbl.backgroundColor = [UIColor clearColor];
            categoryLbl.text = @"Bike Race";
            //            categoryLbl.text = [[eventDetailDict valueForKey:@"pt_event_category"] valueForKey:@"event_category_id"];
            categoryLbl.text = [eventDetailDict valueForKey:@"cat_name"];
            
            categoryLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
            categoryLbl.textColor = [UIColor whiteColor];
            categoryLbl.textAlignment = NSTextAlignmentLeft;
            categoryLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            
            [cell.contentView addSubview:categoryLbl];
            
        }
        else if (indexPath.row == 6)
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
        else if (indexPath.row == 7)
        {
            UIImageView * pariticipantIcon = [[UIImageView alloc]init];
            pariticipantIcon.frame = CGRectMake(20, 14, 30, 22);
            pariticipantIcon.backgroundColor = [UIColor clearColor];
            pariticipantIcon.image = [UIImage imageNamed:@"participants.png"];
            [cell.contentView addSubview:pariticipantIcon];
            
            participantLbl = [[UILabel alloc]init];
            participantLbl.backgroundColor = [UIColor clearColor];
            participantLbl.text = @"List of Participants : 9";
            //            participantLbl.text = [NSString stringWithFormat:@"List of Participants : %@",[[eventDetailDict valueForKey:@"0"]valueForKey:@"competitors_count"]];
            
            participantLbl.text = [NSString stringWithFormat:@"List of Participants : %@",[eventDetailDict valueForKey:@"competitors_count"]];
            
            participantLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
            participantLbl.textColor = [UIColor whiteColor];
            participantLbl.textAlignment = NSTextAlignmentLeft;
            participantLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            
            [cell.contentView addSubview:participantLbl];
            
        }
        else if (indexPath.row == 8)
        {
            UIImageView * sponsorsIcon = [[UIImageView alloc]init];
            sponsorsIcon.frame = CGRectMake(20, 12, 32, 24);
            sponsorsIcon.backgroundColor = [UIColor clearColor];
            sponsorsIcon.image = [UIImage imageNamed:@"sponsors_Ipad.png"];
            [cell.contentView addSubview:sponsorsIcon];
            
            sponsorsLbl = [[UILabel alloc]init];
            sponsorsLbl.backgroundColor = [UIColor clearColor];
            sponsorsLbl.text = @"List of Sponsors : 5";
            //            sponsorsLbl.text = [NSString stringWithFormat:@"List of Sponsors : %@",[[eventDetailDict valueForKey:@"0"]valueForKey:@"sponser_count"]];
            
            sponsorsLbl.text = [NSString stringWithFormat:@"List of Sponsors : %@",[eventDetailDict valueForKey:@"sponser_count"]];
            
            sponsorsLbl.frame = CGRectMake(70, 10, detailViewTbl.frame.size.width-70, 30);
            sponsorsLbl.textColor = [UIColor whiteColor];
            sponsorsLbl.textAlignment = NSTextAlignmentLeft;
            sponsorsLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            
            [cell.contentView addSubview:sponsorsLbl];
            
        }
    }
    
    
    else if (tableView==stageDetailTbl)
    {
        
        UILabel *  splitName = [[UILabel alloc]init];
        splitName.frame = CGRectMake(10 ,15,300, 30);
        splitName.text = [[totalStages objectAtIndex:indexPath.section] objectForKey:@"stage_name"];
        splitName.backgroundColor = [UIColor clearColor];
        splitName.textAlignment = NSTextAlignmentCenter;
        splitName.textColor = [UIColor whiteColor];
        [splitName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
        [cell.contentView addSubview:splitName];
        
        UILabel *  chipLbl = [[UILabel alloc]init];
        chipLbl.frame = CGRectMake(320 ,15,300, 30);
        chipLbl.text = [NSString stringWithFormat:@"BLE Chip : %@",[[totalStages objectAtIndex:indexPath.section] objectForKey:@"device_name"]];
        chipLbl.backgroundColor = [UIColor clearColor];
        chipLbl.textAlignment = NSTextAlignmentCenter;
        chipLbl.textColor = [UIColor whiteColor];
        [chipLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
        [cell.contentView addSubview:chipLbl];
        
        UILabel *  startTimeLblstage = [[UILabel alloc]init];
        startTimeLblstage.frame = CGRectMake(10 ,55,300, 30);
        startTimeLblstage.text = [NSString stringWithFormat:@"Start Time : %@",[[totalStages objectAtIndex:indexPath.section] objectForKey:@"start_time"]];
        startTimeLblstage.backgroundColor = [UIColor clearColor];
        startTimeLblstage.textAlignment = NSTextAlignmentCenter;
        startTimeLblstage.textColor = [UIColor whiteColor];
        [startTimeLblstage setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
        
        [cell.contentView addSubview:startTimeLblstage];
        
        UILabel *  PenaltyTimeLbl = [[UILabel alloc]init];
        PenaltyTimeLbl.frame = CGRectMake(320 ,55,300, 30);
        PenaltyTimeLbl.text = [NSString stringWithFormat:@"Total Splits :%@",[[totalStages objectAtIndex:indexPath.section] objectForKey:@"split_count"]];
        PenaltyTimeLbl.backgroundColor = [UIColor clearColor];
        PenaltyTimeLbl.textAlignment = NSTextAlignmentCenter;
        PenaltyTimeLbl.textColor = [UIColor whiteColor];
        [PenaltyTimeLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
        
        [cell.contentView addSubview:PenaltyTimeLbl];
        
        if (indexPath.row %2)
        {
            splitName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
            
            chipLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
            
            startTimeLblstage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
            
            PenaltyTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightfield.png"]];
        }
        else
        {
            splitName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
            
            chipLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
            
            startTimeLblstage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
            
            PenaltyTimeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkfield.png"]];
        }
    }
    
    return cell;
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
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[eventDetailDict  valueForKey:@"event_id"] forKey:@"event_id"];
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"getCompetitorsByEventId";
            manager.delegate = self;
            [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getCompetitorsByEventId" withParameters:dict];
            
            
        }
        else if (indexPath.row == 8)
        {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[eventDetailDict  valueForKey:@"event_id"] forKey:@"event_id"];
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"getSponsersByEventId";
            manager.delegate = self;
            [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getSponsersByEventId" withParameters:dict];
            
        }
    }
    else if (tableView == stageDetailTbl)
    {
        
         NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
         [dict setObject:[[totalStages objectAtIndex:indexPath.row] valueForKey:@"event_stage_id"] forKey:@"stage_id"];
         
         [[NSUserDefaults standardUserDefaults] setObject:[[totalStages objectAtIndex:indexPath.row] valueForKey:@"event_stage_id"] forKey:@"stage_id"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         URLManager *manager = [[URLManager alloc] init];
         manager.commandName = @"getSplitsDetail";
         manager.delegate = self;
         [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getSplitofStages" withParameters:dict];
         
         
         StagesViewController * view = [[StagesViewController alloc]init];
         view.isFromDetail = YES;
         view.eventStageDetailArr = [totalStages objectAtIndex:indexPath.section];
         [self.navigationController pushViewController:view animated:YES];
        
//        StagesViewController * view = [[StagesViewController alloc]init];
//        view.isFromDetail = YES;
//        view.eventStageDetailArr = [totalStages objectAtIndex:indexPath.section];
//        [self.navigationController pushViewController:view animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Route Map Methods
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




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
