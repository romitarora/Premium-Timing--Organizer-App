//
//  UpComingEventVC.m
//  organizer App
//
//  Created by Romit on 04/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "UpComingEventVC.h"

#import "EventDetailsVC.h"
@interface UpComingEventVC ()

@end

@implementation UpComingEventVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    titleLbl.text = @"Upcoming Events";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    //titleLbl.font = [UIFont systemFontOfSize:25.0f];
    [navView addSubview:titleLbl];
    
    
    noticeMsgLbl = [[UILabel alloc]init];
    noticeMsgLbl.frame = CGRectMake(30, 300, 704-60, 200);
    noticeMsgLbl.textColor = [UIColor whiteColor];
    noticeMsgLbl.backgroundColor = [UIColor clearColor];
    noticeMsgLbl.textAlignment = NSTextAlignmentCenter;
    noticeMsgLbl.text = @"No Events. Please create new event";
    noticeMsgLbl.numberOfLines = 0;
    noticeMsgLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    noticeMsgLbl.hidden = YES;
    [navView addSubview:noticeMsgLbl];

    
    EventListTbl = [[UITableView alloc]init];
    EventListTbl.frame = CGRectMake(20, 80, 704-40, 768-80);
    EventListTbl.backgroundColor = [UIColor clearColor];
    [EventListTbl setDelegate:self];
    [EventListTbl setDataSource:self];
    [EventListTbl setSeparatorColor:[UIColor clearColor]];
    [EventListTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    EventListTbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:EventListTbl];
    
    eventListArr = [[NSMutableArray alloc]init];
    
    NSString * strMessage = [NSString stringWithFormat:@"select * from Main_table"];
    [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:eventListArr];

    if ([eventListArr count]== 0)
    {
        eventListArr = [[NSMutableArray alloc]init];
        noticeMsgLbl.hidden = NO;
    }
    else
    {
        noticeMsgLbl.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"createEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createEvent) name:@"createEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"calenderView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calenderView) name:@"calenderView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpcomingEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comingEvent) name:@"UpcomingEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logoutView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutView) name:@"logoutView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"competitorsView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(competitorsView) name:@"competitorsView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sponsorsView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sponsorsView) name:@"sponsorsView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"profileView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileView) name:@"profileView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FindEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FindEventClik) name:@"FindEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentEventSetting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentEventSetting) name:@"currentEventSetting" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"raceResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(raceResultView) name:@"raceResult" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newsUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsUpdateView) name:@"newsUpdate" object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];

   // [self orientationChanged:self];
}

#pragma mark TableView Methods
#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [eventListArr count];
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath

{
    cell.backgroundColor = [UIColor clearColor];
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *test = @"table";
    UpcomingEventCell *cell = (UpcomingEventCell *) [tableView dequeueReusableCellWithIdentifier:test];
    
    if( !cell )
    {
        cell = [[UpcomingEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:test];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    EventListTbl.backgroundColor = [UIColor clearColor];
    
    cell.header.frame = CGRectMake(0, 0, EventListTbl.frame.size.width, 150);
    
    cell.header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBackground"]];
    
  /*
   
    NSDateFormatter * ddEnd = [[NSDateFormatter alloc]init];
    [ddEnd setDateFormat:@"dd LLL yyyy"];
    
   
    */
    
    NSString * startDate = [NSString stringWithFormat:@"%@",[[eventListArr objectAtIndex:indexPath.row] valueForKey:@"start_time"]];
    
    NSString * endDate = [NSString stringWithFormat:@"%@",[[eventListArr objectAtIndex:indexPath.row] valueForKey:@"end_time"]];
    
    NSArray * startArr = [startDate componentsSeparatedByString:@" "];
    NSString *startdate =  [startArr objectAtIndex:0];
   
    
    NSArray * endArr = [endDate componentsSeparatedByString:@" "];
    NSString *enddate =  [endArr objectAtIndex:0];
    
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];

    NSDate *calenderDate = [df dateFromString:startdate];

    NSDate *calenderEndDste = [df dateFromString:enddate];
    
    NSDateFormatter * dd = [[NSDateFormatter alloc]init];
    [dd setDateFormat:@"dd LLL yyyy"];
    
    
    NSString * date = [dd stringFromDate:calenderDate];
    
    NSString * EndDate = [dd stringFromDate:calenderEndDste];
    
    NSArray * tempArr = [date componentsSeparatedByString:@" "];
    NSString *eventDate = [tempArr objectAtIndex:0];
    NSString *startmonth = [tempArr objectAtIndex:1];
    
    NSArray * tempArr1 = [EndDate componentsSeparatedByString:@" "];
    NSString *eventEnddate = [tempArr1 objectAtIndex:0];
    NSString *endmonth = [tempArr1 objectAtIndex:1];
    
    cell.eventNameLbl.text = [[eventListArr objectAtIndex:indexPath.row] valueForKey:@"event_name"];
    
    cell.locationLbl.text = [[eventListArr objectAtIndex:indexPath.row] valueForKey:@"location"];
    
    cell.startDateLbl.text =eventDate;
    cell.startMonthLbl.text =startmonth;
    
    cell.endDateLbl.text =eventEnddate;
    cell.endMonthLbl.text = endmonth;
    
    
    NSString * imgData =[[eventListArr objectAtIndex:indexPath.row] valueForKey:@"photo"];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    
    cell.eventImage.image=[UIImage imageWithData:data];
  
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    EventDetailsVC *event=[[EventDetailsVC alloc]init];
    event.mainId = [[eventListArr objectAtIndex:indexPath.row] valueForKey:@"event_id"];
    event.tableId = [[eventListArr objectAtIndex:indexPath.row] valueForKey:@"id"];

//    event.mainId = [[eventListArr objectAtIndex:indexPath.row] valueForKey:@"id"];

    event.eventName = [[eventListArr objectAtIndex:indexPath.row]valueForKey:@"event_name"];
    event.organiserName = [[eventListArr objectAtIndex:indexPath.row] valueForKey:@"organiser_name"];//jam15-07-2015
    
    [self.navigationController pushViewController:event animated:YES];
  
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    selectedRow = indexPath.row;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        selectedRow = indexPath.row;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this Event?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 10;
        [alert show];
        
    }
}

