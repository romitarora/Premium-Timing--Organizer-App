//
//  EventScheduleVC.m
//  organizer App
//
//  Created by One Click IT Consultancy  on 5/30/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "EventScheduleVC.h"
#import "EventDetailsVC.h"
@interface EventScheduleVC ()

@end

@implementation EventScheduleVC
@synthesize selectedDate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Event Schedule";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    //titleLbl.font = [UIFont systemFontOfSize:25.0f];
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

    
    dateLbl = [[UILabel alloc]init];
    dateLbl.frame = CGRectMake(0, 85, 704, 30);
    dateLbl.textAlignment = NSTextAlignmentCenter;
    dateLbl.textColor = [UIColor whiteColor];
    dateLbl.backgroundColor = [UIColor clearColor];
    dateLbl.text = selectedDate;
    [self.view addSubview:dateLbl];
    
    
    NSString *strnotice = [NSString stringWithFormat:@"No Events On %@ ", selectedDate ];
    
    noticeMsgLbl = [[UILabel alloc]init];
    noticeMsgLbl.frame = CGRectMake(30, 300, 704-60, 200);
    noticeMsgLbl.textColor = [UIColor whiteColor];
    noticeMsgLbl.backgroundColor = [UIColor clearColor];
    noticeMsgLbl.textAlignment = NSTextAlignmentCenter;
    noticeMsgLbl.text = strnotice;
    noticeMsgLbl.numberOfLines = 0;
    noticeMsgLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    noticeMsgLbl.hidden = YES;
    [self.view addSubview:noticeMsgLbl];
    
    [eventSearchBar removeFromSuperview];
    
    if(!eventSearchBar)
    {
        eventSearchBar = [[UISearchBar alloc] init];
        [eventSearchBar setFrame:CGRectMake(20, 130, 704-40, 60)];
        eventSearchBar.delegate = self;
        eventSearchBar.showsCancelButton = NO;
        eventSearchBar.placeholder = @"Search here";
        eventSearchBar.tintColor = [UIColor yellowColor];
        eventSearchBar.barStyle = UIBarStyleDefault;
        eventSearchBar.backgroundImage = [UIImage imageNamed:@"searchbar.png"];
        [self.view addSubview:eventSearchBar];
        
        UITextField* sbTextField;
        
        for (UIView *subView in eventSearchBar.subviews){
            for (UIView *ndLeveSubView in subView.subviews){
                
                if ([ndLeveSubView isKindOfClass:[UITextField class]])
                {
                    
                    sbTextField = (UITextField *)ndLeveSubView;
                    //changes typing text color
                    sbTextField.textColor = [UIColor blackColor];
                    //changes background color
                    sbTextField.backgroundColor = [UIColor lightGrayColor];
                    //changes placeholder color
                    UIColor *color = [UIColor darkGrayColor];
                    sbTextField.attributedPlaceholder =
                    [[NSAttributedString alloc]
                     initWithString:@"Search here"
                     attributes:@{NSForegroundColorAttributeName:color}];
                    
                    break;
                }
                
            }
        }
        
    }
    
    eventViewTbl = [[UITableView alloc]init];
    eventViewTbl.frame = CGRectMake(20, 195, 704-40, 768-195);
    eventViewTbl.backgroundColor = [UIColor clearColor];
    [eventViewTbl setDelegate:self];
    [eventViewTbl setDataSource:self];
    [eventViewTbl setSeparatorColor:[UIColor clearColor]];
    [eventViewTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:eventViewTbl];
    tempEventArr  = [[NSMutableArray alloc]init];
    
    NSString * strMessage = [NSString stringWithFormat:@"select * from Main_table where event_date='%@'",selectedDate];
    
    [[DataBaseManager dataBaseManager] execute:strMessage resultsArray:tempEventArr];
    
    
    if ([tempEventArr count]==0)
    {
        noticeMsgLbl.hidden = NO;
        eventSearchBar.hidden = YES;
    }
    else
    {
        noticeMsgLbl.hidden = YES;
        eventSearchBar.hidden = NO;
    }
    
}
#pragma mark Button Click Event
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView Methods
#pragma mark - UITableViewDatasource
#pragma mark TableView Delegates Methods

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
    if (isSearching == YES)
    {
        return [filteredContentArray count];
    }
    else
    {
        return [tempEventArr count];
    }
    return [tempEventArr count];
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //jam 14-07-2015----------change full method code----------//
    static NSString *test = @"table";
    UpcomingEventCell *cell = (UpcomingEventCell *) [tableView dequeueReusableCellWithIdentifier:test];
    
    if( !cell )
    {
        cell = [[UpcomingEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:test];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    eventViewTbl.backgroundColor = [UIColor clearColor];
    
    cell.header.frame = CGRectMake(0, 0, eventViewTbl.frame.size.width, 150);
    
    cell.header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBackground"]];
    
    if (isSearching == YES)
    {
        
        
        NSString * startDate = [NSString stringWithFormat:@"%@",[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"start_time"]];
        
        NSString * endDate = [NSString stringWithFormat:@"%@",[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"end_time"]];
        
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
        
        cell.eventNameLbl.text = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"event_name"];
        
        cell.locationLbl.text = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"location"];
        
        cell.startDateLbl.text =eventDate;
        cell.startMonthLbl.text =startmonth;
        
        cell.endDateLbl.text =eventEnddate;
        cell.endMonthLbl.text = endmonth;
        
        
        NSString * imgData =[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"photo"];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        
        cell.eventImage.image=[UIImage imageWithData:data];
        
        
    }
    else
    {
        NSString * startDate = [NSString stringWithFormat:@"%@",[[tempEventArr objectAtIndex:indexPath.row] valueForKey:@"start_time"]];
        
        NSString * endDate = [NSString stringWithFormat:@"%@",[[tempEventArr objectAtIndex:indexPath.row] valueForKey:@"end_time"]];
        
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
        
        cell.eventNameLbl.text = [[tempEventArr objectAtIndex:indexPath.row] valueForKey:@"event_name"];
        
        cell.locationLbl.text = [[tempEventArr objectAtIndex:indexPath.row] valueForKey:@"location"];
        
        cell.startDateLbl.text =eventDate;
        cell.startMonthLbl.text =startmonth;
        
        cell.endDateLbl.text =eventEnddate;
        cell.endMonthLbl.text = endmonth;
        
        
        NSString * imgData =[[tempEventArr objectAtIndex:indexPath.row] valueForKey:@"photo"];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        
        cell.eventImage.image=[UIImage imageWithData:data];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearching == YES)
    {
        EventDetailsVC *event=[[EventDetailsVC alloc]init];
        event.mainId = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"event_id"];
        event.eventName = [[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"event_name"];
        [self.navigationController pushViewController:event animated:YES];
 
    }
    else
    {
        EventDetailsVC *event=[[EventDetailsVC alloc]init];
        event.mainId = [[tempEventArr objectAtIndex:indexPath.row] valueForKey:@"event_id"];
        event.eventName = [[tempEventArr objectAtIndex:indexPath.row]valueForKey:@"event_name"];
        [self.navigationController pushViewController:event animated:YES];

    }
}


