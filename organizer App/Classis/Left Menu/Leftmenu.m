//
//  Leftmenu.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "Leftmenu.h"
#import "MFSideMenu.h"
#import "menucell.h"
#import "CalendarView.h"
#import "CustomCalendarViewController.h"
#import "CreateEventViewController.h"
@interface Leftmenu ()

@end

@implementation Leftmenu

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
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
   
    self.navigationController.navigationBarHidden = YES;
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    UIImageView * logoImg = [[UIImageView alloc]init];
    logoImg.frame = CGRectMake(140, 30, 40, 36);
    logoImg.backgroundColor = [UIColor clearColor];
    logoImg.image  =[UIImage imageNamed:@"logo.png"];
    [self.view addSubview:logoImg];
    
    menu=[[NSMutableArray alloc]initWithObjects:@"Upcoming Events",@"Find an Event",@"Live Event Setting",@"Create Event",@"Event Calendar",@"Race Result",@"Competitors",@"Sponsors",@"News Update",@"Profile",@"Logout",nil];//jam14-07
    
    tblMenu=[[UITableView alloc]initWithFrame:CGRectMake(0,80, self.view.frame.size.width, self.view.frame.size.height-80)];
    tblMenu.backgroundColor=[UIColor clearColor];
    [tblMenu setDelegate:self];
    [tblMenu setDataSource:self];
    [tblMenu setSeparatorColor:[UIColor clearColor]];
    [tblMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tblMenu];
    
    NSIndexPath *initialIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [tblMenu selectRowAtIndexPath:initialIndex
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
    [self tableView:tblMenu didSelectRowAtIndexPath:initialIndex];
    
    selectedOne = 0;
    isEventSavedCorrect=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moveToUpcomingEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToUpcomingEvent) name:@"moveToUpcomingEvent" object:nil];
    
    
}

-(void)moveToUpcomingEvent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpcomingEvent" object:nil];
    selectedOne = 0;
    [tblMenu reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *test = @"table";
    menucell *cell = (menucell *) [tableView dequeueReusableCellWithIdentifier:test];
    
    if( !cell )
    {
        cell = [[menucell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:test];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }

    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectionColor;
    
    cell.lblTitle.highlightedTextColor = [UIColor yellowColor];
    cell.lblTitle.text=[menu objectAtIndex:indexPath.row];
    cell.lblTitle.textAlignment=NSTextAlignmentLeft;
    
    if (indexPath.row  == 0)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"upcomingEvent_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 14, 32, 32);

    }
    if (indexPath.row  == 1)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"find.png"];
        cell.ImgIcon.frame = CGRectMake(15, 14, 32, 32);
        
    }
    else if (indexPath.row == 2)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"eventsetting_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 14, 32, 32);

    }
    else if (indexPath.row == 3)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"create_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 14, 32, 32);

    }
    else if (indexPath.row == 4)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"event-calendar_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 14, 32, 32);

    }
    else if (indexPath.row == 5)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"race-results_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 11, 32, 38);
    }
    else if (indexPath.row == 6)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"competitors_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 19.05, 32, 21);

    }
    else if (indexPath.row == 7)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"sponsors_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 18, 32, 24);

    }
    else if (indexPath.row == 8)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"news_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 14, 29, 32);

    }
    else if (indexPath.row == 9)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"profile_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 17, 32, 26);

    }
    else if (indexPath.row == 10)
    {
        cell.ImgIcon.image = [UIImage imageNamed:@"left-logout_Ipad"];
        cell.ImgIcon.frame = CGRectMake(15, 17, 28, 32);

    }
   cell.lblTitle.font = [UIFont fontWithName:@"Century Gothic" size:24.0f];
    

    if (indexPath.row == selectedOne)
    {
        cell.selectedImg.hidden = NO;
        cell.lblTitle.textColor = [UIColor yellowColor];
    }
    else
    {
        cell.lblTitle.textColor = [UIColor lightGrayColor];

        cell.selectedImg.hidden = YES;
    }
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEventEditView ==YES)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Would you like to save information?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 4;
        [alert show];
        
    }
    else if (isEventSavedCorrect==NO)
    {
        isEventSavedCorrect=YES;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Would you like to save information?" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
        alert.tag = 66;
        [alert show];
    }
    else
    {
        if (selectedOne == indexPath.row)
        {
            if (indexPath.row == 10)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to logout from the app?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                alert.tag = 5;
                [alert show];
            }
            else
            {
                
            }
        }
        else
        {
            if (indexPath.row==0)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpcomingEvent" object:nil];
            }
            else if (indexPath.row == 1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FindEvent" object:nil];
            }
            else if (indexPath.row == 2)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"currentEventSetting" object:nil];
            }
            else if (indexPath.row == 3)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createEvent" object:nil];
            }
            else if (indexPath.row == 4)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"calenderView" object:nil];
            }
            else if (indexPath.row == 5)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"raceResult" object:nil];
            }
            else if (indexPath.row == 6)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"competitorsView" object:nil];
            }
            else if (indexPath.row == 7)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sponsorsView" object:nil];
            }
            else if (indexPath.row == 8)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newsUpdate" object:nil];
            }
            else if (indexPath.row == 9)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"profileView" object:nil];
            }
            else if (indexPath.row == 10)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to logout from the app?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                alert.tag = 5;
                [alert show];
                
                
            }

        }
        
    }
    
    selectedOne = indexPath.row;
    [tableView reloadData];
    
    /*NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedOne inSection:0]];
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];*/
    
}