#pragma mark notification actions

-(void)createEvent
{
    CreateEventViewController* crv = [[CreateEventViewController alloc]init];
    [self.navigationController pushViewController:crv animated:NO];
}
-(void)calenderView
{
    // BY RAJU 9-7-2015
    lastdate=[NSDate date];
    
    CustomCalendarViewController * crv = [[CustomCalendarViewController alloc]init];
    [self.navigationController pushViewController:crv animated:NO];
}
-(void)comingEvent
{
    UpComingEventVC * crv = [[UpComingEventVC alloc]init];
    [self.navigationController pushViewController:crv animated:NO];
}
-(void)logoutView
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to logout from the app?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 5;
    [alert show];
}
-(void)competitorsView
{
    ParticipantsViewController * crv = [[ParticipantsViewController alloc]init];
    [self.navigationController pushViewController:crv animated:NO];
}

-(void)sponsorsView
{
    SponsorsViewController * crv = [[SponsorsViewController alloc]init];
    [self.navigationController pushViewController:crv animated:NO];
}
-(void)profileView
{
    ProfileSetUpVC * crv = [[ProfileSetUpVC alloc]init];
    [self.navigationController pushViewController:crv animated:NO];
}
-(void)FindEventClik
{
    FindEventViewController * view = [[FindEventViewController alloc] init];
    [self.navigationController pushViewController:view animated:NO];
}
-(void)currentEventSetting
{
    CurrentEventSettingVC * view = [[CurrentEventSettingVC alloc] init];
    [self.navigationController pushViewController:view animated:NO];
}

-(void)raceResultView
{
    RaceResultViewController * view = [[RaceResultViewController alloc] init];
    [self.navigationController pushViewController:view animated:NO];
}
-(void)newsUpdateView
{
    NewsUpdateViewController * view = [[NewsUpdateViewController alloc] init];
    [self.navigationController pushViewController:view animated:NO];
}

#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"deleteEvents"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSString * strMsg = [NSString stringWithFormat:@"%@",[[result valueForKey:@"result"]valueForKey:@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Main_Table where id = '%@'",[[eventListArr objectAtIndex:selectedRow] valueForKey:@"id"]];
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            [eventListArr removeObjectAtIndex:selectedRow];
            
            if (eventListArr.count == 0)
            {
                noticeMsgLbl.hidden = NO;
                
            }
            else
            {
                noticeMsgLbl.hidden = YES;
            }
            [EventListTbl reloadData];
            
            NSLog(@"Deleted row.");
            

            
            
        }
        else
        {
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Main_Table where id = '%@'",[[eventListArr objectAtIndex:selectedRow] valueForKey:@"id"]];
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            [eventListArr removeObjectAtIndex:selectedRow];
            
            if (eventListArr.count == 0)
            {
                noticeMsgLbl.hidden = NO;
                
            }
            else
            {
                noticeMsgLbl.hidden = YES;
            }
            [EventListTbl reloadData];
            
            NSLog(@"Deleted row.");
            [EventListTbl reloadData];
            
            
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"splashAfterLogin" object:nil];
        }
        else
        {
            
        }
    }
    else if (alertView.tag == 10)
    {
        if (buttonIndex == 0)
        {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            
            [dict setValue:[[eventListArr objectAtIndex:selectedRow] valueForKey:@"event_id"] forKey:@"event_id"];
            
            URLManager *manager = [[URLManager alloc] init];
            manager.commandName = @"deleteEvents";
            manager.delegate = self;
            [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/deleteEvents" withParameters:dict];
            
            
            
        }
        else
        {
            [EventListTbl reloadData];
        }
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*- (void)orientationChanged:(id)object
{
    UIInterfaceOrientation interfaceOrientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown  )
    {
        
        //self.view.frame = CGRectMake(0, 0, 768, 1024);
        // _customCalendarView.frame = CGRectMake(134, 160, 500, 500);
    }
    else
    {
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft)
        {
            self.view.frame = CGRectMake(0, 0, 1024, 768);
            
            NSLog(@"home its landscape left");
        }
        else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            self.view.frame = CGRectMake(0, 0, 1024, 768);
        }

       // _customCalendarView.frame = CGRectMake(262, 160, 500, 500);
        
        
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"supportedInterfaceOrientations in home menu");
    
    return UIInterfaceOrientationMaskLandscape;
}

*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
