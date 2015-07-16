//
//  AddSponsorsView.m
//  organizer App
//
//  Created by Romit on 11/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "AddSponsorsView.h"
#import "sponsorsListCell.h"
@interface AddSponsorsView ()

@end

@implementation AddSponsorsView
@synthesize isFromEdit,isagainCome;
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
    titleLbl.text = @"Sponsors";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    UIImageView * backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 12, 22);;
    backimg.image = [UIImage imageNamed:@"back.png"];
    [navView addSubview:backimg];

    
    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 100, 30);
    backBtn.backgroundColor = [UIColor clearColor];
   // [backBtn setTitle:@"< Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:backBtn];
    
    
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
    
    noticeMsgLbl = [[UILabel alloc]init];
    noticeMsgLbl.frame = CGRectMake(30, 300, 704-60, 200);
    noticeMsgLbl.textColor = [UIColor whiteColor];
    noticeMsgLbl.backgroundColor = [UIColor clearColor];
    noticeMsgLbl.textAlignment = NSTextAlignmentCenter;
    noticeMsgLbl.text = @"No Sponsors. Please add Sponsors click on add icon";
    noticeMsgLbl.numberOfLines = 0;
    noticeMsgLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    noticeMsgLbl.hidden = YES;
    [navView addSubview:noticeMsgLbl];
    
    SelectedListTbl = [[UITableView alloc]init];
    SelectedListTbl.frame = CGRectMake(20, 80, 704-40, 768-80);
    SelectedListTbl.backgroundColor = [UIColor clearColor];
    [SelectedListTbl setDelegate:self];
    [SelectedListTbl setDataSource:self];
    [SelectedListTbl setSeparatorColor:[UIColor clearColor]];
    [SelectedListTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:SelectedListTbl];
    
    ////////////--------------------------------------------------------///////////
    
    addSponsorsView = [[UIView alloc]init];
    addSponsorsView.frame = CGRectMake(0, 768, 704, 768);
    addSponsorsView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    addSponsorsView.hidden = YES;
    [self.view addSubview:addSponsorsView];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [addSponsorsView addSubview:navView];
    
    
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
    
    [addSponsorsView addSubview:PTsearchBar];
    
    
    UIImageView * addnewImg = [[UIImageView alloc]init];
    addnewImg.frame =CGRectMake(635, 125, 40, 40);
    addnewImg.backgroundColor = [UIColor clearColor];
    addnewImg.image = [UIImage imageNamed:@"add_user"];
    [addSponsorsView addSubview:addnewImg];
    
    
    UIButton * addNew = [[UIButton alloc]init];
    addNew.frame = CGRectMake(625, 125, 90, 50);
    addNew.backgroundColor = [UIColor clearColor];
    [addNew addTarget:self action:@selector(addNewClick) forControlEvents:UIControlEventTouchUpInside];
    [addSponsorsView addSubview:addNew];
    
    sponsorsListTbl = [[UITableView alloc]init];
    sponsorsListTbl.frame = CGRectMake(20, 180, 704-40, 768-180);
    sponsorsListTbl.backgroundColor = [UIColor clearColor];
    [sponsorsListTbl setDelegate:self];
    [sponsorsListTbl setDataSource:self];
    [sponsorsListTbl setSeparatorColor:[UIColor clearColor]];
    [sponsorsListTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [addSponsorsView addSubview:sponsorsListTbl];
    
    //----------------------------addnewSponsor--------------------------//
    
    addNewSponsors = [[UIView alloc]init];
    addNewSponsors.frame = CGRectMake(0, 768, 704, 768);
    addNewSponsors.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    addNewSponsors.hidden = YES;
    [self.view addSubview:addNewSponsors];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 704, 80)];
    navView.backgroundColor = [UIColor blackColor];
    navView.userInteractionEnabled=YES;
    [addNewSponsors addSubview:navView];
    
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 704, 80);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"Add New Sponsors";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(10, 30, 100, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelNewViewClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:cancelBtn];
    
    
    sponsorDetailDict = [[NSMutableDictionary alloc]init];
    [sponsorDetailDict setValue:@"required" forKey:@"sponser_name"];
    [sponsorDetailDict setValue:@"required" forKey:@"website"];
    
    
    UIView * tempview=[[UIView alloc]init];
    tempview.frame = CGRectMake(30, 170, 704-60, 300);
    tempview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [addNewSponsors addSubview:tempview];
    
    int yy;
    yy = 30;
    
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

    
    yy = yy +80;
    
    UIView * webUrlView=[[UIView alloc]init];
    webUrlView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    webUrlView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:webUrlView];
    
    
    txtWebUrl=[[UITextField alloc]initWithFrame:CGRectMake(10 ,0,webUrlView.frame.size.width-20, 50)];
    txtWebUrl.textColor=[UIColor whiteColor];
    txtWebUrl.keyboardType=UIKeyboardTypeEmailAddress;
    txtWebUrl.textAlignment = NSTextAlignmentLeft;
    txtWebUrl.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtWebUrl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtWebUrl.delegate = self;
    txtWebUrl.placeholder = @"Enter WebSite URL";
    txtWebUrl.returnKeyType=UIReturnKeyNext;
    txtWebUrl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [txtWebUrl setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [webUrlView addSubview:txtWebUrl];
    
    websiteLbl = [[UILabel alloc]init];
    websiteLbl.frame = CGRectMake(webUrlView.frame.size.width/2+10, 10, webUrlView.frame.size.width/2-20, 30);
    websiteLbl.backgroundColor = [UIColor clearColor];
    websiteLbl.textColor = [UIColor yellowColor];
    websiteLbl.textAlignment = NSTextAlignmentRight;
    websiteLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [webUrlView addSubview:websiteLbl];
    
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
    
    fieldArray=[[NSArray alloc]init];
    fieldArray = [NSArray arrayWithObjects: txtName, txtWebUrl, nil];
    
    
    if (selectedSponsorList.count == 0)
    {
        noticeMsgLbl.hidden = NO;
    }
    else
    {
        noticeMsgLbl.hidden = YES;
        
    }
    
    detailArr = [[NSMutableArray alloc]init];
    
    NSMutableArray * tempCmptArr =[[NSMutableArray alloc] init];
    //tempCmptArr=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"TotalSponsors"] mutableCopy];
    
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
    for (int i = 0; i <[detailArr count]; i++)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        dict =[[detailArr objectAtIndex:i] mutableCopy];
        
        [dict setValue:@"NO" forKey:@"Check"];
        [detailArr replaceObjectAtIndex:i withObject:dict];
        
    }
    
    isClick  = NO;
    isClickNew  = NO;
    addSponsorArr = [[NSMutableArray alloc]init];
    
    if (isFromEdit)
    {
        selectedSponsorList=[[NSMutableArray alloc] init];
        selectedSponsorList = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedSponsor"];
        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary * tempDict in selectedSponsorList)
        {
            NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
            temp = [tempDict mutableCopy];
            
            [tempArr addObject:temp];
        }
        
        selectedSponsorList = tempArr;
        
        for (int i = 0; i <[selectedSponsorList count]; i++)
        {
            
            for (int j = 0; j<[detailArr count]; j++)
            {
                if ([[[selectedSponsorList objectAtIndex:i] valueForKey:@"sponser_name"] isEqualToString:[[detailArr objectAtIndex:j] valueForKey:@"sponser_name"]])
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    dict =[[detailArr objectAtIndex:j] mutableCopy];
                    [dict setValue:@"YES" forKey:@"Check"];
                    [detailArr replaceObjectAtIndex:j withObject:dict];
                }
                else
                {
                   
                }
            }
        
           
        }
        
        if (selectedSponsorList.count == 0)
        {
            noticeMsgLbl.hidden = NO;
        }
        else
        {
            noticeMsgLbl.hidden = YES;
        }

    }
    else
    {
       
        for (int i = 0; i <[detailArr count]; i++)
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            dict =[[detailArr objectAtIndex:i] mutableCopy];
            
            [dict setValue:@"NO" forKey:@"Check"];
            [detailArr replaceObjectAtIndex:i withObject:dict];
            
        }
    }
    
    [SelectedListTbl reloadData];
    
    // Do any additional setup after loading the view.
}
#pragma mark Button Click Event
#pragma mark Button Click Event
-(void)backBtnClick:(id)sender
{
    if (isFromAdd == YES)
    {
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"totalSponsor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)cancelBtnClick
{
    [PTsearchBar resignFirstResponder];
    [txtName resignFirstResponder];
    [txtWebUrl resignFirstResponder];
    
    sponsorNameLbl.text = @"";
    websiteLbl.text = @"";
    
    isClick=NO;
    
    
    [UIView transitionWithView:addSponsorsView
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [addSponsorsView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [addSponsorsView setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;
    
    
}
-(void)cancelNewViewClick
{
    [txtWebUrl resignFirstResponder];
    [txtName resignFirstResponder];
    
    sponsorNameLbl.text = @"";
    websiteLbl.text = @"";
    
    isClickNew=NO;
    
    
    [UIView transitionWithView:addNewSponsors
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [addNewSponsors setFrame:CGRectMake(0,768, 704, 768)];
                        }
                        else
                        {
                            [addNewSponsors setFrame:CGRectMake(0,768, 704, 768)];
                        }
                    }
                    completion:nil];
    
    ;
    
    
}
-(void)addBtnClick:(id)sender
{
    
    if (isClick==NO)
    {
        isClick=YES;
        addSponsorsView.hidden = NO;
        
        [UIView transitionWithView:addSponsorsView
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addSponsorsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            else
                            {
                                [addSponsorsView setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            
                            
                        }
                        completion:nil];
        
        
        ;
    }
    else
    {
        isClick=NO;
        
        
        [UIView transitionWithView:addSponsorsView
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addSponsorsView setFrame:CGRectMake(0,768, 704, 768)];
                            }
                            else
                            {
                                [addSponsorsView setFrame:CGRectMake(0,768, 704, 768)];
                            }
                        }
                        completion:nil];
        
        ;
        
    }
    
    
}
-(void)addNewClick
{
    
    if (isClickNew==NO)
    {
        isClickNew=YES;
        addNewSponsors.hidden = NO;
        
        [UIView transitionWithView:addNewSponsors
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addNewSponsors setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            else
                            {
                                [addNewSponsors setFrame:CGRectMake(0, 0, 704,768)];
                            }
                            
                            
                        }
                        completion:nil];
        
        
        ;
    }
    else
    {
        isClickNew=NO;
        
        
        [UIView transitionWithView:addNewSponsors
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [addNewSponsors setFrame:CGRectMake(0,768, 704, 768)];
                            }
                            else
                            {
                                [addNewSponsors setFrame:CGRectMake(0,768, 704, 768)];
                            }
                        }
                        completion:nil];
        
        ;
        
    }
    
    
}
-(void)saveBtnClick:(id)sender
{
    isFromAdd  = YES;
    [txtName resignFirstResponder];
    [txtWebUrl resignFirstResponder];

    [self cancelBtnClick];
    
    if (selectedSponsorList.count == 0)
    {
        noticeMsgLbl.hidden = NO;
    }
    else
    {
        noticeMsgLbl.hidden = YES;
        
    }
    
    [SelectedListTbl reloadData];
    int i = selectedSponsorList.count;
    NSString * str = [NSString stringWithFormat:@"%d",i];
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"totalSponsor"];
    [[NSUserDefaults standardUserDefaults] setValue:selectedSponsorList forKey:@"selectedSponsor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSponsor" object:nil];
    
}
-(void)saveUser
{
    [txtName resignFirstResponder];
    [txtWebUrl resignFirstResponder];

    
    
        NSLog(@"Yes Is IOS 8..");
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
    
        /*else if (![self validateUrl:[sponsorDetailDict valueForKey:@"website"]])
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
            
            for (int i = 0; i <[detailArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                dict =[[detailArr objectAtIndex:i] mutableCopy];
                
                [dict setValue:@"NO" forKey:@"Check"];
                [detailArr replaceObjectAtIndex:i withObject:dict];
                
                
            }
            [sponsorsListTbl reloadData];
            [self cancelNewViewClick];

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



#pragma mark TableView Methods
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
    
    if (tableView == SelectedListTbl)
    {
        if (isFromAdd)
        {
            return selectedSponsorList.count;
            
        }
        else
        {
            return selectedSponsorList.count;
        }
        
    }
    else
    {
        if (isSearching == YES)
        {
            return filteredContentArray.count;
        }
        else
        {
            return [detailArr count];
        }
        
    }
    return [detailArr count];
    
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
    
    if (tableView == SelectedListTbl)
    {
        
        cell.headerView.frame = CGRectMake(0, 0, sponsorsListTbl.frame.size.width, 60);
        cell.nameLbl.text = [[selectedSponsorList objectAtIndex:indexPath.row] valueForKey:@"sponser_name"];
        cell.webURL.text = [[selectedSponsorList objectAtIndex:indexPath.row] valueForKey:@"website"];
        
        
    }
    else
    {
        cell.webURL.frame = CGRectMake(380, 10, 240, 40);
        cell.checkImg.hidden = NO;
        if (isSearching)
        {
            cell.headerView.frame = CGRectMake(0, 0, sponsorsListTbl.frame.size.width, 60);
            
            cell.nameLbl.text = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"sponser_name"];
            cell.webURL.text = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"website"];
            
            
            if ([[[filteredContentArray  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white"];
                
            }
            else if ([[[filteredContentArray objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white-tick.png"];
                
                
            }
            
        }
        else
        {
            cell.headerView.frame = CGRectMake(0, 0, sponsorsListTbl.frame.size.width, 60);
            
            cell.nameLbl.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"sponser_name"];
            cell.webURL.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"website"];
            
            
            if ([[[detailArr  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white.png"];
                
            }
            else if ([[[detailArr objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white-tick.png"];
                
                
            }
        }
        
    }
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedRow = indexPath.row;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == SelectedListTbl)
    {
        
    }else
    {
        if (isSearching == YES)
        {
            if ([[[filteredContentArray  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                [[filteredContentArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"Check"];
            }
            else if ([[[filteredContentArray objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                [[filteredContentArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"Check"];
                
            }
        }
        else
        {
            if ([[[detailArr  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                [[detailArr objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"Check"];
                
            }
            else if ([[[detailArr objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                [[detailArr objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"Check"];
                
            }
        }
        NSMutableArray * testDict = [[NSMutableArray alloc]init];
        
        if (isSearching == YES)
        {
            testDict = [filteredContentArray mutableCopy];
        }
        else
        {
            testDict = [detailArr mutableCopy];
            
        }
        
        [selectedSponsorList removeAllObjects];
        
        for (int i = 0; i<[testDict count]; i++)
        {
            if ([[[testDict objectAtIndex:i] valueForKey:@"Check"] isEqualToString:@"YES"])
            {
                [selectedSponsorList addObject:[testDict objectAtIndex:i]];
            }
            else
            {
                
            }
        }
    }
       [sponsorsListTbl reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == SelectedListTbl)
    {
        return NO;
    }
    selectedRow = indexPath.row;
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        if (tableView==SelectedListTbl)
        {
            editingStyle = UITableViewCellEditingStyleNone;
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this Sponsor?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag = 4;
            [alert show];
            
            
           
        }
        
        
        NSLog(@"Deleted row.");
    }
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4)
    {
        if (buttonIndex == 0)
        {
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Sponsors_Table where sponser_id = '%@'",[[detailArr objectAtIndex:selectedRow] valueForKey:@"sponser_id"]];
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            [detailArr removeObjectAtIndex:selectedRow];
            
            [[NSUserDefaults standardUserDefaults] setObject:detailArr forKey:@"TotalSponsors"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [sponsorsListTbl reloadData];
        }
        else
        {
             [sponsorsListTbl reloadData];
        }
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
        
    }else
    {
        //        NSLog(@"Hello");
        searchBar.showsCancelButton = NO;
        [searchBar resignFirstResponder];
        isSearching = NO;
        [sponsorsListTbl reloadData];
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
    [sponsorsListTbl reloadData];
    [searchBar resignFirstResponder];
    
}

-(void)filterContentForSearchText:(NSString *)searchText
{
    // Remove all objects from the filtered search array
    [filteredContentArray removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sponser_name CONTAINS[cd] %@",searchText];
    
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
    
    [sponsorsListTbl reloadData];
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
        if (textField==txtWebUrl)
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
    if (textField == txtName)
    {
        sponsorNameLbl.hidden = YES;
        txtName.text = sponsorNameLbl.text;
        [sponsorDetailDict setValue:textField.text forKey:@"sponser_name"];
    }
    else if (textField == txtWebUrl)
    {
        websiteLbl.hidden = YES;
        txtWebUrl.text = websiteLbl.text;
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
    else if (textField == txtWebUrl)
    {
        websiteLbl.hidden = NO;
        websiteLbl.text = textField.text;
        [sponsorDetailDict setValue:textField.text forKey:@"website"];
        txtWebUrl.text=@"";
        
        
    }

    return YES;
}

- (void)didReceiveMemoryWarning {
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
