//
//  CreateEventViewController.m
//  organizer App
//
//  Created by Romit on 01/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "CreateEventViewController.h"
#import "UIColor+MRColor.h"
#import "ParticipantsViewController.h"
#import "StagesViewController.h"
#import "AddSponsorsView.h"

#import "UICRouteOverlayMapView.h"
#import "UICRouteAnnotation.h"
#import "MyAnnotation.h"
#import "AMark.h"
#import "AMarkView.h"
#import "JSON1.h"
@interface CreateEventViewController ()
{
    NSInteger tags;
    NSInteger previosTag;
    AMarkView *calloutView;
    int page;
}
@end
@implementation CreateEventViewController
@synthesize isFromEdit,editDict,isFromStages,mainId,eventName;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize tableId;


-(void)updatingView
{
    totalStages =[[[NSUserDefaults standardUserDefaults] valueForKey:@"totalStage"]mutableCopy];
    
    NSMutableArray * tempArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * tempDict in totalStages)
    {
        NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
        temp = [tempDict mutableCopy];
        
        [tempArr addObject:temp];
    }
    totalStages = tempArr;
    [stageDetailTbl reloadData];
    
}
- (void)viewDidLoad
{
    isTracking=NO;
    isEventSavedCorrect=YES;
    routeStagesTotal=0;
    routeSplitsTotal=0;
    
    totalStages=[[NSMutableArray alloc] init];//jam
    
    trackpointArray=[[NSMutableArray alloc] init];
    savedLocationLatLong=[[NSMutableArray alloc] init];
    mapSplitsArr=[[NSMutableArray alloc] init];
    mapStagesArr=[[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatingView) name:@"updatingView" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"totalStage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [super viewDidLoad];
    isCollapsed=NO;
    
    selectedSponsorList = [[NSMutableArray alloc]init];
    selectedListArr = [[NSMutableArray alloc]init];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
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
    titleLbl.text = @"Create Event";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 30, 30);;
    backimg.image = [UIImage imageNamed:@"close.png"];
    [navView addSubview:backimg];
    
    
    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 100, 30);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.hidden = YES;
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:backBtn];
    
    
    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(navView.frame.size.width-100, 30, 80, 30);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.tag = 12;
    [saveBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    saveBtn.hidden = YES;
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:saveBtn];
    
    
    if (isFromEdit == YES)
    {
        isEventEditView = YES;
        backimg.hidden = NO;
        
        backBtn.hidden = NO;
        titleLbl.text = eventName;
        saveBtn.hidden = NO;
    }
    else
    {
        isEventEditView = NO;
        backBtn.hidden = YES;
        backimg.hidden = YES;
        saveBtn.hidden = YES;
        
    }
    
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
    // [tapbarView addSubview:generalBtn];
    
    
    stagesTitleLbl = [[UILabel alloc]init];
    stagesTitleLbl.frame = CGRectMake(tapbarView.frame.size.width/3, 10, tapbarView.frame.size.width/3, 30);
    stagesTitleLbl.text = @"Stages & Splits";
    stagesTitleLbl.textColor = [UIColor whiteColor];
    stagesTitleLbl.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    stagesTitleLbl.backgroundColor = [UIColor clearColor];
    stagesTitleLbl.textAlignment = NSTextAlignmentCenter;
    [tapbarView addSubview:stagesTitleLbl];
    
    stageSplitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    stageSplitBtn.frame=CGRectMake(tapbarView.frame.size.width/3, 0, tapbarView.frame.size.width/3, 50);
    [stageSplitBtn addTarget:self action:@selector(stagesSplitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // [tapbarView addSubview:stageSplitBtn];
    
    
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
    //  [tapbarView addSubview:mapBtn];
    
    selectedViewLbl = [[UILabel alloc]init];
    selectedViewLbl.frame = CGRectMake(0, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
    selectedViewLbl.backgroundColor = [UIColor yellowColor];
    [tapbarView addSubview:selectedViewLbl];
    
    
    if (IS_IPAD)
    {
        scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, 704, 768-140)];
        [scrollContent setContentSize:CGSizeMake(scrollContent.frame.size.width*3, 768-140)];
        
    }
    else
    {
    }
    [scrollContent setBackgroundColor:[UIColor clearColor]];
    scrollContent.bounces = NO;
    scrollContent.delegate = self;
    scrollContent.userInteractionEnabled = YES;
    [scrollContent setShowsHorizontalScrollIndicator:NO];
    [scrollContent setShowsVerticalScrollIndicator:NO];
    scrollContent.pagingEnabled = YES;
    scrollContent.scrollEnabled=NO;
    [scrollContent setContentMode:UIViewContentModeScaleAspectFit];
    [scrollContent sizeToFit];
    [self.view addSubview:scrollContent];
    [self.view bringSubviewToFront:scrollContent];
    
    
    NSArray *test1 = [[NSArray alloc]init];
    test1 = @[ @{@"Name": @"18 to 25"},@{@"Name": @"26 to 40"},@{@"Name": @"40 to 60"},@{@"Name": @"60 to 100"},@{@"Name": @"N/A"}];//jam14-07-2015
    
    NSArray *test3 = [[NSArray alloc]init];
    test3 = @[ @{@"Name": @"Wand"},@{@"Name": @"Gun Shot"}];
    
    categoryArr = [[NSMutableArray alloc] init];
    ageCategoryArr = [[NSMutableArray alloc] initWithArray:test1];
    raceTypeArr = [[NSMutableArray alloc] init];
    
    methodArr = [[NSMutableArray alloc] initWithArray:test3];
    totalImages = [[NSMutableArray alloc]init];
    
    NSString * strRace = [NSString stringWithFormat:@"select * from RaceType_Table"];
    [[DataBaseManager dataBaseManager] execute:strRace resultsArray:raceTypeArr];
    
    NSString * strCategory = [NSString stringWithFormat:@"select * from EventCategory_Table"];
    [[DataBaseManager dataBaseManager] execute:strCategory resultsArray:categoryArr];
    
    btnNext=[[UIButton alloc]initWithFrame:CGRectMake(0, 768-50, 704, 50)];
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    btnNext.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnNext.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
    [btnNext addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    [self.view addSubview:btnNext];
    
    
    int xx = 0;
    for (int i = 0; i<3; i++)
    {
        
        if (i==0)
        {
            eventDetailTbl = [[UITableView alloc]init];
            eventDetailTbl.frame = CGRectMake(10, 0, scrollContent.frame.size.width-20, scrollContent.frame.size.height-50);
            eventDetailTbl.backgroundColor = [UIColor clearColor];
            [eventDetailTbl setDelegate:self];
            [eventDetailTbl setDataSource:self];
            [eventDetailTbl setSeparatorColor:[UIColor clearColor]];
            [eventDetailTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            eventDetailTbl.backgroundColor = [UIColor clearColor];
            [scrollContent addSubview:eventDetailTbl];
            
        }
        else if (i == 1)
        {
            stageDetailTbl = [[UITableView alloc]init];
            stageDetailTbl.frame = CGRectMake(scrollContent.frame.size.width+10, 0, scrollContent.frame.size.width-20, scrollContent.frame.size.height-50);
            stageDetailTbl.backgroundColor = [UIColor clearColor];
            [stageDetailTbl setDelegate:self];
            [stageDetailTbl setDataSource:self];
            [stageDetailTbl setSeparatorColor:[UIColor clearColor]];
            [stageDetailTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            stageDetailTbl.backgroundColor = [UIColor clearColor];
            [scrollContent addSubview:stageDetailTbl];
            
        }
        else if (i == 2)
        {
            
        }
        
        xx = xx+scrollContent.frame.size.width;
        scrollContent.contentSize = CGSizeMake(704 * 3, scrollContent.frame.size.height);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtable) name:@"refreshView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSponsorNumber) name:@"refreshSponsor" object:nil];
    
    if (isFromEdit == YES)
    {
        
        backBtn.hidden  = NO;
        eventdetailDict = [[NSMutableDictionary alloc]init];
        
        NSString * strDict = [NSString stringWithFormat:@"select * from GeneralInfo_Table where event_id = '%@'",mainId];
        
        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
        [[DataBaseManager dataBaseManager] execute:strDict resultsArray:tempArr];
        
        eventdetailDict = [[tempArr objectAtIndex:0] mutableCopy];
        
        totalImages = [[NSMutableArray alloc]init];
        NSString * strMessage = [NSString stringWithFormat:@"select * from Images_Table where event_id = '%@'",mainId];
        
        [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:totalImages];
        
        
        NSString * stageStr = [NSString stringWithFormat:@"select * from Stages_Table where event_id = '%@'",mainId];
        
        [[DataBaseManager dataBaseManager] execute:stageStr resultsArray:totalStages];
        
        
        for (int i = 0; i<[totalStages count]; i++)
        {
            NSMutableArray * tempSplitsArr = [[NSMutableArray alloc]init];
            NSString * splitsStr = [NSString stringWithFormat:@"select * from Splits_Table where event_stage_id = '%@'",[[totalStages objectAtIndex:i]valueForKey:@"id"]];
            
            [[DataBaseManager dataBaseManager] execute:splitsStr resultsArray:tempSplitsArr];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            dict = [[totalStages objectAtIndex:i] mutableCopy];
            [dict setObject:tempSplitsArr forKey:@"splits"];
            [totalStages replaceObjectAtIndex:i withObject:dict];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:totalStages forKey:@"totalStage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        isEventSavedCorrect=YES;
        
    }
    else
    {
        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
        NSString  * str = [NSString stringWithFormat:@"select * from Profile_Table"];
        [[DataBaseManager dataBaseManager] execute:str resultsArray:tempArr];
        NSLog(@"Profilearr %@",tempArr);
        
        eventdetailDict = [[NSMutableDictionary alloc]init];
        [eventdetailDict setValue:[[tempArr objectAtIndex:0]valueForKey:@"firstName"] forKey:@"organiser_name"];
        [eventdetailDict setValue:@"required" forKey:@"event_name"];
        [eventdetailDict setValue:@"required" forKey:@"cat_name"];
        [eventdetailDict setValue:@"required" forKey:@"age_category"];
        [eventdetailDict setValue:@"required" forKey:@"location"];
        [eventdetailDict setValue:@"required" forKey:@"event_date"];
        [eventdetailDict setValue:@"required" forKey:@"event_start_date"];
        [eventdetailDict setValue:@"required" forKey:@"manual_start"];
        [eventdetailDict setValue:@"required" forKey:@"event_end_date"];
        [eventdetailDict setValue:@"required" forKey:@"race_description"];
        [eventdetailDict setValue:@"required" forKey:@"competitors_count"];
        [eventdetailDict setValue:@"required" forKey:@"sponser_count"];
        [eventdetailDict setValue:@"required" forKey:@"website_url"];
        [eventdetailDict setValue:@"required" forKey:@"start_method"];
        [eventdetailDict setValue:@"required" forKey:@"race_name"];
        [eventdetailDict setValue:@"required" forKey:@"stages"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteRow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeleteHalfFormToDatabase) name:@"deleteRow" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setPaging" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPaging) name:@"setPaging" object:nil];

    
}
-(void)setPaging
{
    page=1;
}
-(void)viewDidDisappear:(BOOL)animated
{
    if(isFromEdit)
    {
        
    }
    else
    {
        
    }
    [self purgeMapMemory];
    
}
- (void)purgeMapMemory
{
    // Switching map types causes cache purging, so switch to a different map type
    _mapView.mapType = MKMapTypeStandard;
    [_mapView removeFromSuperview];
    _mapView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}
-(void)refreshtable
{
    [eventdetailDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"totalNumber"] forKey:@"competitors_count"];
    [eventDetailTbl reloadData];
}
-(void)refreshSponsorNumber
{
    [eventdetailDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSponsor"] forKey:@"sponser_count"];
    [eventDetailTbl reloadData];
}
#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (scrollView == scrollContent)
    {
        
        if (page == 0)
        {
            selectedViewLbl.frame = CGRectMake(0, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            
            genralLbl.textColor = [UIColor yellowColor];
            stagesTitleLbl.textColor = [UIColor whiteColor];
            routMapLbl.textColor = [UIColor whiteColor];
            btnNext.hidden = NO;
            [btnNext setTitle:@"Next" forState:UIControlStateNormal];
            
            if (isFromEdit)
            {
                backimg.image = [UIImage imageNamed:@"close.png"];
                backimg.frame = CGRectMake(20, 35, 30, 30);
                saveBtn.hidden = NO;
            }
            else
            {
                backBtn.hidden = YES;
                backimg.hidden = YES;
                saveBtn.hidden = YES;
            }
            
            
        }
        else if (page == 1)
        {
            
            selectedViewLbl.frame = CGRectMake(tapbarView.frame.size.width/3, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            genralLbl.textColor = [UIColor whiteColor];
            stagesTitleLbl.textColor = [UIColor yellowColor];
            routMapLbl.textColor = [UIColor whiteColor];
            btnNext.hidden = NO;
            [btnNext setTitle:@"Next" forState:UIControlStateNormal];
            
            if (isFromEdit)
            {
                backimg.image = [UIImage imageNamed:@"back.png"];
                backimg.frame = CGRectMake(20, 35, 12, 22);
                saveBtn.hidden = NO;
            }
            else
            {
                backBtn.hidden = NO;
                backimg.hidden = NO;
                backimg.image = [UIImage imageNamed:@"back.png"];
                backimg.frame = CGRectMake(20, 35, 12, 22);
                saveBtn.hidden = YES;
            }
            
        }
        else if (page == 2)
        {
            genralLbl.textColor = [UIColor whiteColor];
            stagesTitleLbl.textColor = [UIColor whiteColor];
            routMapLbl.textColor = [UIColor yellowColor];
            selectedViewLbl.frame = CGRectMake(tapbarView.frame.size.width*2/3, tapbarView.frame.size.height-10, tapbarView.frame.size.width/3, 2);
            btnNext.hidden = NO;
            [btnNext setTitle:@"Submit" forState:UIControlStateNormal];
            
            if (isFromEdit)
            {
                backimg.image = [UIImage imageNamed:@"back.png"];
                backimg.frame = CGRectMake(20, 35, 12, 22);
            }
            else
            {
                backBtn.hidden = NO;
                backimg.image = [UIImage imageNamed:@"back.png"];
                backimg.frame = CGRectMake(20, 35, 12, 22);
                backimg.hidden = NO;
            }
            saveBtn.hidden = YES;
        }
        
    }
    else
    {
        
    }
    
}

#pragma mark Button Click Event
-(void)backBtnClick:(id)sender
{
    if (page == 0)
    {
        isEventEditView = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (page == 1)
    {
        if ([globalStr isEqualToString:@"Start Method"])
        {
            globalStr = @"";
            [stageDetailTbl reloadData];
        }
        else if ([globalStr isEqualToString:@"Race Type"])
        {
            globalStr = @"";
            [stageDetailTbl reloadData];
        }
        
        else if ([globalStr isEqualToString:@"Category"])
        {
            globalStr = @"";
            NSRange range = NSMakeRange(1, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        }
        else if ([globalStr isEqualToString:@"Age of Category"])
        {
            globalStr = @"";
            NSRange range = NSMakeRange(1, 2);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [scrollContent setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (page == 2)
    {
        if (isTracking)
        {
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Let Tracking a map finish first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            if ([globalStr isEqualToString:@"Start Method"])
            {
                globalStr = @"";
                [stageDetailTbl reloadData];
            }
            else if ([globalStr isEqualToString:@"Race Type"])
            {
                globalStr = @"";
                [stageDetailTbl reloadData];
            }
            
            else if ([globalStr isEqualToString:@"Category"])
            {
                globalStr = @"";
                NSRange range = NSMakeRange(1, 1);
                NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
                [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
            }
            else if ([globalStr isEqualToString:@"Age of Category"])
            {
                globalStr = @"";
                NSRange range = NSMakeRange(1, 2);
                NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
                [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
            }
            
            [scrollContent setContentOffset:CGPointMake(704, 0) animated:YES];
        }
        
        
        
    }
    
}

-(void)submitBtnClick:(id)sender
{
    
    isEventEditView = NO;
    
    if (isFromEdit)
    {
        isEventSavedCorrect=YES;
        
        NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
        [dFrmt setDateFormat:@"dd-MM-yyyy"];
        
        NSArray * tempArr = [[NSArray alloc]init];
        tempArr = [[eventdetailDict valueForKey:@"endDate"] componentsSeparatedByString:@","];
        
        
        if (page==0)
        {
            if ([eventNameLbl.text isEqualToString:@""]|| [[eventdetailDict valueForKey:@"event_name"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter event name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([categoryLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"cat_name"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter event category." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([ageLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"age_category"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter age category." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([locationLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"location"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([eventDateLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"event_date"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter event date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([startTimeLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"event_start_date"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter start time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([endDateTimeLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"event_end_date"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter end date and time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([DescriptionLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"race_description"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter description." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([participantNumerLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@"required"]||[[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@"0"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select participants." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([sponsorNumberLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"sponser_count"] isEqualToString:@"required"]||[[eventdetailDict valueForKey:@"sponser_count"] isEqualToString:@"0"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select sponsors." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([websiteLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"website_url"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter website url." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
           
            else if ([totalImages count]== 0)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please add  atlist one image." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                NSMutableDictionary * mainDict = [[NSMutableDictionary alloc]init];
                [mainDict setObject:[eventdetailDict valueForKey:@"event_name"] forKey:@"event_name"];
                [mainDict setObject:[eventdetailDict valueForKey:@"location"] forKey:@"location"];
                [mainDict setObject:[NSString stringWithFormat:@"%@ %@",[eventdetailDict valueForKey:@"event_date"],[eventdetailDict valueForKey:@"event_start_date"]] forKey:@"start_time"];
                [mainDict setObject:[eventdetailDict valueForKey:@"event_end_date"] forKey:@"end_time"];
                
                [mainDict setObject:[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"] forKey:@"photo"];
                
                [mainDict setObject:[eventdetailDict valueForKey:@"event_date"] forKey:@"event_date"];
                
                [[DataBaseManager dataBaseManager] updateMainTable:mainDict with:mainId];
                
                [[DataBaseManager dataBaseManager] updateGeneralInfo:eventdetailDict with:mainId];
                
                NSString * strDelete = [NSString stringWithFormat:@"Delete from EventSponsors_Table where event_id = '%@'",mainId];
                
                [[DataBaseManager dataBaseManager]execute:strDelete];
                
                NSMutableArray * selectedSponsors = [[NSMutableArray alloc]init];
                selectedSponsors = [[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSponsor"] mutableCopy];
                
                for (int s = 0; s<[selectedSponsors count]; s++)
                {
                    NSMutableDictionary * Dict = [[NSMutableDictionary alloc]init];
                    Dict = [[selectedSponsors objectAtIndex:s] mutableCopy];
                    [Dict setObject:mainId forKey:@"event_id"];
                    
                    [[DataBaseManager dataBaseManager] insertEventSponsorsDetail:Dict];
                }
                
                NSString * DeleteCompititor = [NSString stringWithFormat:@"Delete from EventParticipants_Table where event_id = '%@'",mainId];
                
                [[DataBaseManager dataBaseManager]execute:DeleteCompititor];
                
                
                NSMutableArray * selectedCompititer = [[NSMutableArray alloc]init];
                selectedCompititer = [[[NSUserDefaults standardUserDefaults] valueForKey:@"selected"] mutableCopy];
                
                for (int b = 0; b<[selectedCompititer count]; b++)
                {
                    NSMutableDictionary * Dict = [[NSMutableDictionary alloc]init];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b]valueForKey:@"name"] forKey:@"name"];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"compititorNumber"] forKey:@"compititorNumber"];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"country"] forKey:@"country"];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"verified"] forKey:@"verified"];
                    
                    [Dict setObject:mainId forKey:@"event_id"];
                    
                    [[DataBaseManager dataBaseManager] insertEventParticipantsDetail:Dict];
                }
                
                [scrollContent setContentOffset:CGPointMake(704, 0) animated:YES];
                
            }
        }
        else if (page==1)
        {
            if ([startMethodLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"start_method"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select start method." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([racetypeLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"race_name"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select race type." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
            else if ([totalStages count]==0)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please add  atlist one stage." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                for (int i = 0; i<[totalStages count]; i++)
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    dict =[[totalStages objectAtIndex:i] mutableCopy];
                    
                    [[DataBaseManager dataBaseManager] updateStages:[totalStages objectAtIndex:i] with:[[totalStages objectAtIndex:i] valueForKey:@"id"]];
                    
                    totalSplits =[[NSMutableArray alloc]init];
                    totalSplits= [[totalStages objectAtIndex:i] valueForKey:@"splits"];
                    
                    if (totalSplits.count == 0)
                    {
                        
                    }
                    else
                    {
                        
                        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
                        
                        for (NSDictionary * tempDict in totalSplits)
                        {
                            NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
                            temp = [tempDict mutableCopy];
                            
                            [tempArr addObject:temp];
                        }
                        
                        totalSplits = [tempArr mutableCopy];
                        
                    }
                    
                }
                
                [scrollContent setContentOffset:CGPointMake((704)*2, 0) animated:YES];
                
                //            [_mapView removeFromSuperview];
                _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(scrollContent.frame.size.width*2, 0, 710, 768)];
                _mapView.delegate=self;
                _mapView.mapType=MKMapTypeSatellite;
                [scrollContent addSubview:_mapView];
                _mapView.showsUserLocation=YES;
                
                [self addStagesButtonToMap];
                
                
                // create the overlay
                //            [self loadRoute];
                
                // add the overlay to the map
                if (nil != self.routeLine) {
                    [self.mapView addOverlay:self.routeLine];
                }
                
                // zoom in on the route.
                [self zoomInOnRoute];
                
                
                
                btnNext=[[UIButton alloc]initWithFrame:CGRectMake(0, 768-50, 704, 50)];
                [btnNext setTitle:@"Submit" forState:UIControlStateNormal];
                btnNext.titleLabel.textAlignment=NSTextAlignmentCenter;
                [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btnNext.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
                [btnNext addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btnNext.hidden = YES;
                [btnNext setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
                [self.view addSubview:btnNext];
            }
            
        }
        else
        {
          
            /************************************/
            //For Getting Stages and splits //
            NSMutableArray * annotArr =[[NSMutableArray alloc] init];
            annotArr=[[self.mapView annotations] mutableCopy];
            isEventSavedCorrect=YES;
            for (int k=0;k<[annotArr count];k++)
            {
                AMark * markaView =[[self.mapView annotations] objectAtIndex:k];
                NSLog(@"%@",[markaView title]);
                if ([[markaView title] isEqualToString:@"Current Location"])
                {
                    
                }
                else
                {
                    if ([[markaView type] isEqualToString:@"Stages"])
                    {
                        NSString * strRace = [NSString stringWithFormat:@"update Stages_Table set stage_lat = '%@',stage_lon='%@' where id ='%@'",[markaView latStr],[markaView longStr],[markaView userId]];
                        [[DataBaseManager dataBaseManager] execute:strRace];
                        //
                    }
                    else if([[markaView type] isEqualToString:@"Splits"])
                    {
                        NSString * strRace = [NSString stringWithFormat:@"update Splits_Table set split_lat = '%@',split_lon='%@' where id ='%@'",[markaView latStr],[markaView longStr],[markaView userId]];
                        [[DataBaseManager dataBaseManager] execute:strRace];
                        
                        
                    }
                    else
                    {
                        NSString * strRace = [NSString stringWithFormat:@"update Splits_Table set split_lat = '%@',split_lon='%@' where id ='%@'",[markaView latStr],[markaView longStr],[markaView userId]];
                        [[DataBaseManager dataBaseManager] execute:strRace];
                        
                    }
                    
                }
                
            }
            
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Event has been updated successfully." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            alert.tag=10;
            [alert show];
        }
        
        
        
        
    }
    else
    {
        NSMutableArray * compitiorsSelectedIds = [[NSMutableArray alloc]init];
        NSMutableArray * sponsorsSelectedIds = [[NSMutableArray alloc]init];
        
        if (page == 0)
        {
            
            
            
            if (isFromEdit == YES)
            {
                saveBtn.hidden = NO;
            }
            else
            {
                saveBtn.hidden = YES;
            }
            
            [pickerView removeFromSuperview];
            [txtDescription resignFirstResponder];
            [txtLocation resignFirstResponder];
            [txtWebsite resignFirstResponder];
            [txtname resignFirstResponder];
            
            if ([eventNameLbl.text isEqualToString:@""]|| [[eventdetailDict valueForKey:@"event_name"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter event name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([categoryLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"cat_name"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter event category." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([ageLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"age_category"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter age category." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([locationLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"location"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([eventDateLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"event_date"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter event date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([startTimeLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"event_start_date"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter start time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([endDateTimeLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"event_end_date"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter end date and time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([DescriptionLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"race_description"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter description." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([participantNumerLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@"required"]||[[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@"0"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select participants." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([sponsorNumberLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"sponser_count"] isEqualToString:@"required"]||[[eventdetailDict valueForKey:@"sponser_count"] isEqualToString:@"0"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select sponsors." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([websiteLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"website_url"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter website url." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([totalImages count]== 0)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please add  atlist one image." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (isValidDate)
            {
                isEventSavedCorrect=NO;
                
                
                NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
                [dFrmt setDateFormat:@"dd-MM-yyyy"];
                
                NSArray * tempArr = [[NSArray alloc]init];
                tempArr = [[eventdetailDict valueForKey:@"endDate"] componentsSeparatedByString:@","];
                NSString *endDate = [tempArr objectAtIndex:0];
                NSString * str1 =eventDateLbl.text;
                NSString * str2 =endDate;
                
                NSDate * startD =[dFrmt dateFromString:str1];
                NSDate * endD =[dFrmt dateFromString:str2];
                
                
                if ([startD compare:[NSDate date]] == NSOrderedAscending)
                {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"'Start Date' should not be in the past" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    isValidDate=NO;
                }
                else if ([endD compare:[NSDate date]] == NSOrderedAscending)
                {
                    NSLog(@"date1 is earlier than date2");
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"'End Date' should not be in the past." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    isValidDate=NO;
                    
                }
                
                else if ([startD compare:endD] == NSOrderedDescending)
                {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"'End Date' should not be in the less than Start date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    isValidDate=NO;
                }
                else
                {
                    //kpkpkp
                    
                    NSMutableDictionary * mainDict = [[NSMutableDictionary alloc]init];
                    [mainDict setObject:[eventdetailDict valueForKey:@"event_name"] forKey:@"event_name"];
                    [mainDict setObject:[eventdetailDict valueForKey:@"location"] forKey:@"location"];
                    [mainDict setObject:[NSString stringWithFormat:@"%@ %@",[eventdetailDict valueForKey:@"event_date"],[eventdetailDict valueForKey:@"event_start_date"]] forKey:@"start_time"];
                    [mainDict setObject:[eventdetailDict valueForKey:@"event_end_date"] forKey:@"end_time"];
                    
                    [mainDict setObject:[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"] forKey:@"photo"];
                    
                    [mainDict setObject:[eventdetailDict valueForKey:@"event_date"] forKey:@"event_date"];
                    
                    NSInteger mainid = [[DataBaseManager dataBaseManager] insertMainDetail:mainDict];
                    eventId = [NSString stringWithFormat:@"%d",mainid];
                    [eventdetailDict setValue:eventId forKey:@"event_id"];
                    
                    [[DataBaseManager dataBaseManager] insertGeneralInfoDetail:eventdetailDict];
                    
                    for (int b = 0; b<[totalImages count]; b++)
                    {
                        
                        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                        dict =[[totalImages objectAtIndex:b] mutableCopy];
                        
                        [dict setValue:eventId forKey:@"event_id"];
                        [totalImages replaceObjectAtIndex:b withObject:dict];
                        [[DataBaseManager dataBaseManager] insertImagesDetail:[totalImages objectAtIndex:b]];
                        
                    }
                    
                    [scrollContent setContentOffset:CGPointMake(704, 0) animated:YES];
                }
                
            }
            else
            {
                [scrollContent setContentOffset:CGPointMake(704, 0) animated:YES];
            }
        }
        else if (page == 1)
        {
            isEventSavedCorrect=NO;
            if (isFromEdit == YES)
            {
                saveBtn.hidden = NO;
                backimg.image = [UIImage imageNamed:@"back.png"];
                backimg.frame = CGRectMake(20, 35, 12, 22);
            }
            else
            {
                saveBtn.hidden = YES;
                backBtn.hidden = YES;
                backimg.hidden = YES;
            }
            
            [pickerView removeFromSuperview];
            [txtDescription resignFirstResponder];
            [txtLocation resignFirstResponder];
            [txtWebsite resignFirstResponder];
            [txtname resignFirstResponder];
            
            if ([startMethodLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"start_method"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select start method." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if ([racetypeLbl.text isEqualToString:@""]||[[eventdetailDict valueForKey:@"race_name"] isEqualToString:@"required"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select race type." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
            else if ([totalStages count]==0)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please add  atlist one stage." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                
                NSString * updateStr =[NSString stringWithFormat:@"update GeneralInfo_Table set start_method = '%@' , race_name ='%@'where event_id ='%@'",startMethodLbl.text,racetypeLbl.text,eventId];
                [[DataBaseManager dataBaseManager] execute:updateStr];
                
                NSString * deleteStr =[NSString stringWithFormat:@"delete from Stages_Table where event_id='%@'",eventId];
                [[DataBaseManager dataBaseManager] execute:deleteStr];

                
                
                NSString * stageId ;
                
                for (int i = 0; i<[totalStages count]; i++)
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    dict =[[totalStages objectAtIndex:i] mutableCopy];
                    
                    [dict setValue:eventId forKey:@"event_id"];
                    [totalStages replaceObjectAtIndex:i withObject:dict];
                    
                    NSInteger stage_id = [[DataBaseManager dataBaseManager] insertStagesDetail:[totalStages objectAtIndex:i]];
                    stageId = [NSString stringWithFormat:@"%d",stage_id];
                    
                    totalSplits =[[NSMutableArray alloc]init];
                    totalSplits= [[totalStages objectAtIndex:i] valueForKey:@"splits"];
                    
                    if (totalSplits.count == 0)
                    {
                        
                    }
                    else
                    {
                        
                        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
                        
                        for (NSDictionary * tempDict in totalSplits)
                        {
                            NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
                            temp = [tempDict mutableCopy];
                            
                            [tempArr addObject:temp];
                        }
                        
                        totalSplits = [tempArr mutableCopy];
                        
                        for (int k = 0; k<[totalSplits count]; k++)
                        {
                            NSMutableDictionary * dict1 = [[NSMutableDictionary alloc]init];
                            dict1 =[[totalSplits objectAtIndex:k] mutableCopy];
                            
                            [dict1 setValue:stageId forKey:@"event_stage_id"];
                            [totalSplits replaceObjectAtIndex:k withObject:dict1];
                            
                            [[DataBaseManager dataBaseManager] insertSplitsDetail:[totalSplits objectAtIndex:k]];
                        }
                    }
                    
                }
                
                [scrollContent setContentOffset:CGPointMake(704*2, 0) animated:YES];
                
                {
                    //            [_mapView removeFromSuperview];
                    _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(scrollContent.frame.size.width*2, 0, 710, 768)];
                    _mapView.delegate=self;
                    _mapView.mapType=MKMapTypeSatellite;
                    [scrollContent addSubview:_mapView];
                    _mapView.showsUserLocation=YES;
                    
                    [self addStagesButtonToMap];
                    
                    
                    // create the overlay
                    //            [self loadRoute];
                    
                    // add the overlay to the map
                    if (nil != self.routeLine) {
                        [self.mapView addOverlay:self.routeLine];
                    }
                    
                    // zoom in on the route.
                    [self zoomInOnRoute];
                    
                    
                    
                    btnNext=[[UIButton alloc]initWithFrame:CGRectMake(0, 768-50, 704, 50)];
                    [btnNext setTitle:@"Submit" forState:UIControlStateNormal];
                    btnNext.titleLabel.textAlignment=NSTextAlignmentCenter;
                    [btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btnNext.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:23.0f];
                    [btnNext addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    btnNext.hidden = YES;
                    [btnNext setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
                    [self.view addSubview:btnNext];
                    
                }
            }
        }
        else if (page == 2)
        {
            
            saveBtn.hidden = YES;
            backimg.image = [UIImage imageNamed:@"back.png"];
            backimg.frame = CGRectMake(20, 35, 12, 22);
            
            if (isFromEdit == YES)
            {
                
            }
            else
            {
                
                NSString * start = [NSString stringWithFormat:@"%@",[eventdetailDict valueForKey:@"event_start_date"]];
                
                NSString * endDate = [NSString stringWithFormat:@"%@",[eventdetailDict valueForKey:@"event_end_date"]];
                
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"hh:mm a"];
                
                NSDateFormatter * dfend = [[NSDateFormatter alloc] init];
                [dfend setDateFormat:@"yyyy-MM-dd hh:mm a"];
                
                NSDate *calenderDate = [df dateFromString:start];
                NSDate *calenderEndDste = [dfend dateFromString:endDate];
                
                NSDateFormatter * dd = [[NSDateFormatter alloc]init];
                [dd setDateFormat:@"hh:mm:ss"];
                
                NSDateFormatter * ddEnd = [[NSDateFormatter alloc]init];
                [ddEnd setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                
                NSString * date = [dd stringFromDate:calenderDate];
                NSString * EndDate = [ddEnd stringFromDate:calenderEndDste];
                
                
                NSMutableDictionary * FinalDict = [[NSMutableDictionary alloc]init];
                [FinalDict setValue:[eventdetailDict valueForKey:@"event_name"] forKey:@"event_name"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"event_category_id"] forKey:@"event_category_id"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"age_category"] forKey:@"age_category"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"location"] forKey:@"location"];
                [FinalDict setValue:@"37.337383" forKey:@"lat"];
                
                [FinalDict setValue:@"-122.029736" forKey:@"lon"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"event_date"] forKey:@"event_date"];
                
                [FinalDict setValue:[NSString stringWithFormat:@"%@ %@",[eventdetailDict valueForKey:@"event_date"],date] forKey:@"event_start_date"];
                
                [FinalDict setValue:EndDate forKey:@"event_end_date"];
                [FinalDict setValue:@"OFF" forKey:@"manual_start"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"race_description"] forKey:@"description"];
                
                
                NSMutableArray * selectedSponsors = [[NSMutableArray alloc]init];
                selectedSponsors = [[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSponsor"] mutableCopy];
                
                
                for (int s = 0; s<[selectedSponsors count]; s++)
                {
                    NSMutableDictionary * Dict = [[NSMutableDictionary alloc]init];
                    Dict = [[selectedSponsors objectAtIndex:s] mutableCopy];
                    [Dict setObject:eventId forKey:@"event_id"];
                    
                    [[DataBaseManager dataBaseManager] insertEventSponsorsDetail:Dict];
                    
                    NSMutableDictionary * dictId = [[NSMutableDictionary alloc]init];
                    [dictId setValue:[[selectedSponsors objectAtIndex:s] valueForKey:@"sponser_id"] forKey:@"s_ids"];
                    
                    [sponsorsSelectedIds addObject:dictId];
                }
                
                NSMutableArray * selectedCompititer = [[NSMutableArray alloc]init];
                selectedCompititer = [[[NSUserDefaults standardUserDefaults] valueForKey:@"selected"] mutableCopy];
                
                
                for (int b = 0; b<[selectedCompititer count]; b++)
                {
                    NSMutableDictionary * Dict = [[NSMutableDictionary alloc]init];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b]valueForKey:@"name"] forKey:@"name"];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"compititorNumber"] forKey:@"compititorNumber"];
                    [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"country"] forKey:@"country"];
                     [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"verified"] forKey:@"verified"];
                    
                    if ([[selectedCompititer objectAtIndex:b] valueForKey:@"user_id"] == nil||[[selectedCompititer objectAtIndex:b] valueForKey:@"user_id"]==[NSNull null])
                    {
                        [Dict setObject:@"NA" forKey:@"user_id"];
                    }
                    else
                    {
                        [Dict setObject:[[selectedCompititer objectAtIndex:b] valueForKey:@"user_id"] forKey:@"user_id"];
                    }
                    
                    [Dict setObject:eventId forKey:@"event_id"];
                    
                    [[DataBaseManager dataBaseManager] insertEventParticipantsDetail:Dict];
                    
                    NSMutableDictionary * dictId = [[NSMutableDictionary alloc]init];
                    [dictId setValue:[[selectedCompititer objectAtIndex:b] valueForKey:@"user_id"] forKey:@"c_ids"];
                    
                    [compitiorsSelectedIds addObject:dictId];
                    
                }
                
                NSString *StrComp = [compitiorsSelectedIds JSONRepresentation];
                StrComp = [StrComp stringByReplacingOccurrencesOfString:@"\n"
                                                             withString:@""];
                
                NSString *StrSponsor = [sponsorsSelectedIds JSONRepresentation];
                StrSponsor = [StrSponsor stringByReplacingOccurrencesOfString:@"\n"
                                                                   withString:@""];
                
                
                /************************************/
                //For Getting Stages and splits //
                NSMutableArray * annotArr =[[NSMutableArray alloc] init];
                annotArr=[[self.mapView annotations] mutableCopy];
                isEventSavedCorrect=YES;
                for (int k=0;k<[annotArr count];k++)
                {
                    AMark * markaView =[[self.mapView annotations] objectAtIndex:k];
                    NSLog(@"%@",[markaView title]);
                    if ([[markaView title] isEqualToString:@"Current Location"])
                    {
                        
                    }
                    else
                    {
                        if ([[markaView type] isEqualToString:@"Stages"])
                        {
                            NSString * strRace = [NSString stringWithFormat:@"update Stages_Table set stage_lat = '%@',stage_lon='%@' where id ='%@'",[markaView latStr],[markaView longStr],[markaView userId]];
                            [[DataBaseManager dataBaseManager] execute:strRace];
                            //
                        }
                        else if([[markaView type] isEqualToString:@"Splits"])
                        {
                            NSString * strRace = [NSString stringWithFormat:@"update Splits_Table set split_lat = '%@',split_lon='%@' where id ='%@'",[markaView latStr],[markaView longStr],[markaView userId]];
                            [[DataBaseManager dataBaseManager] execute:strRace];
                            
                            
                        }
                        else
                        {
                            NSString * strRace = [NSString stringWithFormat:@"update Splits_Table set split_lat = '%@',split_lon='%@' where id ='%@'",[markaView latStr],[markaView longStr],[markaView userId]];
                            [[DataBaseManager dataBaseManager] execute:strRace];
                            
                        }
                        
                    }
                    
                }
                /*************************************/
                NSMutableArray * updatedStagesArr =[[NSMutableArray alloc] init];
                NSString * strRace = [NSString stringWithFormat:@"SELECT * FROM Stages_Table where event_id = '%@'",eventId];
                [[DataBaseManager dataBaseManager] execute:strRace resultsArray:updatedStagesArr];
                for (int i=0; i<[updatedStagesArr count]; i++)
                {
                    NSMutableArray * updatedSplitArr=[[NSMutableArray alloc] init];
                    NSString * strRace = [NSString stringWithFormat:@"SELECT * FROM Splits_Table where event_stage_id = '%@'",[[updatedStagesArr objectAtIndex:i] objectForKey:@"id"]];
                    [[DataBaseManager dataBaseManager] execute:strRace resultsArray:updatedSplitArr];
                    if ([updatedSplitArr count]==0)
                    {
                        [[updatedStagesArr objectAtIndex:i] setObject:updatedSplitArr forKey:@"splits"];
                        
                    }
                    else
                    {
                        [[updatedStagesArr objectAtIndex:i] setObject:updatedSplitArr forKey:@"splits"];
                        
                    }
                    
                }
                
                
                
                
                
                
                NSString *StrStages = [updatedStagesArr JSONRepresentation];
                StrStages = [StrStages stringByReplacingOccurrencesOfString:@"\n"
                                                                 withString:@""];
                
                [FinalDict setValue:StrComp forKey:@"competitors"];
                [FinalDict setValue:StrSponsor forKey:@"sponsers"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"website_url"] forKey:@"website"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"start_method"] forKey:@"start_method"];
                [FinalDict setValue:[eventdetailDict valueForKey:@"race_type_id"] forKey:@"race_type_id"];
                [FinalDict setValue:StrStages forKey:@"stages"];
                
                if (totalImages.count == 1)
                {
                    [FinalDict setValue:[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"] forKey:@"photo1"];
                }
                else if (totalImages.count == 2)
                {
                    [FinalDict setValue:[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"] forKey:@"photo1"];
                    
                    [FinalDict setValue:[[totalImages objectAtIndex:1] valueForKey:@"event_photo2"] forKey:@"photo2"];
                }
                else if (totalImages.count == 3)
                {
                    [FinalDict setValue:[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"] forKey:@"photo1"];
                    
                    [FinalDict setValue:[[totalImages objectAtIndex:1] valueForKey:@"event_photo2"] forKey:@"photo2"];
                    
                    [FinalDict setValue:[[totalImages objectAtIndex:2] valueForKey:@"event_photo3"] forKey:@"photo3"];
                }
                
                [FinalDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] forKey:@"user_id"];
                
                //NSLog(@"Final Dict %@",FinalDict);
                
                URLManager *manager = [[URLManager alloc] init];
                manager.commandName = @"createEvent";
                manager.delegate = self;
                [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/eventCreate" withParameters:FinalDict];
                
                
                NSString * deletestr =[NSString stringWithFormat:@"delete from Main_Table where id ='%@'",eventId];

                [[DataBaseManager dataBaseManager] execute:deletestr];
                
                
//                UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Event has been created successfully." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//                alert.tag=10;
//                [alert show];
            }
            
        }
        
    }
    
}
-(void)hudComplited
{
    [app hudEndProcessMethod];
}
-(void)addStagesBtnClick:(id)sender
{
    
    if ([globalStr isEqualToString:@"Start Method"])
    {
        globalStr = @"";
        [stageDetailTbl reloadData];
    }
    else if ([globalStr isEqualToString:@"Race Type"])
    {
        globalStr = @"";
        [stageDetailTbl reloadData];
    }
    
    StagesViewController * view =[[StagesViewController alloc]init];
    
    if (isFromEdit == YES)
    {
        view.eventId = mainId;
        view.isAddstage = YES;
        view.isEditstage = NO;
        view.isFromEdit = YES;
    }
    else
    {
        view.eventId = eventId;
    }
    
    [self.navigationController pushViewController:view animated:YES];
    
}
-(void)dateBtnClick:(id)sender
{
    [pickerView removeFromSuperview];
    [txtname resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtOrganiserName resignFirstResponder];
    
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
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
    
    //    For PickerView
    startDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,50, 320, 250)];
    startDate.datePickerMode=UIDatePickerModeDate;
    startDate.timeZone = [NSTimeZone localTimeZone];
    [pickerView addSubview:startDate];
    
    
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
    
    [btnDone addTarget:self action:@selector(btnDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backTitlt addSubview:btnDone];
    
}
-(void)btnDoneClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTime = [dateFormatter stringFromDate:startDate.date];
    eventDateLbl.text = currentTime;
    [eventdetailDict setValue:currentTime forKey:@"event_date"];
    [pickerView setHidden:YES];
    
}

-(void)startTimeBtnClick:(id)sender
{
    [pickerView removeFromSuperview];
    [txtname resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtOrganiserName resignFirstResponder];
    
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
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
    
    //    For PickerView
    startTime = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,50, 320, 250)];
    startTime.datePickerMode=UIDatePickerModeTime;
    startTime.timeZone = [NSTimeZone localTimeZone];
    [pickerView addSubview:startTime];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Time";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(timeSelectedClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backTitlt addSubview:btnDone];
}
-(void)timeSelectedClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:startTime.date];
    startTimeLbl.text = currentTime;
    [eventdetailDict setValue:currentTime forKey:@"event_start_date"];
    [pickerView setHidden:YES];
    
}
-(void)endDateTimeBtnClick:(id)sender
{
    [pickerView removeFromSuperview];
    [txtname resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtOrganiserName resignFirstResponder];
    
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(192.5, 768, 320, 300)];
    
    [UIView transitionWithView:pickerView
                      duration:0.30
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
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
    endDateTime = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,50, 320, 250)];
    endDateTime.datePickerMode=UIDatePickerModeDateAndTime;
    endDateTime.timeZone = [NSTimeZone localTimeZone];
    [pickerView addSubview:endDateTime];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Date & Time";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(endtimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backTitlt addSubview:btnDone];
}
-(void)endtimeClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:endDateTime.date];
    endDateTimeLbl.text = currentTime;
    [eventdetailDict setValue:currentTime forKey:@"event_end_date"];
    [pickerView setHidden:YES];
    
}
-(void)changeSwitch:(id)sender
{
    
}
-(void)participantsBtnClick:(id)sender
{
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    AddParticipantsView * view = [[AddParticipantsView alloc]init];
    if (isFromEdit)
    {
        view.isFromEdit=YES;
        
    }
    else
    {
        if ([[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@"required"]||[[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@""])
        {
            view.isFromEdit=NO;
        }
        else
        {
            view.isFromEdit=YES;
        }
        
        
    }
    [self.navigationController pushViewController:view animated:YES];
    
}
-(void)addSponsorBtnClick:(id)sender
{
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    AddSponsorsView * spo = [[AddSponsorsView alloc]init];
    
    if (isFromEdit)
    {
        spo.isFromEdit=YES;
    }
    else
    {
        if ([[eventdetailDict valueForKey:@"sponser_count"] isEqualToString:@"required"])
        {
            spo.isFromEdit=NO;
        }
        else
        {
            spo.isFromEdit=YES;
        }
        
    }
    [self.navigationController pushViewController:spo animated:YES];
}
-(void)deleteBtnClick:(id)sender
{
    stageIndex = [sender tag];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete this stage?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 5;
    [alert show];
    
    
}
-(void)addImageBtnClick:(id)sender
{
    [pickerView removeFromSuperview];
    [txtname resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtOrganiserName resignFirstResponder];
    
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    if ([totalImages count]>2)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You can add maximum three images." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        EditProfile1 = NO;
        EditProfile2 = NO;
        EditProfile3 = NO;
        if (self.pop)
        {
            [self.pop dismissPopoverAnimated:YES];
            
        }
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES; //if you want to edit the image
        
        self.pop=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.pop presentPopoverFromRect:CGRectMake(300, 700, 100, 100)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
    
}
-(void)profileImageBtnClick:(id)sender
{
    if (self.pop)
    {
        [self.pop dismissPopoverAnimated:YES];
        
    }
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES; //if you want to edit the image
    
    self.pop=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [self.pop presentPopoverFromRect:CGRectMake(300, 750, 100, 100)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    if ([sender tag]== 1)
    {
        EditProfile1 = YES;
        EditProfile2 = NO;
        EditProfile3 = NO;
    }
    else if ([sender tag]==2)
    {
        EditProfile1 = NO;
        EditProfile2 = YES;
        EditProfile3 = NO;
    }
    else if ([sender tag]==3)
    {
        EditProfile1 = NO;
        EditProfile2 = NO;
        EditProfile3 = YES;
    }
    
}


#pragma mark- Header Button Click Event
-(void)generalBtnClick
{
    
    if (isFromEdit)
    {
        backimg.image = [UIImage imageNamed:@"close.png"];
        backimg.frame = CGRectMake(20, 35, 30, 30);
        saveBtn.hidden = NO;
    }
    else
    {
        backimg.hidden = YES;
        backBtn.hidden = YES;
        saveBtn.hidden = YES;
    }
    [scrollContent setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)stagesSplitBtnClick
{
    [pickerView removeFromSuperview];
    [txtDescription resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtname resignFirstResponder];
    [txtOrganiserName resignFirstResponder];
    
    if (isFromEdit)
    {
        saveBtn.hidden = NO;
    }
    else
    {
        backimg.image = [UIImage imageNamed:@"back.png"];
        backimg.frame = CGRectMake(20, 35, 12, 22);
        backimg.hidden = YES;
        backBtn.hidden = NO;
        saveBtn.hidden = NO;
    }
    [scrollContent setContentOffset:CGPointMake(704, 0) animated:YES];
    
}
-(void)mapBtnClick
{
    
    saveBtn.hidden = YES;
    
    if (isFromEdit)
    {
        backimg.image = [UIImage imageNamed:@"back.png"];
        backimg.frame = CGRectMake(20, 35, 12, 22);
    }
    else
    {
        backimg.image = [UIImage imageNamed:@"back.png"];
        backimg.frame = CGRectMake(20, 35, 12, 22);
        backimg.hidden = YES;
        backBtn.hidden = NO;
        saveBtn.hidden = NO;
    }
    [scrollContent setContentOffset:CGPointMake(704*2, 0) animated:YES];
}
#pragma mark - Image Picker  delegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSData *data = UIImagePNGRepresentation(image);
    NSString *encodedString = [data base64Encoding];
    
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    
    
    if (EditProfile1 == YES)
    {
        NSMutableDictionary * dict1 = [[NSMutableDictionary alloc]init];
        
        dict1 =[[totalImages objectAtIndex:0] mutableCopy];
        [dict1 setObject:encodedString forKey:@"event_photo1"];
        [dict1 setValue:mainId forKey:@"event_id"];
        
        [totalImages replaceObjectAtIndex:0 withObject:dict1];
        [eventDetailTbl reloadData];
        
        
        NSString * strID =[NSString stringWithFormat:@"%@",[[totalImages objectAtIndex:0] valueForKey:@"id"]]  ;
        
        [[DataBaseManager dataBaseManager] updateImages:[totalImages objectAtIndex:0] with:strID];
        
    }
    else if (EditProfile2 == YES)
    {
        NSMutableDictionary * dict1 = [[NSMutableDictionary alloc]init];
        
        dict1 =[[totalImages objectAtIndex:1] mutableCopy];
        [dict1 setObject:encodedString forKey:@"event_photo2"];
        [dict1 setValue:mainId forKey:@"event_id"];
        
        [totalImages replaceObjectAtIndex:1 withObject:dict1];
        [eventDetailTbl reloadData];
        
        
        NSString * strID =[NSString stringWithFormat:@"%@",[[totalImages objectAtIndex:1] valueForKey:@"id"]]  ;
        
        [[DataBaseManager dataBaseManager] updateImages:[totalImages objectAtIndex:1] with:strID];
    }
    else if (EditProfile3 == YES)
    {
        
        NSMutableDictionary * dict1 = [[NSMutableDictionary alloc]init];
        dict1 =[[totalImages objectAtIndex:2] mutableCopy];
        [dict1 setObject:encodedString forKey:@"event_photo3"];
        [dict1 setValue:mainId forKey:@"event_id"];
        
        [totalImages replaceObjectAtIndex:2 withObject:dict1];
        [eventDetailTbl reloadData];
        
        NSString * strID =[NSString stringWithFormat:@"%@",[[totalImages objectAtIndex:2] valueForKey:@"id"]];
        
        [[DataBaseManager dataBaseManager] updateImages:[totalImages objectAtIndex:2] with:strID];
        
    }
    else
    {
        if (isFromEdit == YES)
        {
            if (totalImages.count == 1)
            {
                [dict setValue:mainId forKey:@"event_id"];
                [dict setObject:encodedString forKey:@"event_photo2"];
                [totalImages addObject:dict];
                [[DataBaseManager dataBaseManager] insertImagesDetail:dict];
            }
            else if (totalImages.count == 2)
            {
                [dict setValue:mainId forKey:@"event_id"];
                [dict setObject:encodedString forKey:@"event_photo3"];
                [totalImages addObject:dict];
                [[DataBaseManager dataBaseManager] insertImagesDetail:dict];
            }
        }
        else
        {
            
            if (totalImages.count == 1)
            {
                [dict setObject:encodedString forKey:@"event_photo2"];
                [totalImages addObject:dict];
            }
            else if (totalImages.count == 2)
            {
                [dict setObject:encodedString forKey:@"event_photo3"];
                [totalImages addObject:dict];
            }
            else
            {
                [dict setObject:encodedString forKey:@"event_photo1"];
                [totalImages addObject:dict];
                
            }
        }
        
        [eventDetailTbl reloadData];
    }
    
    [self.pop dismissPopoverAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    [app hudEndProcessMethod];
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"createEvent"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[[result valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"event"] mutableCopy];
            
            
            NSString * strMain = [NSString stringWithFormat:@"UPDATE Main_Table set event_id = '%@' where id = '%@'",[tempArr valueForKey:@"id"],mainId];
            
            [[DataBaseManager dataBaseManager] execute:strMain];
            
            NSString * strcompititor = [NSString stringWithFormat:@"UPDATE EventParticipants_Table set event_id = '%@' where id = '%@'",[tempArr valueForKey:@"id"],mainId];
            
            [[DataBaseManager dataBaseManager] execute:strcompititor];
            
            NSString * strSponsor = [NSString stringWithFormat:@"UPDATE EventSponsors_Table set event_id = '%@' where id = '%@'",[tempArr valueForKey:@"id"],mainId];
            
            [[DataBaseManager dataBaseManager] execute:strSponsor];
            
            
            NSString * strInfo = [NSString stringWithFormat:@"UPDATE GeneralInfo_Table set event_id = '%@' where id = '%@'",[tempArr valueForKey:@"id"],mainId];
            
            [[DataBaseManager dataBaseManager] execute:strInfo];
            
            NSString * strImages = [NSString stringWithFormat:@"UPDATE Images_Table set event_id = '%@' where id = '%@'",[tempArr valueForKey:@"id"],mainId];
            
            [[DataBaseManager dataBaseManager] execute:strImages];
            
            NSString * strStages = [NSString stringWithFormat:@"UPDATE Stages_Table set event_id = '%@' where id = '%@'",[tempArr valueForKey:@"id"],mainId];
            
            [[DataBaseManager dataBaseManager] execute:strStages];
            
            
            
            
            for (int ik=0; ik<[trackpointArray count]; ik++)
            {
                
                CLLocation * location =[trackpointArray objectAtIndex:ik];
                CLLocationCoordinate2D coorrdinate2 = location.coordinate;
                
                NSString * strRace = [NSString stringWithFormat:@"insert into 'Map_Table'('event_id','name','lat','long') values('%@','name','%f','%f')",eventId,coorrdinate2.latitude,coorrdinate2.longitude];
                [[DataBaseManager dataBaseManager] execute:strRace];
                
//                [[trackpointArray objectAtIndex:ik] setObject:[tempArr valueForKey:@"id"] forKey:@"event_id"];
                
//                [[trackpointArray objectAtIndex:ik] setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] forKey:@"event_id"];

                
//                [[trackpointArray objectAtIndex:ik] setObject:[[trackpointArray objectAtIndex:ik] objectForKey:@"long"] forKey:@"lon"];

//                user_id
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUpcomingEventList" object:nil];

            
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Event Created Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag = 10;
            
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please check the details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
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
#pragma mark TableView Methods
#pragma mark - UITableViewDatasource
#pragma mark Tableview Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == eventDetailTbl)
    {
        return 14;
    }
    else if (tableView == stageDetailTbl)
    {
        return 3+[totalStages count];
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == eventDetailTbl)
    {
        if (section == 9)
        {
            return 150;
        }
    }
    else if (tableView == stageDetailTbl)
    {
        if (section==0 ||section == 1 || section == 2)
        {
            return 50;
            
        }
        else
        {
            return  40;
        }
        
        
    }
    
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==stageDetailTbl)
    {
        if (indexPath.section==0 || indexPath.section == 1 || indexPath.section == 2)
        {
            return 50;
            
        }
        else
        {
            return 100;
        }
        
    }
    else if (tableView == eventDetailTbl)
    {
        if (indexPath.section == 13)
        {
            return 100;
        }
        else
        {
            return 50;
        }
        
        
    }
    return 50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == eventDetailTbl)
    {
        if (section == 2)
        {
            if ([globalStr isEqualToString:@"Category"])
            {
                return categoryArr.count;
            }
            else
            {
                return 0;
            }
        }
        else if (section == 3)
        {
            if ([globalStr isEqualToString:@"Age of Category"])
            {
                return ageCategoryArr.count;
            }
            else
            {
                return 0;
            }
        }
        else if (section == 13)
        {
            if ([totalImages count]==0)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
        
    }
    else if (tableView == stageDetailTbl)
    {
        if (section == 0)
        {
            if ([globalStr isEqualToString:@"Start Method"])
            {
                return methodArr.count;
            }
            else
            {
                return 0;
            }
        }
        else if (section == 1)
        {
            if ([globalStr isEqualToString:@"Race Type"])
            {
                return raceTypeArr.count;
            }
            else
            {
                return 0;
            }
        }
        else if (section==2)
        {
            
            // return [totalStages count];
        }
        else
        {
            return 1;
        }
        
    }
    
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, eventDetailTbl.frame.size.width, 50)];
    headerView.backgroundColor=[UIColor whiteColor];
    
    if (section %2)
    {
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellLine1.png"]];
    }
    else
    {
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellLine2.png"]];
    }
    
    if (tableView == eventDetailTbl)
    {
        if (section == 0)
        {
            txtOrganiserName = [[UITextField alloc]init];
            txtOrganiserName.frame = CGRectMake(10, 5, headerView.frame.size.width-20, 40);
            txtOrganiserName.textColor = [UIColor whiteColor];
            txtOrganiserName.backgroundColor = [UIColor clearColor];
            txtOrganiserName.placeholder = @"Event Organiser Name";
            txtOrganiserName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [txtOrganiserName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            txtOrganiserName.delegate = self;
            txtOrganiserName.returnKeyType=UIReturnKeyNext;
            txtOrganiserName.userInteractionEnabled = NO;//jam14-07-2015.
            [headerView addSubview:txtOrganiserName];
            
            
            organiserNameLbl = [[UILabel alloc]init];
            organiserNameLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            organiserNameLbl.backgroundColor = [UIColor clearColor];
            organiserNameLbl.textColor = [UIColor yellowColor];
            organiserNameLbl.textAlignment = NSTextAlignmentRight;
            organiserNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [headerView addSubview:organiserNameLbl];
            
            
            if ([[eventdetailDict valueForKey:@"organiser_name"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                organiserNameLbl.text = [eventdetailDict valueForKey:@"organiser_name"];
            }
            
        }
        else if (section == 1)
        {
            txtname = [[UITextField alloc]init];
            txtname.frame = CGRectMake(10, 5, headerView.frame.size.width-20, 40);
            txtname.textColor = [UIColor whiteColor];
            txtname.backgroundColor = [UIColor clearColor];
            txtname.placeholder = @"Enter Event Name";
            txtname.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [txtname setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            txtname.delegate = self;
            txtname.returnKeyType=UIReturnKeyNext;
            [headerView addSubview:txtname];
            
            
            eventNameLbl = [[UILabel alloc]init];
            eventNameLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            eventNameLbl.backgroundColor = [UIColor clearColor];
            eventNameLbl.textColor = [UIColor yellowColor];
            eventNameLbl.textAlignment = NSTextAlignmentRight;
            eventNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [headerView addSubview:eventNameLbl];
            
            
            if ([[eventdetailDict valueForKey:@"event_name"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                eventNameLbl.text = [eventdetailDict valueForKey:@"event_name"];
            }
        }
        else if (section == 2)
        {
            
            UIButton * selectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame=CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            selectBtn.tag=section;
            [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [selectBtn setTitle:@"Event Category" forState:UIControlStateNormal];
            [selectBtn addTarget:self action:@selector(tableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            selectBtn.backgroundColor=[UIColor clearColor];
            selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            selectBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:selectBtn];
            
            categoryLbl = [[UILabel alloc]init];
            categoryLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            categoryLbl.backgroundColor = [UIColor clearColor];
            categoryLbl.textColor = [UIColor yellowColor];
            categoryLbl.textAlignment = NSTextAlignmentRight;
            categoryLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            
            [headerView addSubview:categoryLbl];
            
            if ([[eventdetailDict valueForKey:@"cat_name"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                categoryLbl.text = [eventdetailDict valueForKey:@"cat_name"];
            }
            
        }
        else if (section == 3)
        {
            
            UIButton * selectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame=CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            selectBtn.tag=section;
            [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [selectBtn setTitle:@"Age of Category" forState:UIControlStateNormal];
            [selectBtn addTarget:self action:@selector(tableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            selectBtn.backgroundColor=[UIColor clearColor];
            selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            selectBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:selectBtn];
            
            ageLbl = [[UILabel alloc]init];
            ageLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            ageLbl.backgroundColor = [UIColor clearColor];
            ageLbl.textColor = [UIColor yellowColor];
            ageLbl.textAlignment = NSTextAlignmentRight;
            ageLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:ageLbl];
            
            if ([[eventdetailDict valueForKey:@"age_category"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                ageLbl.text = [eventdetailDict valueForKey:@"age_category"];
            }
            
        }
        else if (section == 4)
        {
            txtLocation = [[UITextField alloc]init];
            txtLocation.frame = CGRectMake(10, 5, headerView.frame.size.width-20, 40);
            txtLocation.textColor = [UIColor whiteColor];
            txtLocation.backgroundColor = [UIColor clearColor];
            txtLocation.delegate = self;
            txtLocation.placeholder = @"Enter Location";
            txtLocation.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            txtLocation.returnKeyType=UIReturnKeyNext;
            
            [txtLocation setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [headerView addSubview:txtLocation];
            
            locationLbl = [[UILabel alloc]init];
            locationLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            locationLbl.backgroundColor = [UIColor clearColor];
            locationLbl.textColor = [UIColor yellowColor];
            locationLbl.textAlignment = NSTextAlignmentRight;
            locationLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:locationLbl];
            
            if ([[eventdetailDict valueForKey:@"location"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                locationLbl.text = [eventdetailDict valueForKey:@"location"];
            }
            
        }
        else if (section == 5)
        {
            selectDateBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            selectDateBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            selectDateBtn.backgroundColor = [UIColor clearColor];
            [selectDateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [selectDateBtn setTitle:@"Date of Event" forState:UIControlStateNormal];
            [selectDateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            selectDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            selectDateBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:selectDateBtn];
            
            eventDateLbl = [[UILabel alloc]init];
            eventDateLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            eventDateLbl.backgroundColor = [UIColor clearColor];
            eventDateLbl.textColor = [UIColor yellowColor];
            eventDateLbl.textAlignment = NSTextAlignmentRight;
            eventDateLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:eventDateLbl];
            
            if ([[eventdetailDict valueForKey:@"event_date"] isEqualToString:@"required"])
            {
                isValidDate = NO;
            }
            else
            {
                eventDateLbl.text = [eventdetailDict valueForKey:@"event_date"];
                isValidDate = YES;
            }
            
        }
        else if (section == 6)
        {
            startTimeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            startTimeBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            startTimeBtn.backgroundColor = [UIColor clearColor];
            [startTimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [startTimeBtn setTitle:@"Event Start Time" forState:UIControlStateNormal];
            [startTimeBtn addTarget:self action:@selector(startTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            startTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            startTimeBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:startTimeBtn];
            
            
            startTimeLbl = [[UILabel alloc]init];
            startTimeLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            startTimeLbl.backgroundColor = [UIColor clearColor];
            startTimeLbl.textColor = [UIColor yellowColor];
            startTimeLbl.textAlignment = NSTextAlignmentRight;
            startTimeLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:startTimeLbl];
            
            if ([[eventdetailDict valueForKey:@"event_start_date"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                startTimeLbl.text = [eventdetailDict valueForKey:@"event_start_date"];
            }
            
        }
        else if (section == 7)
        {
            manualStartLbl = [[UILabel alloc]init];
            manualStartLbl.frame = CGRectMake(10, 10, headerView.frame.size.width-20, 30);
            manualStartLbl.backgroundColor = [UIColor clearColor];
            manualStartLbl.textColor = [UIColor lightGrayColor];
            manualStartLbl.text = @"Manual Start";
            manualStartLbl.textAlignment = NSTextAlignmentLeft;
            manualStartLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:manualStartLbl];
            
            manualSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(headerView.frame.size.width-60, 10, 30, 15)];
            [manualSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            manualSwitch.tag=section;
            [headerView addSubview:manualSwitch];
            
        }
        else if (section == 8)
        {
            endDateTimeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            endDateTimeBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            endDateTimeBtn.backgroundColor = [UIColor clearColor];
            [endDateTimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [endDateTimeBtn setTitle:@"Estimated End Date and Time" forState:UIControlStateNormal];
            [endDateTimeBtn addTarget:self action:@selector(endDateTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            endDateTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            endDateTimeBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:endDateTimeBtn];
            
            
            endDateTimeLbl = [[UILabel alloc]init];
            endDateTimeLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            endDateTimeLbl.backgroundColor = [UIColor clearColor];
            endDateTimeLbl.textColor = [UIColor yellowColor];
            endDateTimeLbl.textAlignment = NSTextAlignmentRight;
            endDateTimeLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:endDateTimeLbl];
            
            if ([[eventdetailDict valueForKey:@"event_end_date"] isEqualToString:@"required"])
            {
                isValidDate = NO;
            }
            else
            {
                endDateTimeLbl.text = [eventdetailDict valueForKey:@"event_end_date"];
                isValidDate = YES;
            }
            
            
        }
        else if (section == 9)
        {
            txtDescription = [[UITextView alloc]init];
            
            
            // BY RAJU 9-7-2015
            txtDescription.frame = CGRectMake(05, 0, headerView.frame.size.width-10, 140);
            txtDescription.textColor = [UIColor lightGrayColor];
            txtDescription.backgroundColor = [UIColor clearColor];
            txtDescription.delegate = self;
            txtDescription.text = @"Enter Description";
            txtDescription.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            
            
            [headerView addSubview:txtDescription];
            
            
            DescriptionLbl = [[UILabel alloc]init];
            DescriptionLbl.frame = CGRectMake(headerView.frame.size.width/2, 10, headerView.frame.size.width/2-10, 140);
            DescriptionLbl.backgroundColor = [UIColor clearColor];
            DescriptionLbl.textColor = [UIColor yellowColor];
            DescriptionLbl.textAlignment = NSTextAlignmentRight;
            DescriptionLbl.numberOfLines = 0;
            DescriptionLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:DescriptionLbl];
            
            if ([[eventdetailDict valueForKey:@"race_description"] isEqualToString:@"required"])
            {
                DescriptionLbl.text = @"";
            }
            else
            {
                DescriptionLbl.text = [eventdetailDict valueForKey:@"race_description"];
            }
        }
        else if (section == 10)
        {
            participantsBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            participantsBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            participantsBtn.backgroundColor = [UIColor clearColor];
            [participantsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [participantsBtn setTitle:@"List of Participants" forState:UIControlStateNormal];
            [participantsBtn addTarget:self action:@selector(participantsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            participantsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            participantsBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:participantsBtn];
            
            participantNumerLbl = [[UILabel alloc]init];
            participantNumerLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            participantNumerLbl.backgroundColor = [UIColor clearColor];
            participantNumerLbl.textColor = [UIColor yellowColor];
            participantNumerLbl.textAlignment = NSTextAlignmentRight;
            participantNumerLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:participantNumerLbl];
            
            if ([[eventdetailDict valueForKey:@"competitors_count"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                participantNumerLbl.text = [eventdetailDict valueForKey:@"competitors_count"];
            }
            
            
            
            
        }
        else if (section == 11)
        {
            sponsorsBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            sponsorsBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            sponsorsBtn.backgroundColor = [UIColor clearColor];
            [sponsorsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [sponsorsBtn setTitle:@"Add Sponsors" forState:UIControlStateNormal];
            [sponsorsBtn addTarget:self action:@selector(addSponsorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            sponsorsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            sponsorsBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:sponsorsBtn];
            
            sponsorNumberLbl = [[UILabel alloc]init];
            sponsorNumberLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            sponsorNumberLbl.backgroundColor = [UIColor clearColor];
            sponsorNumberLbl.textColor = [UIColor yellowColor];
            sponsorNumberLbl.textAlignment = NSTextAlignmentRight;
            sponsorNumberLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:sponsorNumberLbl];
            
            if ([[eventdetailDict valueForKey:@"sponser_count"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                sponsorNumberLbl.text = [eventdetailDict valueForKey:@"sponser_count"];
            }
            
            
            
        }
        else if (section == 12)
        {
            
            txtWebsite = [[UITextField alloc]init];
            txtWebsite.frame = CGRectMake(10, 5, headerView.frame.size.width-20, 40);
            txtWebsite.textColor = [UIColor whiteColor];
            txtWebsite.backgroundColor = [UIColor clearColor];
            txtWebsite.delegate = self;
            txtWebsite.placeholder = @"Enter Website URL";
            txtWebsite.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [txtWebsite setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [headerView addSubview:txtWebsite];
            txtWebsite.returnKeyType=UIReturnKeyNext;
            
            websiteLbl = [[UILabel alloc]init];
            websiteLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            websiteLbl.backgroundColor = [UIColor clearColor];
            websiteLbl.textColor = [UIColor yellowColor];
            websiteLbl.textAlignment = NSTextAlignmentRight;
            websiteLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:websiteLbl];
            
            if ([[eventdetailDict valueForKey:@"website_url"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                websiteLbl.text = [eventdetailDict valueForKey:@"website_url"];
            }
            
        }
        else if (section == 13)
        {
            
            UIImageView * addImg =[[UIImageView alloc] init];
            addImg.frame=CGRectMake(140, 9, 32, 32);
            addImg.image=[UIImage imageNamed:@"create_Ipad"];
            [headerView addSubview:addImg];
            
            
            addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addImageBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            addImageBtn.backgroundColor = [UIColor clearColor];
            [addImageBtn setTitle:@"Add Images" forState:UIControlStateNormal];
            [addImageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [addImageBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            addImageBtn.titleLabel.frame  = CGRectMake(50, 05, 200, 30);
            addImageBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            addImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            addImageBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:addImageBtn];
            
        }
        
        
    }
    else if (tableView == stageDetailTbl)
    {
        if (section == 0)
        {
            UIButton * methodBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            methodBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            methodBtn.backgroundColor = [UIColor clearColor];
            [methodBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [methodBtn setTitle:@"Start Method" forState:UIControlStateNormal];
            [methodBtn addTarget:self action:@selector(stagetableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            methodBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            methodBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            methodBtn.tag = section;
            [headerView addSubview:methodBtn];
            
            startMethodLbl = [[UILabel alloc]init];
            startMethodLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            startMethodLbl.backgroundColor = [UIColor clearColor];
            startMethodLbl.textColor = [UIColor yellowColor];
            startMethodLbl.textAlignment = NSTextAlignmentRight;
            startMethodLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:startMethodLbl];
            
            
            if ([[eventdetailDict valueForKey:@"start_method"] isEqualToString:@"required"])
            {
            }
            else
            {
                startMethodLbl.text = [eventdetailDict valueForKey:@"start_method"];
            }
            
            
        }
        else if (section == 1)
        {
            UIButton * raceTypeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            raceTypeBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            raceTypeBtn.backgroundColor = [UIColor clearColor];
            [raceTypeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [raceTypeBtn setTitle:@"Race Type" forState:UIControlStateNormal];
            [raceTypeBtn addTarget:self action:@selector(stagetableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            raceTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            raceTypeBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            raceTypeBtn.tag = section;
            [headerView addSubview:raceTypeBtn];
            
            racetypeLbl = [[UILabel alloc]init];
            racetypeLbl.frame = CGRectMake(headerView.frame.size.width/2+10, 10, headerView.frame.size.width/2-20, 30);
            racetypeLbl.backgroundColor = [UIColor clearColor];
            racetypeLbl.textColor = [UIColor yellowColor];
            racetypeLbl.textAlignment = NSTextAlignmentRight;
            racetypeLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
            [headerView addSubview:racetypeLbl];
            
            if ([[eventdetailDict valueForKey:@"race_name"] isEqualToString:@"required"])
            {
                
            }
            else
            {
                racetypeLbl.text = [eventdetailDict valueForKey:@"race_name"];
            }
            
        }
        else if (section == 2)
        {
            UIImageView * addImg =[[UIImageView alloc] init];
            addImg.frame=CGRectMake(140, 9, 32, 32);
            addImg.image=[UIImage imageNamed:@"create_Ipad"];
            [headerView addSubview:addImg];
            
            
            addStagesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addStagesBtn.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 50);
            addStagesBtn.backgroundColor = [UIColor clearColor];
            [addStagesBtn setTitle:@"Add Stage" forState:UIControlStateNormal];
            [addStagesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [addStagesBtn addTarget:self action:@selector(addStagesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            addStagesBtn.titleLabel.frame  = CGRectMake(50, 05, 200, 30);
            addStagesBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            addStagesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
            addStagesBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:addStagesBtn];
        }
        else
        {
            headerView.backgroundColor = [UIColor yellowColor];
            headerView.alpha = 0.6f;
            
            UILabel * stageTitle = [[UILabel alloc]init];
            stageTitle.frame = CGRectMake(10, 0, headerView.frame.size.width-20, 40);
            stageTitle.textColor = [UIColor blackColor];
            stageTitle.backgroundColor = [UIColor clearColor];
            stageTitle.textAlignment = NSTextAlignmentLeft;
            stageTitle.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            [headerView addSubview:stageTitle];
            stageTitle.text = [NSString stringWithFormat:@"Stage :%d",(section-3)+1];
            
            
        }
    }
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section>0) return YES;
    
    return NO;
}
#pragma mark - Header Button Click event
-(void)tableButtonClick:(id)sender
{
    
    [pickerView removeFromSuperview];
    [txtname resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtOrganiserName resignFirstResponder];
    
    if ([sender tag]==2)
    {
        
        if ([globalStr isEqualToString:@"Category"])
        {
            globalStr = @"";
        }
        else
        {
            globalStr = @"Category";
        }
    }
    else if ([sender tag]==3)
    {
        
        if ([globalStr isEqualToString:@"Age of Category"])
        {
            globalStr = @"";
        }
        else
        {
            globalStr = @"Age of Category";
        }
        
    }
    
    [eventDetailTbl reloadData];
    
}
-(void)stagetableButtonClick:(id)sender
{
    if ([sender tag]==0)
    {
        if ([globalStr isEqualToString:@"Start Method"])
        {
            globalStr = @"";
        }
        else
        {
            globalStr = @"Start Method";
        }
    }
    else if ([sender tag]==1)
    {
        if ([globalStr isEqualToString:@"Race Type"])
        {
            globalStr = @"";
        }
        else
        {
            globalStr = @"Race Type";
        }
    }
    
    [stageDetailTbl reloadData];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == stageDetailTbl)
    {
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2)
        {
            
            cell.backgroundColor = [UIColor colorWithRed:210.0f/255.0f green:198.0f/255.0f blue:0.0f/255.0f alpha:1];
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
    else
    {
        if (indexPath.section == 13)
        {
            cell.backgroundColor = [UIColor blackColor];
        }
        else
        {
            cell.backgroundColor = [UIColor colorWithRed:210.0f/255.0f green:198.0f/255.0f blue:0.0f/255.0f alpha:1];
        }
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *test = nil;
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:test];
    
    if( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:test];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (tableView == eventDetailTbl)
    {
        if (indexPath.section == 2)
        {
            cell.textLabel.text = [[categoryArr objectAtIndex:indexPath.row] valueForKey:@"cat_name"];
            cell.textLabel.textColor = [UIColor blackColor];
            UILabel * line = [[UILabel alloc]init];
            line.backgroundColor = [UIColor blackColor];
            line.frame = CGRectMake(0, 49, eventDetailTbl.frame.size.width, 1);
            [cell.contentView addSubview:line];
            
        }
        else if (indexPath.section == 3)
        {
            cell.textLabel.text = [[ageCategoryArr objectAtIndex:indexPath.row] valueForKey:@"Name"];
            cell.textLabel.textColor = [UIColor blackColor];
            UILabel * line = [[UILabel alloc]init];
            line.backgroundColor = [UIColor blackColor];
            line.frame = CGRectMake(0, 49, eventDetailTbl.frame.size.width, 1);
            [cell.contentView addSubview:line];
            
        }
        else if (indexPath.section == 13)
        {
            
            profileImg1 = [[UIImageView alloc]init];
            profileImg1.frame = CGRectMake(10, 10, 80, 80);
            profileImg1.backgroundColor = [UIColor clearColor];
            profileImg1.layer.cornerRadius = 40;
            profileImg1.layer.masksToBounds = YES;
            profileImg1.contentMode=UIViewContentModeScaleAspectFill;
            
            [cell.contentView addSubview:profileImg1];
            
            profileBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            profileBtn1.frame =CGRectMake(10, 10, 80, 80);
            profileBtn1.backgroundColor = [UIColor clearColor];
            [profileBtn1 addTarget:self action:@selector(profileImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            profileBtn1.tag = 1;
            [cell.contentView addSubview:profileBtn1];
            
            profileImg2 = [[UIImageView alloc]init];
            profileImg2.frame = CGRectMake(110, 10, 80, 80);
            profileImg2.backgroundColor = [UIColor clearColor];
            profileImg2.layer.cornerRadius = 40;
            profileImg2.layer.masksToBounds = YES;
            profileImg2.contentMode=UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:profileImg2];
            
            profileBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            profileBtn2.frame =CGRectMake(110, 10, 80, 80);
            profileBtn2.backgroundColor = [UIColor clearColor];
            [profileBtn2 addTarget:self action:@selector(profileImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            profileBtn2.tag = 2;
            [cell.contentView addSubview:profileBtn2];
            
            
            profileImg3 = [[UIImageView alloc]init];
            profileImg3.frame = CGRectMake(210, 10, 80, 80);
            profileImg3.backgroundColor = [UIColor clearColor];
            profileImg3.layer.cornerRadius = 40;
            profileImg3.layer.masksToBounds = YES;
            profileImg3.contentMode=UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:profileImg3];
            
            profileBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            profileBtn3.frame =CGRectMake(200, 10, 80, 80);
            profileBtn3.backgroundColor = [UIColor clearColor];
            [profileBtn3 addTarget:self action:@selector(profileImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            profileBtn3.tag = 3;
            [cell.contentView addSubview:profileBtn3];
            
            if ([totalImages count]==0)
            {
                profileBtn1.hidden = YES;
                profileBtn2.hidden = YES;
                profileBtn3.hidden = YES;
                profileImg1.hidden = YES;
                profileImg2.hidden = YES;
                profileImg3.hidden = YES;
            }
            else if ([totalImages count]==1)
            {
                profileBtn1.hidden = NO;
                profileBtn2.hidden = YES;
                profileBtn3.hidden = YES;
                profileImg1.hidden = NO;
                profileImg2.hidden = YES;
                profileImg3.hidden = YES;
                
                NSString * imgData =[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"];
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                profileImg1.image=[UIImage imageWithData:data];
                
            }
            else if ([totalImages count] == 2)
            {
                profileBtn1.hidden = NO;
                profileBtn2.hidden = NO;
                profileBtn3.hidden = YES;
                profileImg1.hidden = NO;
                profileImg2.hidden = NO;
                profileImg3.hidden = YES;
                
                NSString *imgData =[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"];
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                profileImg1.image=[UIImage imageWithData:data];
                
                NSString * imgData1 =[[totalImages objectAtIndex:1] valueForKey:@"event_photo2"];
                
                NSData *data1 = [[NSData alloc]initWithBase64EncodedString:imgData1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                profileImg2.image=[UIImage imageWithData:data1];
                
                
            }
            else if ([totalImages count]==3)
            {
                profileBtn1.hidden = NO;
                profileBtn2.hidden = NO;
                profileBtn3.hidden = NO;
                profileImg1.hidden = NO;
                profileImg2.hidden = NO;
                profileImg3.hidden = NO;
                NSString * imgData =[[totalImages objectAtIndex:0] valueForKey:@"event_photo1"];
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters];
                profileImg1.image=[UIImage imageWithData:data];
                
                NSString * imgData1 =[[totalImages objectAtIndex:1] valueForKey:@"event_photo2"];
                
                NSData *data1 = [[NSData alloc]initWithBase64EncodedString:imgData1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                profileImg2.image=[UIImage imageWithData:data1];
                
                NSString * imgData2 =[[totalImages objectAtIndex:2] valueForKey:@"event_photo3"];
                
                NSData *data2 = [[NSData alloc]initWithBase64EncodedString:imgData2 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                profileImg3.image=[UIImage imageWithData:data2];
                
                
                
            }
            
            
            
        }
        
    }
    else if (tableView == stageDetailTbl)
    {
        if (indexPath.section == 0)
        {
            cell.textLabel.text =[[methodArr objectAtIndex:indexPath.row] valueForKey:@"Name"];
            cell.textLabel.textColor = [UIColor blackColor];
            UILabel * line = [[UILabel alloc]init];
            line.backgroundColor = [UIColor blackColor];
            line.frame = CGRectMake(0, 49, stageDetailTbl.frame.size.width, 1);
            [cell.contentView addSubview:line];
            
        }
        else if (indexPath.section == 1)
        {
            cell.textLabel.text = [[raceTypeArr objectAtIndex:indexPath.row] valueForKey:@"race_name"];
            cell.textLabel.textColor = [UIColor blackColor];
            UILabel * line = [[UILabel alloc]init];
            line.backgroundColor = [UIColor blackColor];
            line.frame = CGRectMake(0, 49, stageDetailTbl.frame.size.width, 1);
            [cell.contentView addSubview:line];
            
        }
        else if (indexPath.section == 2)
        {
            
        }
        else
        {
            
            UILabel *  splitName = [[UILabel alloc]init];
            splitName.frame = CGRectMake(10 ,15,300, 30);
            splitName.text = [[totalStages objectAtIndex:indexPath.section-3] objectForKey:@"stage_name"];
            splitName.backgroundColor = [UIColor clearColor];
            splitName.textAlignment = NSTextAlignmentCenter;
            splitName.textColor = [UIColor whiteColor];
            [splitName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            [cell.contentView addSubview:splitName];
            
            UILabel *  chipLbl = [[UILabel alloc]init];
            chipLbl.frame = CGRectMake(320 ,15,300, 30);
            chipLbl.text = [NSString stringWithFormat:@"BLE Chip : %@",[[totalStages objectAtIndex:indexPath.section-3] objectForKey:@"device_name"]];
            chipLbl.backgroundColor = [UIColor clearColor];
            chipLbl.textAlignment = NSTextAlignmentCenter;
            chipLbl.textColor = [UIColor whiteColor];
            [chipLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            [cell.contentView addSubview:chipLbl];
            
            UILabel *  startTimeLblstage = [[UILabel alloc]init];
            startTimeLblstage.frame = CGRectMake(10 ,55,300, 30);
            startTimeLblstage.text = [NSString stringWithFormat:@"Start Time : %@",[[totalStages objectAtIndex:indexPath.section-3] objectForKey:@"start_time"]];
            startTimeLblstage.backgroundColor = [UIColor clearColor];
            startTimeLblstage.textAlignment = NSTextAlignmentCenter;
            startTimeLblstage.textColor = [UIColor whiteColor];
            [startTimeLblstage setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            
            [cell.contentView addSubview:startTimeLblstage];
            
            UILabel *  PenaltyTimeLbl = [[UILabel alloc]init];
            PenaltyTimeLbl.frame = CGRectMake(320 ,55,300, 30);
            PenaltyTimeLbl.text = [NSString stringWithFormat:@"Total Splits :%lu",(unsigned long)[[[totalStages objectAtIndex:indexPath.section-3] valueForKey:@"splits"]count]];
            PenaltyTimeLbl.backgroundColor = [UIColor clearColor];
            PenaltyTimeLbl.textAlignment = NSTextAlignmentCenter;
            PenaltyTimeLbl.textColor = [UIColor whiteColor];
            [PenaltyTimeLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
            
            [cell.contentView addSubview:PenaltyTimeLbl];
            
            UIButton * deleteBtn = [[UIButton alloc]init];
            deleteBtn.frame = CGRectMake(stageDetailTbl.frame.size.width-50, 35, 30, 30);
            [deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
            deleteBtn.backgroundColor = [UIColor clearColor];
            deleteBtn.tag = indexPath.section-3;
            [cell.contentView addSubview:deleteBtn];
            
            
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
        
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == eventDetailTbl)
    {
        if (indexPath.section == 2)
        {
            if ([globalStr isEqualToString:@"Event Category"])
            {
                globalStr = @"";
            }
            else
            {
                globalStr = @"Event Category";
            }
            
            
            [eventdetailDict setValue:[[categoryArr objectAtIndex:indexPath.row] valueForKey:@"cat_name"] forKey:@"cat_name"];
            
            [eventdetailDict setValue:[[categoryArr objectAtIndex:indexPath.row] valueForKey:@"event_cat_id"]  forKey:@"event_category_id"];
        }
        else if (indexPath.section == 3)
        {
            
            if ([globalStr isEqualToString:@"Age of Category"])
            {
                globalStr = @"";
            }
            else
            {
                globalStr = @"Age of Category";
            }
            
            [eventdetailDict setValue:[[ageCategoryArr objectAtIndex:indexPath.row] valueForKey:@"Name"] forKey:@"age_category"];
            
        }
        
    }
    else if (tableView == stageDetailTbl)
    {
        if (indexPath.section == 0)
        {
            
            if ([globalStr isEqualToString:@"Start Method"])
            {
                globalStr = @"";
            }
            else
            {
                globalStr = @"Start Method";
            }
            
            [eventdetailDict setValue:[[methodArr objectAtIndex:indexPath.row] valueForKey:@"Name"] forKey:@"start_method"];
            
        }
        else if (indexPath.section == 1)
        {
            if ([globalStr isEqualToString:@"Race Type"])
            {
                globalStr = @"";
            }
            else
            {
                globalStr = @"Race Type";
            }
            
            [eventdetailDict setValue:[[raceTypeArr objectAtIndex:indexPath.row] valueForKey:@"race_name"] forKey:@"race_name"];
            
            [eventdetailDict setValue:[[raceTypeArr objectAtIndex:indexPath.row] valueForKey:@"race_type_id"] forKey:@"race_type_id"];
        }
        else if (indexPath.section == 2)
        {
        }
        else
        {
            StagesViewController * view  = [[StagesViewController alloc]init];
            view.isFromEdit=YES;
            view.selectedIndex = indexPath.section-3;
            view.isEditstage = YES;
            view.stageDetailArr =[totalStages objectAtIndex:indexPath.section-3];
            [self.navigationController pushViewController:view animated:YES];
            
        }
        
    }
    
    [eventDetailTbl reloadData];
    [stageDetailTbl reloadData];
}
#pragma mark - TextView & TextField delegate methods
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [pickerView removeFromSuperview];
    
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    if (textView == txtDescription )
    {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:2];
        [eventDetailTbl scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        if ([DescriptionLbl.text isEqualToString:@""])
        {
            txtDescription.text=@"";
        }
        else
        {
            txtDescription.text=[eventdetailDict valueForKey:@"race_description"];
        }
        DescriptionLbl.hidden = YES;
        
        CGRect frame = [eventDetailTbl frame]; //assuming tableViewer is your tableview
        frame.origin.y -= 300; //200 may be a bit off, should be height of keyboard
        [eventDetailTbl setFrame:frame];
        
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    [pickerView removeFromSuperview];
    DescriptionLbl.hidden = YES;
    //    txtDescription.text =textView.text;
    //    [eventdetailDict setValue:textView.text forKey:@"description"];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    if (textView == txtDescription)
    {
        CGRect frame = [eventDetailTbl frame]; //assuming tableViewer is your tableview
        frame.origin.y = 0; //200 may be a bit off, should be height of keyboard
        [eventDetailTbl setFrame:frame];
        
        DescriptionLbl.hidden = NO;
        [eventdetailDict setValue:textView.text forKey:@"race_description"];
        [eventDetailTbl reloadData];
        
    }
    
}
- (void) textViewDidChange:(UITextView *)textView
{
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [pickerView removeFromSuperview];
    
    if ([globalStr isEqualToString:@"Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([globalStr isEqualToString:@"Age of Category"])
    {
        globalStr = @"";
        NSRange range = NSMakeRange(1, 2);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [eventDetailTbl reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (textField == txtname)
    {
        eventNameLbl.hidden = YES;
        txtname.text = eventNameLbl.text;
        [eventdetailDict setValue:textField.text forKey:@"event_name"];
        
    }
    else if (textField == txtOrganiserName)
    {
        organiserNameLbl.hidden = YES;
        txtOrganiserName.text = organiserNameLbl.text;
        [eventdetailDict setValue:textField.text forKey:@"organiser_name"];
    }
    else if (textField == txtLocation)
    {
        locationLbl.hidden = YES;
        txtLocation.text = locationLbl.text;
        [eventdetailDict setValue:textField.text forKey:@"location"];
    }
    else if (textField == txtWebsite)
    {
        CGRect frame = [eventDetailTbl frame]; //assuming tableViewer is your tableview
        frame.origin.y =-400; //200 may be a bit off, should be height of keyboard
        [eventDetailTbl setFrame:frame];
        
        websiteLbl.hidden = YES;
        txtWebsite.text = websiteLbl.text;
        [eventdetailDict setValue:textField.text forKey:@"website_url"];
        
    }
    else
    {
        
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txtname)
    {
        eventNameLbl.hidden = NO;
        eventNameLbl.text = textField.text;
        [eventdetailDict setValue:eventNameLbl.text forKey:@"event_name"];
        txtname.text = @"";
    }
    else if (textField == txtOrganiserName)
    {
        organiserNameLbl.hidden = NO;
        organiserNameLbl.text = textField.text;
        [eventdetailDict setValue:organiserNameLbl.text forKey:@"organiser_name"];
        txtOrganiserName.text = @"";
    }
    
    else if (textField == txtLocation)
    {
        locationLbl.hidden = NO;
        locationLbl.text = textField.text;
        [eventdetailDict setValue:locationLbl.text forKey:@"location"];
        txtLocation.text = @"";
    }
    
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == txtWebsite)
    {
        CGRect frame = [eventDetailTbl frame]; //assuming tableViewer is your tableview
        frame.origin.y =0; //200 may be a bit off, should be height of keyboard
        [eventDetailTbl setFrame:frame];
        
        [txtWebsite resignFirstResponder];
        websiteLbl.hidden = NO;
        websiteLbl.text = textField.text;
        
        [eventdetailDict setValue:websiteLbl.text forKey:@"website_url"];
        txtWebsite.text = @"";
        [eventDetailTbl reloadData];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtname)
    {
        eventNameLbl.hidden = NO;
        eventNameLbl.text = textField.text;
        [eventdetailDict setValue:textField.text forKey:@"event_name"];
    }
    else if (textField == txtOrganiserName)
    {
        organiserNameLbl.hidden = NO;
        organiserNameLbl.text = textField.text;
        [eventdetailDict setValue:textField.text forKey:@"organiser_name"];
    }
    else if (textField == txtLocation)
    {
        locationLbl.hidden = NO;
        locationLbl.text = textField.text;
        [eventdetailDict setValue:textField.text forKey:@"location"];
    }
    else if (textField == txtWebsite)
    {
        websiteLbl.hidden = NO;
        websiteLbl.text = textField.text;
        [eventdetailDict setValue:textField.text forKey:@"website_url"];
    }
    [textField resignFirstResponder];
    [eventDetailTbl reloadData];
    return YES;
}


#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"moveToUpcomingEvent" object:nil];
        }
        else
        {
            
        }
    }
    else if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            NSString * strDelete = [NSString stringWithFormat:@"Delete from Stages_Table where id = '%@'",[[totalStages objectAtIndex:stageIndex] valueForKey:@"id"]];
            
            [[DataBaseManager dataBaseManager]execute:strDelete];
            
            NSString * splitDelete = [NSString stringWithFormat:@"Delete from Splits_Table where event_stage_id = '%@'",[[totalStages objectAtIndex:stageIndex] valueForKey:@"id"]];
            
            [[DataBaseManager dataBaseManager]execute:splitDelete];
            
            [totalStages removeObjectAtIndex:stageIndex];
            
            [[NSUserDefaults standardUserDefaults] setObject:totalStages forKey:@"totalStage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [stageDetailTbl reloadData];
        }
        else
        {
            
        }
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Route Map Methods

-(void)addStagesButtonToMap
{
    if (isFromEdit)
    {
        routeMapArr=[[NSMutableArray alloc] init];
        NSString * sqlQueryStr = [NSString stringWithFormat:@"select * from Map_Table where event_id ='%@'",mainId];
        [[DataBaseManager dataBaseManager] execute:sqlQueryStr resultsArray:routeMapArr];
        
        [self loadRoute];
    }
    
    startTrackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    startTrackBtn.frame=CGRectMake(160+33, 10, 150, 50);
    [startTrackBtn addTarget:self action:@selector(StartTracking) forControlEvents:UIControlEventTouchUpInside];
    [startTrackBtn setTitle:@"Start Tracking" forState:UIControlStateNormal];
    [startTrackBtn setBackgroundColor:[UIColor yellowColor]];
    //    startTrackBtn.layer.cornerRadius=12;
    startTrackBtn.layer.borderWidth=2.0;
    //    startTrackBtn.layer.borderColor=[UIColor blackColor].CGColor;
    [startTrackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mapView addSubview:startTrackBtn];
    
    startTrackBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    startTrackBtn.layer.shadowOpacity = 0.4f;
    startTrackBtn.layer.shadowOffset = CGSizeMake(0, 2);
    
    stopTrackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    stopTrackBtn.frame=CGRectMake(160+33+150+10+10, 10, 150, 50);
    [stopTrackBtn addTarget:self action:@selector(StopTracking) forControlEvents:UIControlEventTouchUpInside];
    [stopTrackBtn setTitle:@"Stop Tracking" forState:UIControlStateNormal];
    [stopTrackBtn setBackgroundColor:[UIColor yellowColor]];
    stopTrackBtn.layer.borderWidth=2.0;
    //    stopTrackBtn.layer.borderColor=[UIColor blackColor].CGColor;
    [stopTrackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mapView addSubview:stopTrackBtn];
    stopTrackBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    stopTrackBtn.layer.shadowOpacity = 0.4f;
    stopTrackBtn.layer.shadowOffset = CGSizeMake(0, 2);
    
    if (isFromEdit)
    {
        if ([routeMapArr count]==0)
        {
            startTrackBtn.hidden=NO;
            stopTrackBtn.hidden=NO;

        }
        else
        {
            startTrackBtn.hidden=YES;
            stopTrackBtn.hidden=YES;

        }
        
    }
    
    
    stopTrackBtn.enabled=NO;
    
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
    
    mapStagesArr=[[NSMutableArray alloc] init];
    NSString * strRace = [NSString stringWithFormat:@"SELECT * FROM Stages_Table where event_id = '%@'",eventId];
    if (isFromEdit)
    {
        strRace = [NSString stringWithFormat:@"SELECT * FROM Stages_Table where event_id = '%@'",mainId];
    }
    else
    {
        strRace = [NSString stringWithFormat:@"SELECT * FROM Stages_Table where event_id = '%@'",eventId];
    }
    [[DataBaseManager dataBaseManager] execute:strRace resultsArray:mapStagesArr];
    n = mapStagesArr.count;
    
    
    
    
    
    
    /*
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
            [stagesBtn addTarget:self action:@selector(StagePinDropFromStages:) forControlEvents:UIControlEventTouchUpInside];
            stagesBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            stagesBtn.layer.shadowOpacity = 0.4f;
            stagesBtn.layer.shadowOffset = CGSizeMake(0, 2);
            
            
            if ([[mapStagesArr objectAtIndex:i] valueForKey:@"stage_name"] != [NSNull null])
            {
                NSArray * arrName = [[[mapStagesArr objectAtIndex:i] valueForKey:@"stage_name"] componentsSeparatedByString:@" "];
                if ([arrName count]>0)
                {
                    [stagesBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
                }
            }
            
            if ([[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_lat"] isEqualToString:@"Lat"])
            {
                stagesBtn.enabled=YES;
                stagesBtn.alpha=1.0;
            }
            else
            {
                stagesBtn.enabled=NO;
                stagesBtn.alpha=0.5;
                
                
                if (isFromEdit)
                {
                    NSString * latStr =[NSString stringWithFormat:@"%@",[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_lat"]];
                    
                    NSString * longStr =[NSString stringWithFormat:@"%@",[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_lon"]];
                    
                    NSString * stageName;
                    if ([[mapStagesArr objectAtIndex:i] objectForKey:@"stage_name"])
                    {
                        stageName=[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_name"];
                    }
                    else
                    {
                        stageName=[NSString stringWithFormat:@"Stage %d",i+1];
                    }
                    
                    CLLocationCoordinate2D lc =CLLocationCoordinate2DMake([latStr floatValue], [longStr floatValue]);
                    AMark *mark1 =[[AMark alloc] initWithCoordinate:lc title:stageName lat:latStr long:longStr type:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:[[mapStagesArr objectAtIndex:i] objectForKey:@"id"]];
                    
                    
                    mark1.title=stageName;
                    [self.mapView addAnnotation:mark1];
                    [self.mapView selectAnnotation:mark1 animated:YES];
                }
                
                
            }
            
            [self.mapView addSubview:stagesBtn];
            i++;
            
            
            i1 = i1+1;
            
            
            
        }
        
    }
    */
    while(i<n)
    {
        int y1 = i1*50;
        
        if (i>11)
        {
            NSLog(@"ooooooooo =%d",i);
            break;
        }
        else
        {
//            int j=0;
            for(int j=0; j<1;j++)
            {
                if (j==1)
                {
                    break;
                }
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
                [stagesBtn addTarget:self action:@selector(StagePinDropFromStages:) forControlEvents:UIControlEventTouchUpInside];
                stagesBtn.layer.shadowColor = [UIColor blackColor].CGColor;
                stagesBtn.layer.shadowOpacity = 0.4f;
                stagesBtn.layer.shadowOffset = CGSizeMake(0, 2);
                
                
                if ([[mapStagesArr objectAtIndex:i] valueForKey:@"stage_name"] != [NSNull null])
                {
                    NSArray * arrName = [[[mapStagesArr objectAtIndex:i] valueForKey:@"stage_name"] componentsSeparatedByString:@" "];
                    if ([arrName count]>0)
                    {
                        [stagesBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
                    }
                }
                
                if ([[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_lat"] isEqualToString:@"Lat"])
                {
                    stagesBtn.enabled=YES;
                    stagesBtn.alpha=1.0;
                }
                else
                {
                    stagesBtn.enabled=NO;
                    stagesBtn.alpha=0.5;
                    
                    
                    if (isFromEdit)
                    {
                        NSString * latStr =[NSString stringWithFormat:@"%@",[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_lat"]];
                        
                        NSString * longStr =[NSString stringWithFormat:@"%@",[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_lon"]];
                        
                        NSString * stageName;
                        if ([[mapStagesArr objectAtIndex:i] objectForKey:@"stage_name"])
                        {
                            stageName=[[mapStagesArr objectAtIndex:i] objectForKey:@"stage_name"];
                        }
                        else
                        {
                            stageName=[NSString stringWithFormat:@"Stage %d",i+1];
                        }
                        
                        CLLocationCoordinate2D lc =CLLocationCoordinate2DMake([latStr floatValue], [longStr floatValue]);
                        AMark *mark1 =[[AMark alloc] initWithCoordinate:lc title:stageName lat:latStr long:longStr type:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:[[mapStagesArr objectAtIndex:i] objectForKey:@"id"]];
                        
                        
                        mark1.title=stageName;
                        [self.mapView addAnnotation:mark1];
                        [self.mapView selectAnnotation:mark1 animated:YES];
                    }
                    
                    
                }
                
                [self.mapView addSubview:stagesBtn];
                i++;
                
                
                
                
                
            }
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
    
    mapSplitsArr=[[NSMutableArray alloc] init];
    
    int i=0,i1=0;
    NSInteger n;
    for (int k=0; k<[mapStagesArr count]; k++)
    {
        NSMutableArray * mySplitsArr =[[NSMutableArray alloc] init];
        
        NSString * strRace = [NSString stringWithFormat:@"SELECT * FROM Splits_Table where event_stage_id = '%@'",[[mapStagesArr objectAtIndex:k] objectForKey:@"id"]];
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
            [stagesBtn addTarget:self action:@selector(SplitsPinDropFromStages:) forControlEvents:UIControlEventTouchUpInside];
            stagesBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            stagesBtn.layer.shadowOpacity = 0.4f;
            stagesBtn.layer.shadowOffset = CGSizeMake(0, 2);
            
            
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
                
                
                if (isFromEdit)
                {
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
                
            }
            
            
            [self.mapView addSubview:stagesBtn];
            i++;
            i1 = i1+1;
            
        }
        
    }
    
    
}

-(void)StagePinDropFromStages:(id)sender
{
    if (isTracking)
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Let Tracking a map finish first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIButton *button = sender;
        button.enabled=NO;
        button.alpha=0.5;
        NSString * latStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].latitude];
        
        NSString * longStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].longitude];
        
        NSString * stageName;
        if ([[mapStagesArr objectAtIndex:[sender tag]] objectForKey:@"stage_name"])
        {
            stageName=[[mapStagesArr objectAtIndex:[sender tag]] objectForKey:@"stage_name"];
        }
        else
        {
            stageName=[NSString stringWithFormat:@"Stage %d",[sender tag]+1];
        }
        AMark *mark1 =[[AMark alloc] initWithCoordinate:[self.mapView centerCoordinate] title:stageName lat:latStr long:longStr type:@"Stages" withSesstionToken:@"" andSessionId:@"" withUserId:[[mapStagesArr objectAtIndex:[sender tag]] objectForKey:@"id"]];
        
        
        mark1.title=stageName;
        [self.mapView addAnnotation:mark1];
        [self.mapView selectAnnotation:mark1 animated:YES];
    }
   
    
}

-(void)SplitsPinDropFromStages:(id)sender
{
    if (isTracking)
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Message" message:@"Let Tracking a map finish first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIButton *button = sender;
        button.enabled=NO;
        button.alpha=0.5;
        NSString * latStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].latitude];
        
        NSString * longStr =[NSString stringWithFormat:@"%f",[self.mapView centerCoordinate].longitude];
        
        NSString * stageName;
        if ([[mapSplitsArr objectAtIndex:[sender tag]] objectForKey:@"stage_name"])
        {
            stageName=[[mapSplitsArr objectAtIndex:[sender tag]] objectForKey:@"split_name"];
        }
        else
        {
            stageName=[NSString stringWithFormat:@"Split %d",[sender tag]+1];
        }
        AMark *mark1 =[[AMark alloc] initWithCoordinate:[self.mapView centerCoordinate] title:stageName lat:latStr long:longStr type:@"Splits" withSesstionToken:@"" andSessionId:@"" withUserId:[[mapSplitsArr objectAtIndex:[sender tag]] objectForKey:@"id"]];
        
        
        mark1.title=stageName;
        [self.mapView addAnnotation:mark1];
        [self.mapView selectAnnotation:mark1 animated:YES];
    }
    
    
}
-(void)StartTracking
{
    isTracking=YES;
    stopTrackBtn.enabled=YES;
    startTrackBtn.enabled=NO;
    
    /*-----------Start Location Manager----------*/
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    /*-------------------------------------------*/
}

-(void)StopTracking
{
    isTracking=NO;

    stopTrackBtn.enabled=NO;
    startTrackBtn.enabled=YES;
    
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
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
    
    AMark *mark1 =[[AMark alloc] initWithCoordinate:[self.mapView centerCoordinate] title:@"Start Point" lat:latStr long:longStr type:@"Splits" withSesstionToken:@"" andSessionId:@"" withUserId:@""];
    
    
    mark1.title=[NSString stringWithFormat:@"Split %d",routeSplitsTotal];
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

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView * polyLineView =[[MKPolylineView alloc] initWithPolyline:overlay];
    polyLineView.strokeColor=[UIColor yellowColor];
    polyLineView.lineWidth=8.0;
    polyLineView.lineCap=10;
    
    return polyLineView;
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
        pinView.draggable=YES;
        
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
        //        [_mapView.userLocation setTitle:@"I am here"];
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
        
        [(AMark*)[view annotation] setLatStr:[NSString stringWithFormat:@"%f",droppedAt.latitude]];
        
        [(AMark*)[view annotation] setLongStr:[NSString stringWithFormat:@"%f",droppedAt.longitude]];

        
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

#pragma mark - Manually Draw a line
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"Magnetic Haeding is %f",newHeading.magneticHeading);
    NSLog(@"True Haeding is %f",newHeading.trueHeading);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //  NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        appLatitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        appLongitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    }
    //    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //get the latest location
    
    CLLocation * currentLocation = [locations lastObject];
    
    if (currentLocation != nil)
    {
        appLatitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        appLongitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    }
    
    //Store latest location in stored track array
    [trackpointArray addObject:currentLocation];
    
    savedLatLndDict=[[NSMutableDictionary alloc] init];
    [savedLatLndDict setObject:appLatitude forKey:@"latS"];
    [savedLatLndDict setObject:appLongitude forKey:@"lngS"];
    [savedLocationLatLong addObject:savedLatLndDict];
    
    //    NSLog(@"kkkkkkkkkk%@",savedLatLndDict);
    
    //get latest location coordinates
    
    CLLocationDegrees Latitude = currentLocation.coordinate.latitude;
    CLLocationDegrees Longitude = currentLocation.coordinate.longitude;
    CLLocationCoordinate2D locationCoordinates  = CLLocationCoordinate2DMake(Latitude, Longitude);
    
    //get heading information
    //    NSLog(@"direction is %.0f",direction);
    
    //zoom map to show user location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationCoordinates, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    NSInteger numberOfSteps = trackpointArray.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    
    for (NSInteger index =0; index < numberOfSteps; index++)
    {
        CLLocation * location =[trackpointArray objectAtIndex:index];
        CLLocationCoordinate2D coorrdinate2 = location.coordinate;
        
        coordinates[index] = coorrdinate2;
    }
    
    MKPolyline * polyLine =[MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [self.mapView addOverlay:polyLine];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Delete half filled form to database
-(void)DeleteHalfFormToDatabase
{
    NSString * deleteStr =[NSString stringWithFormat:@"delete from Main_Table where id='%@'",eventId];
    [[DataBaseManager dataBaseManager] execute:deleteStr];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }(lldb) po [[[self.mapView annotations] objectAtIndex:5] latStr]
 37.332552
 
 (lldb) po [[[self.mapView annotations] objectAtIndex:6] latStr]
 37.333849
 */

@end
