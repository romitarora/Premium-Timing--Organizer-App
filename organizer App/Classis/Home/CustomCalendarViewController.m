//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by Michael Azevedo on 21/07/2014.
//  Copyright (c) 2014 Michael Azevedo All rights reserved.
//

#import "CustomCalendarViewController.h"
#import "EventScheduleVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "Leftmenu.h"
#import "CreateEventViewController.h"
#import "Constant.h"
@interface CustomCalendarViewController ()

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;

@end

@implementation CustomCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    //    if (self.menuContainerViewController.menuState == MFSideMenuStateClosed)
    //    {
    //        self.menuContainerViewController.menuState  = MFSideMenuStateLeftMenuOpen;
    //      //  Leftmenu * left = [[Leftmenu alloc]init];
    //       // self.menuContainerViewController.leftMenuViewController = left;
    //
    //    }
    //    else
    //    {
    //
    //    }
    appDelegateObj=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    self.navigationController.navigationBarHidden=YES;
    
    [self gettingDBBasedOnCreatedDates];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheCalendar) name:@"refreshMyCalendar" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonthName) name:@"refreshMonthName" object:nil];
    
    [self setRestUI];
    
    
    
    
}
-(void)refreshTheCalendar
{
    [_customCalendarView removeFromSuperview];
    
    /*scrollCalender = [[UIScrollView alloc]init];
     scrollCalender.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-130);
     scrollCalender.delegate =  self;
     scrollCalender.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
     scrollCalender.backgroundColor = [UIColor clearColor];
     scrollCalender.scrollEnabled = YES;
     
     [self.view addSubview:scrollCalender];*/
    
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0,160, 500, 500)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    
    
    // BY RAJU 9-7-2015
    
    if (lastdate!=nil) {
        _customCalendarView.calendarDate=lastdate;
    }
    
    _customCalendarView.monthAndDayTextColor        = [UIColor whiteColor];//RGBCOLOR(0, 174, 255);
    _customCalendarView.dayBgColorWithData          = RGBCOLOR(21, 124, 229);//Past date and current date back color
    _customCalendarView.dayBgColorWithoutData       = RGBCOLOR(208, 208, 214);//Future date Back color
    _customCalendarView.dayBgColorSelected          = RGBCOLOR(94, 94, 94);
    _customCalendarView.dayTxtColorWithoutData      = RGBCOLOR(57, 69, 84);
    _customCalendarView.dayTxtColorWithData         = [UIColor whiteColor];
    _customCalendarView.dayTxtColorSelected         = [UIColor whiteColor];
    _customCalendarView.borderColor                 = RGBCOLOR(159, 162, 172);
    _customCalendarView.borderWidth                 = 1;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
    [self.view addSubview:_customCalendarView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMyCalendar" object:nil];
}
-(void)datafromDatabse
{
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gettingDBBasedOnCreatedDates:) name:@"CalenderNotification" object:nil];
    Isopen=NO;
    
    
    differencedates=[[NSMutableArray alloc]init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar1.png"] forBarMetrics: UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f]};
    
    
    
    
    /* scrollCalender = [[UIScrollView alloc]init];
     scrollCalender.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-130);
     scrollCalender.delegate =  self;
     scrollCalender.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
     scrollCalender.backgroundColor = [UIColor clearColor];
     scrollCalender.scrollEnabled = YES;
     
     [self.view addSubview:scrollCalender];*/
    
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 160, 700, 500)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    _customCalendarView.monthAndDayTextColor        = [UIColor whiteColor];
    _customCalendarView.dayBgColorWithData          = RGBCOLOR(21, 124, 229);//Past date and current date back color
    _customCalendarView.dayBgColorWithoutData       = RGBCOLOR(208, 208, 214);//Future date Back color
    _customCalendarView.dayBgColorSelected          = RGBCOLOR(94, 94, 94);
    _customCalendarView.dayTxtColorWithoutData      = RGBCOLOR(57, 69, 84);
    _customCalendarView.dayTxtColorWithData         = [UIColor whiteColor];
    _customCalendarView.dayTxtColorSelected         = [UIColor whiteColor];
    _customCalendarView.borderColor                 = RGBCOLOR(159, 162, 172);
    _customCalendarView.borderWidth                 = 1;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
    [self.view addSubview:_customCalendarView];
    
    [self setRestUI];
    
}

