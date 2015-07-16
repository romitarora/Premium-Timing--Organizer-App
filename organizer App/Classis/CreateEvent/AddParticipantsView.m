//
//  AddParticipantsView.m
//  organizer App
//
//  Created by Romit on 11/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "AddParticipantsView.h"
#import "participantListCell.h"
#import "ParticipantsViewController.h"
@interface AddParticipantsView ()

@end

@implementation AddParticipantsView
@synthesize selectedArr,isagainCome,isFromEdit;
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
    titleLbl.text = @"Participants";
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
    noticeMsgLbl.text = @"No participants. Please add participant click on add icon";
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
    
    UIView * tempview=[[UIView alloc]init];
    tempview.frame = CGRectMake(30, 100, 704-60, 400);
    tempview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [addNewComititor addSubview:tempview];
    
    int yy;
    yy = 20;
    
    UIView * emailview=[[UIView alloc]init];
    emailview.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    emailview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:emailview];
    
    
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
    nameView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    nameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:nameView];
    
    
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
    nationalityView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    nationalityView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:nationalityView];
    
    
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
    numberView.frame =CGRectMake(20 ,yy,tempview.frame.size.width-40, 50);
    numberView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [tempview addSubview:numberView];
    
    
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
    saveBtn.frame = CGRectMake(0, tempview.frame.size.height-50, tempview.frame.size.width, 50);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:22.0f];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tempview addSubview:saveBtn];
    
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
    // tempCmptArr=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"TotalCompetitor"] mutableCopy];
    
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
    
    if (isFromEdit)
    {
        selectedListArr=[[NSMutableArray alloc] init];
        
        selectedListArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"selected"];
        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary * tempDict in selectedListArr)
        {
            NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
            temp = [tempDict mutableCopy];
            
            [tempArr addObject:temp];
        }
        selectedListArr = tempArr;
        
        
        for (int i = 0; i <[selectedListArr count]; i++)
        {
            
            for (int j = 0; j<[detailArr count]; j++)
            {
                if ([[[selectedListArr objectAtIndex:i] valueForKey:@"name"] isEqualToString:[[detailArr objectAtIndex:j] valueForKey:@"name"]])
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
        if (selectedListArr.count == 0)
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
-(void)backBtnClick:(id)sender
{
    if (isFromAdd == YES)
    {
        
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"totalNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
-(void)addNewClick
{
    
    
    
    if (isClickNew==NO)
    {
        
        if (isedit)
        {
            
            isClickNew=YES;
            emailLbl.text=[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"emailId"];
            
            
            
            participantsDict = [[NSMutableDictionary alloc]init];
            [participantsDict setValue:[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"emailId"] forKey:@"email"];
            [participantsDict setValue:@"required" forKey:@"name"];
            [participantsDict setValue:[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"country"] forKey:@"country"];
            [participantsDict setValue:@"" forKey:@"compititorNumber"];
            
            
            
            emailLbl.text=[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"emailId"];
            
            nameLbl.text=[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"name"];
            nationalityLbl.text=[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"country"] ;
            
            numberIdLbl.text=[[selectedListArr objectAtIndex:selectedRow]valueForKey:@"compititorNumber"];
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
        
        if (selectedListArr.count == 0)
        {
            noticeMsgLbl.hidden = NO;
        }
        else
        {
            noticeMsgLbl.hidden = YES;
        }
        
        [SelectedListTbl reloadData];
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
        
        {
            
            [[selectedListArr objectAtIndex:selectedRow] setObject:emailLbl.text forKey:@"emailId"];
            
            [[selectedListArr objectAtIndex:selectedRow] setObject:nameLbl.text forKey:@"name"];
            [[selectedListArr objectAtIndex:selectedRow] setObject:nationalityLbl.text forKey:@"country"];
            
            [[selectedListArr objectAtIndex:selectedRow] setObject:numberIdLbl.text forKey:@"compititorNumber"];
            isedit=NO;
            [self cancelNewViewClick];
            [SelectedListTbl reloadData];
            
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
            [altfname show];
            
        }
        else if ([self validateEmail:[participantsDict valueForKey:@"email"]]==NO)
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [altfname show];
            
            
        }
        else if ([[participantsDict valueForKey:@"name"] isEqualToString:@""]||[[participantsDict valueForKey:@"name"] isEqualToString:@"required"])
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [altfname show];
        }
        else if ([[participantsDict valueForKey:@"country"] isEqualToString:@""]||[[participantsDict valueForKey:@"country"] isEqualToString:@"required"])
        {
            UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Nationality" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
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
            message.tag = 22;
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
            return selectedListArr.count;
            
        }
        else
        {
            return selectedListArr.count;
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
    
    if (tableView == SelectedListTbl)
    {
        
        cell.headerView.frame = CGRectMake(0, 0, participantListTbl.frame.size.width, 60);
        
        cell.nameLbl.text = [[selectedListArr objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        cell.idLbl.text =[[selectedListArr objectAtIndex:indexPath.row] valueForKey:@"compititorNumber"];
        
        
        // cell.flagImg.image =[UIImage imageNamed:[[selectedListArr objectAtIndex:indexPath.row] valueForKey:@"flag"]];
        cell.nationalityLbl.text =[[selectedListArr objectAtIndex:indexPath.row] valueForKey:@"country"];
        cell.checkImg.hidden = YES;
        
        if ([[[selectedListArr objectAtIndex:indexPath.row]valueForKey:@"verified"] isEqualToString:@"yes"])
        {
            cell.unverifiedLbl.hidden = YES;
        }
        else
        {
            cell.temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unvarified"]];
            cell.unverifiedLbl.hidden = NO;
        }

       cell.nationalityLbl.frame = CGRectMake(480, 10, 140, 40);
        
    }
    else
    {
        cell.checkImg.hidden = NO;
        
        if (isSearching)
        {
            cell.headerView.frame = CGRectMake(0, 0, participantListTbl.frame.size.width, 60);
            
            cell.nameLbl.text = [[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"name"];
            
            cell.idLbl.text =[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"compititorNumber"];
            
            // cell.flagImg.image =[UIImage imageNamed:[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"flag"]];
            
            
            
            cell.nationalityLbl.text =[[filteredContentArray objectAtIndex:indexPath.row] valueForKey:@"country"];
            
            cell.nationalityLbl.frame = CGRectMake(480, 10, 140, 40);
            
            if ([[[filteredContentArray  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white"];
                
            }
            else if ([[[filteredContentArray objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white-tick.png"];
                
                
            }
            
            if ([[[filteredContentArray objectAtIndex:indexPath.row]valueForKey:@"verified"] isEqualToString:@"yes"])
            {
                cell.unverifiedLbl.hidden = YES;
            }
            else
            {
                cell.temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unvarified"]];
                cell.unverifiedLbl.hidden = NO;
            }
            
        }
        else
        {
            cell.nationalityLbl.frame = CGRectMake(480, 10, 140, 40);
            
            cell.headerView.frame = CGRectMake(0, 0, participantListTbl.frame.size.width, 60);
            
            cell.nameLbl.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"name"];
            
            cell.idLbl.text =[[detailArr objectAtIndex:indexPath.row] valueForKey:@"compititorNumber"];
            
            // cell.flagImg.image =[UIImage imageNamed:[[detailArr objectAtIndex:indexPath.row] valueForKey:@"flag"]];
            
            cell.nationalityLbl.text =[[detailArr objectAtIndex:indexPath.row] valueForKey:@"country"];
            
            if ([[[detailArr  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white.png"];
                
            }
            else if ([[[detailArr objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                cell.checkImg.image =[UIImage imageNamed:@"white-tick.png"];
                
                
            }
            
            if ([[[detailArr  objectAtIndex:indexPath.row] objectForKey:@"compititorNumber"] isEqualToString:@"NA"])
            {
                cell.idLbl.hidden=YES;
                
            }
            else if ([[[detailArr objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"YES"])
            {
                cell.idLbl.hidden=NO;
                cell.idLbl.text=[[detailArr  objectAtIndex:indexPath.row] objectForKey:@"compititorNumber"];
                
                
            }
            
            if ([[[detailArr objectAtIndex:indexPath.row]valueForKey:@"verified"] isEqualToString:@"yes"])
            {
                cell.unverifiedLbl.hidden = YES;
            }
            else
            {
                cell.temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unvarified"]];
                cell.unverifiedLbl.hidden = NO;
            }
            
//
        }
        // BY RAJU 9-7-2015
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
    
    
    if (tableView == SelectedListTbl)
    {
        
    }
    else
    {
        if (isSearching == YES)
        {
            if ([[[filteredContentArray  objectAtIndex:indexPath.row] objectForKey:@"Check"] isEqualToString:@"NO"])
            {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Number !" message:@"Please enter Participant Number:" delegate:self cancelButtonTitle:@"Add" otherButtonTitles:@"Cancel", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                alertTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                alertTextField.placeholder = @" Enter Participant Number";
                selectedRow = indexPath.row;
                alert.tag=selectedRow;
                
                [alert show];
                
                
                //                [[filteredContentArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"Check"];
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
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Number !" message:@"Please enter Participant Number:" delegate:self cancelButtonTitle:@"Add" otherButtonTitles:@"Cancel", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                alertTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                alertTextField.placeholder = @" Enter Participant Number";
                selectedRow = indexPath.row;
                alert.tag=selectedRow;
                
                [alert show];
                //                [[detailArr objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"Check"];
                
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
        [selectedListArr removeAllObjects];
        
        for (int i = 0; i<[testDict count]; i++)
        {
            if ([[[testDict objectAtIndex:i] valueForKey:@"Check"] isEqualToString:@"YES"])
            {
                [selectedListArr addObject:[testDict objectAtIndex:i]];
            }
            else
            {
                
            }
        }
        
    }
    
    [participantListTbl reloadData];
}


// BY RAJU 9-7-2015

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    if (tableView == participantListTbl)
    {
        return NO;
    }
    else
    {
        
        UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            isedit=YES;
            selectedRow=indexPath.row;
            
            [self addNewClick];
            [participantListTbl setEditing:NO];
        }];
        moreAction.backgroundColor = [UIColor lightGrayColor];
        
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                              {
                                                  selectedRow=indexPath.row;
                                                  
                                                  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete this participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                                                  // BY RAJU 9-7-2015
                                                  alert.tag = 1111111;
                                                  [alert show];
                                                  
                                              }];
        
        return @[deleteAction, moreAction];
    }
}

// From Master/Detail Xcode template
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedRow = indexPath.row;
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete this participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        // BY RAJU 9-7-2015
        alert.tag = 1111111;
        [alert show];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
        
        
    }
}


// BY RAJU 9-7-2015
/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (tableView == participantListTbl)
 {
 return NO;
 }
 // Return YES - we will be able to delete all rows
 return YES;
 }
 
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 //remove the deleted object from your data source.
 //If your data source is an NSMutableArray, do this
 
 if (tableView==participantListTbl)
 {
 editingStyle = UITableViewCellEditingStyleNone;
 }
 else
 {
 UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure to delete this participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
 // BY RAJU 9-7-2015
 alert.tag = 1111111;
 [alert show];
 
 
 }
 
 
 NSLog(@"Deleted row.");
 }
 }
 */
#pragma mark AlertView Delegate

// BY RAJU 9-7-2015


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1111111)
    {
        if (buttonIndex == 0)
        {
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Sponsors_Table where sponser_id = '%@'",[selectedListArr valueForKey:@"sponser_id"]];
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            [selectedListArr removeObjectAtIndex:selectedRow];
            
            [[NSUserDefaults standardUserDefaults] setObject:selectedListArr forKey:@"TotalCompetitor"];
            
            [[NSUserDefaults standardUserDefaults] setValue:selectedListArr forKey:@"selected"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SelectedListTbl reloadData];
            [participantListTbl reloadData];
            
        }
        else
        {
            [participantListTbl reloadData];
        }
    }
    else if (alertView.tag == 22)
    {
        
    }
    else if (alertView.tag == selectedRow)
    {
        
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        [[detailArr objectAtIndex:alertView.tag] setObject:@"YES" forKey:@"Check"];
        [[detailArr objectAtIndex:alertView.tag]setObject:[[alertView textFieldAtIndex:0] text] forKey:@"compititorNumber"];
        
        
        
        NSMutableArray * testDict = [[NSMutableArray alloc]init];
        
        if (isSearching == YES)
        {
            testDict = [filteredContentArray mutableCopy];
        }
        else
        {
            testDict = [detailArr mutableCopy];
            
        }
        
        [selectedListArr removeAllObjects];
        
        for (int i = 0; i<[testDict count]; i++)
        {
            if ([[[testDict objectAtIndex:i] valueForKey:@"Check"] isEqualToString:@"YES"])
            {
                [selectedListArr addObject:[testDict objectAtIndex:i]];
            }
            else
            {
                
            }
        }
        
        [participantListTbl reloadData];
        
    }
    else
    {
        
    }
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
