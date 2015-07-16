//
//  ParticipantsViewController.m
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "ParticipantsViewController.h"

@interface ParticipantsViewController ()

@end

@implementation ParticipantsViewController
@synthesize totalParticipantsArr,isFromDetail,eventId;
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    titleLbl.text = @"Participants";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    UIImageView * backimg = [[UIImageView alloc]init];
    backimg.frame = CGRectMake(20, 35, 12, 22);;
    backimg.image = [UIImage imageNamed:@"back.png"];
    [navView addSubview:backimg];
    
    
    backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 100, 80);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.hidden = YES;
    backBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:backBtn];
    
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
    
    participantListTbl =[[UITableView alloc] initWithFrame:CGRectMake(15, 80, 704-30, 768-80) style:UITableViewStylePlain];
    participantListTbl.backgroundColor = [UIColor clearColor];
    [participantListTbl setDelegate:self];
    [participantListTbl setDataSource:self];
    [participantListTbl setSeparatorColor:[UIColor clearColor]];
    [participantListTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    participantListTbl.showsVerticalScrollIndicator=NO;
    [self.view addSubview:participantListTbl];
    
    
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
    
    participantsDict = [[NSMutableDictionary alloc]init];
    [participantsDict setValue:@"required" forKey:@"email"];
    [participantsDict setValue:@"required" forKey:@"name"];
    [participantsDict setValue:@"required" forKey:@"country"];
    [participantsDict setValue:@"required" forKey:@"compititorNumber"];
    
    UIView * tempview=[[UIView alloc]init];
    // BY RAJU 9-7-2015
    
    tempview.frame = CGRectMake(30, 180, 704-60, 280);
    tempview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [addparticipants addSubview:tempview];
    
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
    
    // BY RAJU 9-7-2015
    
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
    
    // Do any additional setup after loading the view.
    
    isClick = NO;
    
    if (isFromDetail == YES)
    {
        addBtn.hidden = YES;
        addImg.hidden = YES;
        backBtn.hidden = NO;
        
        NSMutableArray * temp = [[NSMutableArray alloc]init];
        NSString * str = [NSString stringWithFormat:@"select * from EventParticipants_Table where event_id = '%@'",eventId];
        [[DataBaseManager dataBaseManager] execute:str resultsArray:temp];
        detailArr = [[NSMutableArray alloc]init];
        detailArr = temp;
    }
    else
    {
        
    }
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
            
            [[detailArr objectAtIndex:selectedRow] setObject:emailLbl.text forKey:@"emailId"];
            
            [[detailArr objectAtIndex:selectedRow] setObject:nameLbl.text forKey:@"name"];
            [[detailArr objectAtIndex:selectedRow] setObject:nationalityLbl.text forKey:@"country"];
            
            isedit=NO;
            [self cancelBtnClick];
            [participantListTbl reloadData];
            
        }
    }
    else if (isFromAdd)
    {
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
        // BY RAJU 9-7-2015
        /*
         else if ([[participantsDict valueForKey:@"compititorNumber"] isEqualToString:@""]||[[participantsDict valueForKey:@"compititorNumber"] isEqualToString:@"required"])
         {
         UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
         [altfname show];
         
         }*/
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
-(void)cancelBtnClick
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

-(void)deleteParticipants//jam15-07-2015
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"from_outside_event" forKey:@"action"];
    [dict setObject:[[detailArr objectAtIndex:selectedRow] valueForKey:@"user_id"] forKey:@"competitor_id"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"deleteCompititors";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/deleteCompititors" withParameters:dict];
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
                
                 [self cancelBtnClick];
                
            }
            
        }
        else
        {
            NSString * strMsg = [NSString stringWithFormat:@"%@",[[result valueForKey:@"result"]valueForKey:@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    else if ([[result valueForKey:@"commandName"] isEqualToString:@"deleteCompititors"])
    {
        //jam15-07-2015
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            NSString * deleteStr = [NSString stringWithFormat:@"delete from Participants_Table where user_id = '%@'",[[detailArr objectAtIndex:selectedRow] valueForKey:@"user_id"]];
            [[DataBaseManager dataBaseManager] execute:deleteStr];
            
            [detailArr removeObjectAtIndex:selectedRow];
            [[NSUserDefaults standardUserDefaults] setObject:detailArr forKey:@"TotalCompetitor"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [participantListTbl reloadData];
            
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
    
    cell.checkImg.hidden = YES;
    cell.headerView.frame = CGRectMake(0, 0, participantListTbl.frame.size.width, 60);
    cell.temp.frame=CGRectMake(100, 10, 150, 30);
    cell.nameLbl.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.idLbl.text =[[detailArr objectAtIndex:indexPath.row] valueForKey:@"compititorNumber"];
    // BY RAJU 9-7-2015
    cell.idLbl.hidden=YES;
    cell.temp.frame=CGRectMake(05, 10, 370, 40);
    
    // cell.flagImg.image =[UIImage imageNamed:[[detailArr objectAtIndex:indexPath.row] valueForKey:@"flag"]];
    
    cell.nationalityLbl.text = [[detailArr objectAtIndex:indexPath.row] valueForKey:@"country"];
    
    
    if (isFromDetail == YES)
    {
        cell.unverifiedLbl.hidden = YES;//jam15-07-2015.
    }
    else
    {
        //jam15-07-2015.
        
        if ([[[detailArr objectAtIndex:indexPath.row] valueForKey:@"verified"] isEqualToString:@"yes"])
        {
            cell.unverifiedLbl.hidden = YES;
        }
        else
        {
            cell.temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unvarified"]];
            cell.unverifiedLbl.hidden = NO;
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
    selectedRow = indexPath.row;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    if (isFromDetail == YES)
    {
        return NO;
    }
    selectedRow = indexPath.row;
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    if (isFromDetail == YES)
    {
        return NO;
    }
    else
    {
        
        UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            isedit=YES;
            selectedRow=indexPath.row;
            
            [self addBtnClick:nil];
            [participantListTbl setEditing:NO];
        }];
        moreAction.backgroundColor = [UIColor lightGrayColor];
        
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                              {
                                                  selectedRow=indexPath.row;
                                                  
                                                  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                                                  alert.tag = 5;
                                                  [alert show];
                                              }];
        
        return @[deleteAction, moreAction];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            // BY RAJU 9-7-2015
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this participant?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag = 5;
            [alert show];
            
        }
        
    }
}

#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            [self deleteParticipants]; //jam15-07-2015
        }
        else
        {
            [participantListTbl reloadData];
        }
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

#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (IS_IPAD) {
        
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
