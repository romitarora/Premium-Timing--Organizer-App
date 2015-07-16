//
//  SponsorsViewController.m
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "SponsorsViewController.h"
#import "sponsorsListCell.h"
@interface SponsorsViewController ()

@end

@implementation SponsorsViewController
@synthesize isFromDetail,eventId;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.navigationController.navigationBarHidden = YES;
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navView];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Sponsors";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    
    UIImageView * backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 12, 22);;
    backimg.image = [UIImage imageNamed:@"back.png"];
    [self.view addSubview:backimg];

    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 100, 80);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    backBtn.hidden  = YES;
    [self.view addSubview:backBtn];
    
    if (isFromDetail == YES)
    {
        backimg.hidden  = NO;
        backBtn.hidden = NO;
        
    }
    else
    {
        backBtn.hidden = YES;
        backimg.hidden = YES;
    }
    
    addImg = [[UIImageView alloc]init];
    addImg.frame = CGRectMake(navView.frame.size.width-60, 30, 32, 32);
    addImg.backgroundColor = [UIColor clearColor];
    addImg.image = [UIImage imageNamed:@"add.png"];
    [navView addSubview:addImg];
    
    addBtn = [[UIButton alloc]init];
    addBtn.frame = CGRectMake(navView.frame.size.width-60, 0, 60, 80);
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:addBtn];

    sponsorsListTbl =[[UITableView alloc] initWithFrame:CGRectMake(15, 80, 704-30, 768-80) style:UITableViewStylePlain];
    sponsorsListTbl.backgroundColor = [UIColor clearColor];
    [sponsorsListTbl setDelegate:self];
    [sponsorsListTbl setDataSource:self];
    [sponsorsListTbl setSeparatorColor:[UIColor clearColor]];
    [sponsorsListTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    sponsorsListTbl.showsVerticalScrollIndicator=NO;
    [self.view addSubview:sponsorsListTbl];
    
    sponsorsView = [[UIView alloc]init];
    sponsorsView.frame = CGRectMake(0, 768, 704, 768);
    sponsorsView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    sponsorsView.hidden = YES;
    [self.view addSubview:sponsorsView];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [sponsorsView addSubview:navView];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Add Sponsors";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(10, 30, 100, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:cancelBtn];
    
    
    sponsorDetailDict = [[NSMutableDictionary alloc]init];
    [sponsorDetailDict setValue:@"required" forKey:@"sponser_name"];
    [sponsorDetailDict setValue:@"required" forKey:@"website"];
    
    UIView * tempview=[[UIView alloc]init];
    tempview.frame = CGRectMake(30, 150, 704-60, 300);
    tempview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [sponsorsView addSubview:tempview];

    int yy;
    yy = 40;
    
    UIView * nameView=[[UIView alloc]init];
    nameView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    nameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:nameView];
    
      
    txtName=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,nameView.frame.size.width-20, 50)];
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
    
    sponsorNameLbl = [[UILabel alloc]init];
    sponsorNameLbl.frame = CGRectMake(nameView.frame.size.width/2+10, 10, nameView.frame.size.width/2-20, 30);
    sponsorNameLbl.backgroundColor = [UIColor clearColor];
    sponsorNameLbl.textColor = [UIColor yellowColor];
    sponsorNameLbl.textAlignment = NSTextAlignmentRight;
    sponsorNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [nameView addSubview:sponsorNameLbl];
    
    if ([[sponsorDetailDict valueForKey:@"sponser_name"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        sponsorNameLbl.text = [sponsorDetailDict valueForKey:@"sponser_name"];
    }
    
    yy = yy+80;
    UIView * urlView=[[UIView alloc]init];
    urlView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    urlView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:urlView];
    
    txtUrl=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,nameView.frame.size.width-20, 50)];
    txtUrl.textColor=[UIColor whiteColor];
    txtUrl.keyboardType=UIKeyboardTypeEmailAddress;
    txtUrl.textAlignment = NSTextAlignmentLeft;
    txtUrl.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtUrl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtUrl.delegate = self;
    txtUrl.placeholder = @"Enter Website URL";
    txtUrl.returnKeyType=UIReturnKeyNext;
    txtUrl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtUrl setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [urlView addSubview:txtUrl];
    
    websiteLbl = [[UILabel alloc]init];
    websiteLbl.frame = CGRectMake(urlView.frame.size.width/2+10, 10, urlView.frame.size.width/2-20, 30);
    websiteLbl.backgroundColor = [UIColor clearColor];
    websiteLbl.textColor = [UIColor yellowColor];
    websiteLbl.textAlignment = NSTextAlignmentRight;
    websiteLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [urlView addSubview:websiteLbl];
    
    if ([[sponsorDetailDict valueForKey:@"website"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        websiteLbl.text = [sponsorDetailDict valueForKey:@"website"];
    }

    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(0, tempview.frame.size.height-50, tempview.frame.size.width, 50);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tempview addSubview:saveBtn];

    detailArr = [[NSMutableArray alloc]init];
    
    NSMutableArray * tempCmptArr =[[NSMutableArray alloc] init];
   // tempCmptArr=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"TotalSponsors"] mutableCopy];
    
    NSString * str = [NSString stringWithFormat:@"select * from Sponsors_Table"];
    [[DataBaseManager dataBaseManager] execute:str resultsArray:tempCmptArr];
    
    if ([tempCmptArr count ]==0)
    {
        detailArr=[[NSMutableArray alloc] init];
    }
    else
    {
        detailArr=[tempCmptArr mutableCopy];
    }
    
    isClick = NO;
    
    if (isFromDetail == YES)
    {
        backBtn.hidden  = NO;
        addImg.hidden = YES;
        addBtn.hidden = YES;
        
        NSMutableArray * temp = [[NSMutableArray alloc]init];
        NSString * str = [NSString stringWithFormat:@"select * from EventSponsors_Table where event_id = '%@'",eventId];
        [[DataBaseManager dataBaseManager] execute:str resultsArray:temp];
        
        detailArr = [[NSMutableArray alloc]init];
        detailArr = temp;
    }
    else
    {
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark Button Click Event

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addBtnClick:(id)sender
{
    
    if (isClick==NO)
    {
        isClick=YES;
        sponsorsView.hidden = NO;
        
        [UIView transitionWithView:sponsorsView
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [sponsorsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            else
                            {
                                [sponsorsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            
                            
                        }
                        completion:nil];
        
        
        ;
    }
    
}
-(void)cancelBtnClick
{
    [txtName resignFirstResponder];
    [txtUrl resignFirstResponder];
    isClick=NO;
    
    sponsorNameLbl.text = @"";
    websiteLbl.text = @"";
    
    [UIView transitionWithView:sponsorsView
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [sponsorsView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [sponsorsView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;
    
    
}
-(void)saveUser
{
    [txtName resignFirstResponder];
    [txtUrl resignFirstResponder];
    
    if ([[sponsorDetailDict valueForKey:@"sponser_name"] isEqualToString:@"required"]||[[sponsorDetailDict valueForKey:@"sponser_name"] isEqualToString:@""])
    {
        
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Sponsor Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [altfname show];
        
    }
    else if ([[sponsorDetailDict valueForKey:@"website"] isEqualToString:@"required"]||[[sponsorDetailDict valueForKey:@"website"] isEqualToString:@""])
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Website URL" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [altfname show];
    }
   /* else if (![self validateUrl:[sponsorDetailDict valueForKey:@"website"]])
    {
        
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter valid URL" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [altfname show];
        
    }*///jam15-07-2015
    
    else
    {
        
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[sponsorDetailDict valueForKey:@"sponser_name"] forKey:@"name"];
        [dict setObject:[sponsorDetailDict valueForKey:@"website"] forKey:@"website"];
        [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] forKey:@"login_user_id"];
        
        URLManager *manager = [[URLManager alloc] init];
        manager.commandName = @"addSponsors";
        manager.delegate = self;
        [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/addSponsers" withParameters:dict];
        
    }
}
-(void)linkBtnClick
{
    NSString * str = [NSString stringWithFormat:@"http://%@",[[detailArr objectAtIndex:selectedRow] valueForKey:@"website"]];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",str]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)deleteSponsors//jam15-07-2015
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"from_outside_event" forKey:@"action"];
    [dict setObject:[[detailArr objectAtIndex:selectedRow] valueForKey:@"sponser_id"] forKey:@"sponser_id"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"deleteSponser";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/deleteSponsers" withParameters:dict];
}

#pragma mark Website Url Validation

/*- (BOOL) validateUrl: (NSString *) candidate
{
    NSString *urlRegEx =
    @"([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}*///jam15-07-2015


#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"addSponsors"])
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
                    [dict setValue:[[tempArr valueForKey:@"sponsers"] valueForKey:@"website"] forKey:@"website"];
                    [dict setValue:[[tempArr valueForKey:@"sponsers"] valueForKey:@"sponser_name"] forKey:@"sponser_name"];
                
                    [dict setValue:[[tempArr valueForKey:@"sponsers"] valueForKey:@"id"] forKey:@"sponser_id"];
                
                    [dict setValue:[[tempArr valueForKey:@"sponsers"] valueForKey:@"created_date"] forKey:@"created_date"];
                
                    [detailArr addObject:dict];
                
                    [[DataBaseManager dataBaseManager] insertTotalSponsorsDetail:dict];
                    [[NSUserDefaults standardUserDefaults] setObject:detailArr forKey:@"TotalSponsors"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                
            }
            
            [sponsorsListTbl reloadData];
            [self cancelBtnClick];

            
        }
        else
        {
            NSString * strMsg = [NSString stringWithFormat:@"%@",[[result valueForKey:@"result"]valueForKey:@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"deleteSponser"])
    {
        //jam15-07-2015
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
           
            NSString * deleteStr = [NSString stringWithFormat:@"delete from Sponsors_Table where sponser_id = '%@'",[[detailArr objectAtIndex:selectedRow] valueForKey:@"sponser_id"]];
            
            [[DataBaseManager dataBaseManager] execute:deleteStr];
            [detailArr removeObjectAtIndex:selectedRow];
            [sponsorsListTbl reloadData];
            NSLog(@"Deleted row.");
            
            
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


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return detailArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier=nil;
    sponsorsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[sponsorsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    cell.headerView.frame = CGRectMake(0, 0, sponsorsListTbl.frame.size.width, 60);
    
    selectedRow =indexPath.row;
    cell.nameLbl.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"sponser_name"];
    cell.webURL.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"website"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == sponsorsListTbl)
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
        cell.backgroundColor = [UIColor clearColor];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow =indexPath.row;
    [self linkBtnClick];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    if (isFromDetail == YES)
    {
        return NO;
    }
    selectedRow =indexPath.row;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow =indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        if (isFromDetail == YES)
        {
            editingStyle = UITableViewCellEditingStyleNone;
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure you want to delete this sponsor?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag = 3;
            [alert show];
        }
       
    }
}


#pragma mark Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3)
    {
        if (buttonIndex == 0)
        {
            
            [self deleteSponsors];//jam15-07-2015
          

        }
        else
        {
             [sponsorsListTbl reloadData];
        }
    }
}

#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtName)
    {
        [txtUrl becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtName)
    {
        sponsorNameLbl.hidden = YES;
        txtName.text = sponsorNameLbl.text;
        [sponsorDetailDict setValue:textField.text forKey:@"sponser_name"];
    }
    else if (textField == txtUrl)
    {
        websiteLbl.hidden = YES;
        txtUrl.text = websiteLbl.text;
        [sponsorDetailDict setValue:textField.text forKey:@"website"];
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField == txtName)
    {
        sponsorNameLbl.hidden = NO;
        sponsorNameLbl.text = textField.text;
        [sponsorDetailDict setValue:textField.text forKey:@"sponser_name"];
        txtName.text=@"";
    }
    else if (textField == txtUrl)
    {
        websiteLbl.hidden = NO;
        websiteLbl.text = textField.text;
        [sponsorDetailDict setValue:textField.text forKey:@"website"];
        txtUrl.text=@"";
        
        
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