#pragma mark -  UISearchBar Delegates
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
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
        [eventViewTbl reloadData];
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
    //    self.navigationController.navigationBarHidden = YES;
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    switchBtn.hidden=NO;
    //    [btnUser setHidden:NO];
    //    [btnHashTag setHidden:NO];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        eventSearchBar.frame=CGRectMake(20, 130, 704-40, 60);//jam12-9.
    }
    else
    {
        eventSearchBar.frame=CGRectMake(20, 130, 704-40, 60);
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
        eventSearchBar.frame=CGRectMake(20, 130, 704-40, 60);
    }
    else
    {
        eventSearchBar.frame=CGRectMake(20, 130, 704-40, 60);
    }
}
- (BOOL)prefersStatusBarHidden
{
    return NO;//jam
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text = @"";
    isSearching=NO;
    [eventViewTbl reloadData];
    [searchBar resignFirstResponder];
    
}


-(void)filterContentForSearchText:(NSString *)searchText
{
    // Remove all objects from the filtered search array
    [filteredContentArray removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"organiser_name CONTAINS[cd] %@ OR event_name CONTAINS[cd] %@ OR location CONTAINS[cd] %@ OR start_time CONTAINS[cd] %@ OR end_time CONTAINS[cd] %@",searchText,searchText,searchText,searchText,searchText];//jam14-07-2015
    
    NSArray *tempArray =[[NSArray alloc] init];
    
    
    tempArray = [tempEventArr filteredArrayUsingPredicate:predicate];
    
    
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
    
    [eventViewTbl reloadData];
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