#pragma mark - Rest UI
-(void)setRestUI
{
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    
    UILabel * titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(704/2-65, 0, 140, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Calender";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    //[navView addSubview:titleLbl];
    
    UIButton * addBtn = [[UIButton alloc]init];
    addBtn.frame = CGRectMake(704-100, 30, 30, 30);
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:addBtn];
    
    
    UIButton * settingBtn = [[UIButton alloc]init];
    settingBtn.frame = CGRectMake(704-50, 30, 30, 30);
    settingBtn.backgroundColor = [UIColor clearColor];
    [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:settingBtn];
    
    
    
    lblMonth=[[UILabel alloc]initWithFrame:CGRectMake(704/2-120, 20, 250, 50)];
    lblMonth.text=[NSString stringWithFormat:@"December 2015"];
    lblMonth.textAlignment=NSTextAlignmentCenter;
    lblMonth.textColor=[UIColor whiteColor];
    lblMonth.numberOfLines=0;
    lblMonth.backgroundColor = [UIColor clearColor];
    [lblMonth setFont:[UIFont fontWithName:@"Century Gothic" size:30.0f]];//jam
    [self.view addSubview:lblMonth];
    
    UIImageView * leftImg = [[UIImageView alloc]init];
    leftImg.frame =CGRectMake(704/2-170, 35, 14,26);
    leftImg.image  = [UIImage imageNamed:@"left.png"];
    leftImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftImg];
    
    previousBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [previousBtn addTarget:self action:@selector(movePrevious) forControlEvents:UIControlEventTouchUpInside];
    previousBtn.frame=CGRectMake(704/2-170, 15, 50,50);
    [previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:previousBtn];
    
    UIImageView * rightImg = [[UIImageView alloc]init];
    rightImg.frame =CGRectMake(704/2+150,35, 14,26);
    rightImg.image  = [UIImage imageNamed:@"right.png"];
    rightImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rightImg];
    
    nextBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(moveNext) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame=CGRectMake(704/2+150,15, 50,50);
    nextBtn.titleLabel.font=[UIFont boldSystemFontOfSize:35.0];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    nextBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:35.0f];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:48.0f]];
    
    
    previousBtn.titleLabel.font          = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [previousBtn.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:48.0f]];
    
    UIImageView * exportImg = [[UIImageView alloc]init];
    exportImg.frame = CGRectMake(704-60, 20, 40, 46);
    exportImg.image =[UIImage imageNamed:@"export-to-calendar"];
    exportImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:exportImg];
    
    UIButton * eventExportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eventExportBtn.frame = CGRectMake(704-100, 10, 100, 60);
    eventExportBtn.backgroundColor = [UIColor clearColor];
    [eventExportBtn addTarget:self action:@selector(eventExportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eventExportBtn];
    
    
}
#pragma mark - Gesture recognizer

-(void)swipeleft:(id)sender
{
    [_customCalendarView showNextMonth];
}

-(void)swiperight:(id)sender
{
    [_customCalendarView showPreviousMonth];
}


-(void)movePrevious
{
    
    [_customCalendarView showPreviousMonth];
    
}

-(void)moveNext
{
    [_customCalendarView showNextMonth];
    
}