#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            
            [self logoutWebservice];//jam15-07-2015.
            
          
        }
        else
        {
            
            [tblMenu reloadData];

            
        }
    }
    else if (alertView.tag == 4)
    {
        if (buttonIndex == 0)
        {
            selectedOne = 0;
             [tblMenu reloadData];
        }
        else
        {
            isEventEditView = NO;
            if (selectedOne==0)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpcomingEvent" object:nil];
            }
            else if (selectedOne == 1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FindEvent" object:nil];
            }
            else if (selectedOne == 2)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"currentEventSetting" object:nil];
            }
            else if (selectedOne== 3)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createEvent" object:nil];
            }
            else if (selectedOne == 4)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"calenderView" object:nil];
            }
            else if (selectedOne == 5)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"raceResult" object:nil];
            }
            else if (selectedOne == 6)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"competitorsView" object:nil];
            }
            else if (selectedOne == 7)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sponsorsView" object:nil];
            }
            else if (selectedOne == 8)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newsUpdate" object:nil];
            }
            else if (selectedOne == 9)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"profileView" object:nil];
            }
            else if (selectedOne == 10)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to logout from the app?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                alert.tag = 5;
                [alert show];

               
                
            }
            
            [tblMenu reloadData];
        }
    }
    else if (alertView.tag==66)
    {
        if (buttonIndex == 0)
        {
            selectedOne = 3;
            
                if (selectedOne==0)
                {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpcomingEvent" object:nil];
                }
                else if (selectedOne == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FindEvent" object:nil];
                }
                else if (selectedOne == 2)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentEventSetting" object:nil];
                }
                else if (selectedOne== 3)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"createEvent" object:nil];
                }
                else if (selectedOne == 4)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"calenderView" object:nil];
                }
                else if (selectedOne == 5)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"raceResult" object:nil];
                }
                else if (selectedOne == 6)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"competitorsView" object:nil];
                }
                else if (selectedOne == 7)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sponsorsView" object:nil];
                }
                else if (selectedOne == 8)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newsUpdate" object:nil];
                }
                else if (selectedOne == 9)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileView" object:nil];
                }
                else if (selectedOne == 10)
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to logout from the app?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                    alert.tag = 5;
                    [alert show];
                    
                }
                
                [tblMenu reloadData];
            
            [tblMenu reloadData];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteRow" object:nil];
            if (selectedOne==0)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpcomingEvent" object:nil];
            }
            else if (selectedOne == 1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FindEvent" object:nil];
            }
            else if (selectedOne == 2)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"currentEventSetting" object:nil];
            }
            else if (selectedOne== 3)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createEvent" object:nil];
            }
            else if (selectedOne == 4)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"calenderView" object:nil];
            }
            else if (selectedOne == 5)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"raceResult" object:nil];
            }
            else if (selectedOne == 6)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"competitorsView" object:nil];
            }
            else if (selectedOne == 7)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sponsorsView" object:nil];
            }
            else if (selectedOne == 8)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newsUpdate" object:nil];
            }
            else if (selectedOne == 9)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"profileView" object:nil];
            }
            else if (selectedOne == 10)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to logout from the app?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                alert.tag = 5;
                [alert show];

                
                
            }
            
            [tblMenu reloadData];
        }
    }
}


-(void)logoutWebservice//jam15-07-2015
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    if (deviceToken ==nil)
    {
        [dict setValue:@"123" forKey:@"device_token"];
    }
    else
    {
        [dict setValue:deviceToken forKey:@"device_token"];
    }
    
    
    [dict setValue:@"ios" forKey:@"device_type"];
   
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"logout";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/logout" withParameters:dict];

}

#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result//jam15-07-2015
{
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"logout"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"splashAfterLogin" object:nil];
            
        }
        else
        {
            NSString * strMsg = [NSString stringWithFormat:@"%@",[[result valueForKey:@"result"]valueForKey:@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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


@end