-(void)refreshMonthName
{
    lblMonth.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"currentMonth"];
}
#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    // Get necessary date components
    
    NSDateComponents* components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:selectedDate];
    
    
    {
        imgMenu.hidden=YES;
        Isopen=NO;
        
        EventScheduleVC *fishingAndEnv=[[EventScheduleVC alloc]init];
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        fishingAndEnv.selectedDate=[df stringFromDate:selectedDate];
        selecatedDateStr=[df stringFromDate:selectedDate];
        [self.navigationController pushViewController:fishingAndEnv animated:YES];
        
        
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        NSString *timeStamp = [dateFormatter stringFromDate:selectedDate];
        NSDate * justdate =[dateFormatter dateFromString:timeStamp];
        NSString *newString = [NSString stringWithFormat:@"%f",[justdate timeIntervalSince1970] * 1000];
        unixDatestr= [newString substringToIndex:[newString length]-7];
        //NSLog(@"fsdfsf %@",unixDatestr);
        
    }
}

#pragma mark - CalendarDataSource protocol conformance

-(BOOL)isDataForDate:(NSDate *)date
{
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    NSDateComponents * yearComponent = [_gregorian components:NSYearCalendarUnit fromDate:date];
    return (yearComponent.year == _currentYear || yearComponent.year == _currentYear+1);
}

#pragma mark - Action methods
-(void)addBtnClick:(id)sender
{
    
}
-(void)settingBtnClick:(id)sender
{
    
}
-(void)eventExportBtnClick
{
    
    
    NSMutableArray * tempArr = [[NSMutableArray alloc]init];
    NSString * str  =[NSString stringWithFormat:@"select * from Main_Table"];
    [[DataBaseManager dataBaseManager] execute:str resultsArray:tempArr];
    
    
    
    for (int i =0; i<[tempArr count]; i++)
    {
        
        
        NSString * startDate = [NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] valueForKey:@"start_time"]];
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd LLL yyyy"];
        NSDate *calenderDate = [df dateFromString:startDate];
        
        NSDateFormatter * dd = [[NSDateFormatter alloc]init];
        [dd setDateFormat:@"yyyy-MM-dd"];
        NSString * date = [dd stringFromDate:calenderDate];
        NSDate * stDate = [dd dateFromString:date];
        
        NSArray * tempArr1 = [[[tempArr objectAtIndex:i] valueForKey:@"endDate"] componentsSeparatedByString:@","];
        NSString *enddate = [tempArr1 objectAtIndex:0];
        
        NSDateFormatter * df1 = [[NSDateFormatter alloc] init];
        [df1 setDateFormat:@"dd LLL yyyy"];
        NSDate *calenderEndDate = [df1 dateFromString:enddate];
        
        NSDateFormatter * dd1 = [[NSDateFormatter alloc]init];
        [dd1 setDateFormat:@"yyyy-MM-dd"];
        NSString * strEnd = [dd1 stringFromDate:calenderEndDate];
        NSDate * enDate = [dd dateFromString:strEnd];
        
        NSLog(@"startDate...%@",stDate);
        NSLog(@"endDate...%@",enDate);
        
        
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = [NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] valueForKey:@"event_name"]];
            event.startDate = stDate; //today
            event.endDate = enDate;  //set 1 hour meeting
            event.calendar = [store defaultCalendarForNewEvents];
            event.location = [NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] valueForKey:@"location"]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
            
        }];
    }
    
    
    // BY RAJU 9-7-2015
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"All events have been successfully synced with your device calendar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
    
}
#pragma mark - Database Methods
-(void)gettingDBBasedOnCreatedDates
{
    NSMutableArray * eventArr=[[NSMutableArray alloc]init];
    NSString * string2=@"SELECT event_date FROM Main_Table";
    [[DataBaseManager dataBaseManager]execute:string2 resultsArray:eventArr];
    NSLog(@"fishArray %@",eventArr);
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:eventArr forKey:@"allEventReports"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self datafromDatabse];
    
    //   temp1=[[NSMutableArray alloc]init];
    
    //  for (int a=0; a<envArray.count; a++) {
    //    [temp1 addObject:[[envArray objectAtIndex:a] valueForKey:@"local_time"]];
    // }
}
-(void)gettingDBBasedOnCreatedDates:(NSNotification *)notification
{
    [self gettingDBBasedOnCreatedDates];
    // [self.customDatePickerView reloadData];
    [_customCalendarView reloadInputViews];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    imgMenu.hidden=YES;
    Isopen=NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
