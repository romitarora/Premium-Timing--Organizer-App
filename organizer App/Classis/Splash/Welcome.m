//
//  Welcome.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "Welcome.h"

@interface Welcome ()

@end

@implementation Welcome

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SPLASH-2-bg"]]];
    
    self.navigationController.navigationBar.hidden = YES;
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    signupDetailDict = [[NSMutableDictionary alloc]init];
    
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, 768-60, 1024, 60)];
    buttomView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    
    btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(buttomView.frame.size.width/2,0,buttomView.frame.size.width/2, 60)];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogin.layer.borderWidth=1.0f;
    btnLogin.layer.borderColor =[UIColor yellowColor].CGColor;
    btnLogin.backgroundColor=[UIColor clearColor];
    [buttomView addSubview:btnLogin];
    
    btnSingUp=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSingUp setFrame:CGRectMake(0,0,1024/2, 60)];
    [btnSingUp setTitle:@"SignUp" forState:UIControlStateNormal];
    [btnSingUp addTarget:self action:@selector(SingUp) forControlEvents:UIControlEventTouchUpInside];
    [btnSingUp.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    btnSingUp.layer.borderWidth=1.0f;
    btnSingUp.layer.borderColor =[UIColor yellowColor].CGColor;
    btnSingUp.backgroundColor=[UIColor clearColor];
    btnSingUp.titleLabel.textColor=[UIColor whiteColor];
    [btnSingUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttomView addSubview:btnSingUp];
    [self.view addSubview:buttomView];
    
    
    if (IS_IPAD)
    {
        buttomView.frame=CGRectMake(0,1024-60,1024, 60);
        [btnLogin setFrame:CGRectMake(0,0,1024/2, 60)];
        [btnSingUp setFrame:CGRectMake(1024/2,0,1024/2, 60)];
        lblTitle.frame=CGRectMake(25, 350, 1024-50, 200);
        lblTitle.font=[UIFont fontWithName:@"Century Gothic" size:25.0f];
        
        [[UIDevice currentDevice] orientation];
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft )
        {
            
            buttomView.frame=CGRectMake(0, 768-60,1024,60);
            [btnLogin setFrame:CGRectMake(1024/2,0,1024/2,60)];
            [btnSingUp setFrame:CGRectMake(0,0,1024/2,60)];
            lblTitle.font=[UIFont fontWithName:@"Century Gothic" size:25.0f];
        }
        else if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight )
        {
            buttomView.frame=CGRectMake(0, 768-60, 1024, 60);
            lblTitle.frame=CGRectMake(25, 200, 1024-50, 200);
            lblTitle.font=[UIFont systemFontOfSize:34.0];
            buttomView.frame=CGRectMake(0, 768-60, 1024, 60);
            [btnLogin setFrame:CGRectMake(1024/2, 0, 1024/2, 60)];
            [btnSingUp setFrame:CGRectMake(0, 0, 1024/2, 60)];
            lblTitle.font=[UIFont fontWithName:@"Century Gothic" size:25.0f];
        }
    }
    //=========================jam_03-06-2015 for sign up page start=======================//
    
    signupDetailDict = [[NSMutableDictionary alloc]init];
    [signupDetailDict setValue:@"required" forKey:@"firstName"];
    [signupDetailDict setValue:@"required" forKey:@"lastName"];
    [signupDetailDict setValue:@"required" forKey:@"emailId"];
    [signupDetailDict setValue:@"required" forKey:@"companyName"];
    [signupDetailDict setValue:@"required" forKey:@"contact"];
    [signupDetailDict setValue:@"required" forKey:@"address"];
    [signupDetailDict setValue:@"required" forKey:@"password"];
    [signupDetailDict setValue:@"required" forKey:@"conformPassword"];
    
    
    signUpbackImg = [[UIView alloc]init];
    signUpbackImg.frame = CGRectMake(0, 768, 1024, 768);
    signUpbackImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay.png"]];
    // signUpbackImg.image = [UIImage imageNamed:@"overlay.png"];
    signUpbackImg.hidden = YES;
    [self.view addSubview:signUpbackImg];
    
    signUpView = [[UIView alloc]init];
    signUpView.frame = CGRectMake(150, 50, signUpbackImg.frame.size.width-300, 650);
    signUpView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [signUpbackImg addSubview:signUpView];
    
    UIColor *color = [UIColor lightGrayColor];
    
    
    scrollview = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:
                  CGRectMake(0 , 70, signUpView.frame.size.width, signUpView.frame.size.height-40)];
    
    scrollview.backgroundColor = [UIColor clearColor];
    scrollview.contentSize = CGSizeMake(signUpView.frame.size.width,
                                        signUpView.frame.size.height+200);
    scrollview.delegate = self;
    scrollview.userInteractionEnabled = YES;
    scrollview.scrollEnabled = NO;
    [signUpView addSubview:scrollview];
    
    UILabel * headerName = [[UILabel alloc]init];
    headerName.frame = CGRectMake(0, 30, scrollview.frame.size.width, 30);
    headerName.text = @"CREATE AN ACCOUNT";
    headerName.backgroundColor = [UIColor clearColor];
    headerName.textColor = [UIColor whiteColor];
    headerName.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    headerName.textAlignment = NSTextAlignmentCenter;
    [signUpView addSubview:headerName];
    
    
    yy = 10;
    
    UIView * tempfirst=[[UIView alloc]init];
    tempfirst.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    tempfirst.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:tempfirst];
    
    UIImageView * firstNameIcon = [[UIImageView alloc]init];
    firstNameIcon.backgroundColor = [UIColor clearColor];
    firstNameIcon.image  =[UIImage imageNamed:@"firstname"];
    firstNameIcon.frame = CGRectMake(05, 12.05, 25, 25);
    [tempfirst addSubview:firstNameIcon];
    
    txtfirstname=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,tempfirst.frame.size.width-50, 50)];
    txtfirstname.textColor=[UIColor whiteColor];
    // BY RAJU 9-7-2015
    txtfirstname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FIRST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtfirstname.textAlignment=NSTextAlignmentLeft;
    txtfirstname.returnKeyType=UIReturnKeyNext;
    txtfirstname.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtfirstname setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtfirstname.delegate = self;
    txtfirstname.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [tempfirst addSubview:txtfirstname];
    
    
    
    
    
    FirstNameLbl = [[UILabel alloc]init];
    FirstNameLbl.frame = CGRectMake(tempfirst.frame.size.width/2+10, 10, tempfirst.frame.size.width/2-20, 30);
    FirstNameLbl.backgroundColor = [UIColor clearColor];
    FirstNameLbl.textColor = [UIColor yellowColor];
    FirstNameLbl.textAlignment = NSTextAlignmentRight;
    FirstNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [tempfirst addSubview:FirstNameLbl];
    
    if ([[signupDetailDict valueForKey:@"firstName"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        FirstNameLbl.text = [signupDetailDict valueForKey:@"firstName"];
    }
    
    
    //textfield lastname
    
    yy = yy+60;
    
    UIView * lastview=[[UIView alloc]init];
    lastview.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    lastview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:lastview];
    
    UIImageView * lastNameIcon = [[UIImageView alloc]init];
    lastNameIcon.backgroundColor = [UIColor clearColor];
    lastNameIcon.image  =[UIImage imageNamed:@"firstname"];
    lastNameIcon.frame = CGRectMake(05, 12.05, 25, 25);
    [lastview addSubview:lastNameIcon];
    
    txtLastname=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,tempfirst.frame.size.width-50, 50)];
    txtLastname.textColor=[UIColor whiteColor];
    txtLastname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LAST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtLastname.textAlignment=NSTextAlignmentLeft;
    txtLastname.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtLastname setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtLastname.delegate = self;
    txtLastname.returnKeyType=UIReturnKeyNext;
    txtLastname.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [lastview addSubview:txtLastname];
    
    LastNameLbl = [[UILabel alloc]init];
    LastNameLbl.frame = CGRectMake(lastview.frame.size.width/2+10, 10, lastview.frame.size.width/2-20, 30);
    LastNameLbl.backgroundColor = [UIColor clearColor];
    LastNameLbl.textColor = [UIColor yellowColor];
    LastNameLbl.textAlignment = NSTextAlignmentRight;
    LastNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [lastview addSubview:LastNameLbl];
    
    if ([[signupDetailDict valueForKey:@"lastName"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        LastNameLbl.text = [signupDetailDict valueForKey:@"lastName"];
    }
    
    yy = yy+60;
    
    UIView * emailview=[[UIView alloc]init];
    emailview.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    emailview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:emailview];
    
    UIImageView * emailIcon = [[UIImageView alloc]init];
    emailIcon.backgroundColor = [UIColor clearColor];
    emailIcon.image  =[UIImage imageNamed:@"email"];
    emailIcon.frame = CGRectMake(05, 16, 25, 18);
    [emailview addSubview:emailIcon];
    
    txtemailId=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,emailview.frame.size.width-50, 50)];
    txtemailId.textColor=[UIColor whiteColor];
    txtemailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL ID" attributes:@{NSForegroundColorAttributeName: color}];
    txtemailId.keyboardType=UIKeyboardTypeEmailAddress;
    txtemailId.textAlignment = NSTextAlignmentLeft;
    txtemailId.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtemailId setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtemailId.delegate = self;
    txtemailId.returnKeyType=UIReturnKeyNext;
    txtemailId.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [emailview addSubview:txtemailId];
    
    EmailIdLbl = [[UILabel alloc]init];
    EmailIdLbl.frame = CGRectMake(emailview.frame.size.width/2+10, 10, emailview.frame.size.width/2-20, 30);
    EmailIdLbl.backgroundColor = [UIColor clearColor];
    EmailIdLbl.textColor = [UIColor yellowColor];
    EmailIdLbl.textAlignment = NSTextAlignmentRight;
    EmailIdLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [emailview addSubview:EmailIdLbl];
    
    if ([[signupDetailDict valueForKey:@"emailId"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        EmailIdLbl.text = [signupDetailDict valueForKey:@"emailId"];
    }
    
    
    yy = yy+60;
    
    //textfield userName
    
    UIView * CompanyNameView=[[UIView alloc]init];
    CompanyNameView.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    CompanyNameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:CompanyNameView];
    
    UIImageView * CompanyIcon = [[UIImageView alloc]init];
    CompanyIcon.backgroundColor = [UIColor clearColor];
    CompanyIcon.image  =[UIImage imageNamed:@"comapny-name"];
    CompanyIcon.frame = CGRectMake(05, 19, 22, 22);
    [CompanyNameView addSubview:CompanyIcon];
    
    txtCompanyName=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,scrollview.frame.size.width-50, 50)];
    txtCompanyName.textColor=[UIColor whiteColor];
    txtCompanyName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"COMPANY NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtCompanyName.textAlignment=NSTextAlignmentLeft;
    txtCompanyName.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtCompanyName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtCompanyName.delegate = self;
    txtCompanyName.returnKeyType=UIReturnKeyNext;
    txtCompanyName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [CompanyNameView addSubview:txtCompanyName];
    
    CompanyNameLbl = [[UILabel alloc]init];
    CompanyNameLbl.frame = CGRectMake(CompanyNameView.frame.size.width/2+10, 10, CompanyNameView.frame.size.width/2-20, 30);
    CompanyNameLbl.backgroundColor = [UIColor clearColor];
    CompanyNameLbl.textColor = [UIColor yellowColor];
    CompanyNameLbl.textAlignment = NSTextAlignmentRight;
    CompanyNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [CompanyNameView addSubview:CompanyNameLbl];
    
    if ([[signupDetailDict valueForKey:@"companyName"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        CompanyNameLbl.text = [signupDetailDict valueForKey:@"companyName"];
    }
    
    //textfield Contact No.
    yy = yy+60;
    
    UIView * contactView=[[UIView alloc]init];
    contactView.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    contactView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:contactView];
    
    UIImageView * contactIcon = [[UIImageView alloc]init];
    contactIcon.backgroundColor = [UIColor clearColor];
    contactIcon.image  =[UIImage imageNamed:@"contact"];
    contactIcon.frame = CGRectMake(05, 13, 15, 24);
    [contactView addSubview:contactIcon];
    
    txtcontactNo=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,scrollview.frame.size.width-0, 50)];
    txtcontactNo.textColor=[UIColor whiteColor];
    txtcontactNo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CONTACT NUMBER" attributes:@{NSForegroundColorAttributeName: color}];
    txtcontactNo.textAlignment=NSTextAlignmentLeft;
    txtcontactNo.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtcontactNo setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtcontactNo.delegate = self;
    txtcontactNo.returnKeyType=UIReturnKeyNext;
    txtcontactNo.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    txtcontactNo.keyboardType = UIKeyboardTypeNumberPad;
    [contactView addSubview:txtcontactNo];
    
    ContactNoLbl = [[UILabel alloc]init];
    ContactNoLbl.frame = CGRectMake(contactView.frame.size.width/2+10, 10, contactView.frame.size.width/2-20, 30);
    ContactNoLbl.backgroundColor = [UIColor clearColor];
    ContactNoLbl.textColor = [UIColor yellowColor];
    ContactNoLbl.textAlignment = NSTextAlignmentRight;
    ContactNoLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [contactView addSubview:ContactNoLbl];
    
    if ([[signupDetailDict valueForKey:@"contact"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        ContactNoLbl.text = [signupDetailDict valueForKey:@"contact"];
    }
    
    yy = yy+60;
    
    //textfield Address.
    
    
    UIView * addressView=[[UIView alloc]init];
    addressView.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    addressView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:addressView];
    
    UIImageView * addressIcon = [[UIImageView alloc]init];
    addressIcon.backgroundColor = [UIColor clearColor];
    addressIcon.image  =[UIImage imageNamed:@"address"];
    addressIcon.frame = CGRectMake(05, 12.05, 19, 25);
    [addressView addSubview:addressIcon];
    
    txtaddress=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,scrollview.frame.size.width-50, 50)];
    txtaddress.textColor=[UIColor whiteColor];
    txtaddress.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ADDRESS" attributes:@{NSForegroundColorAttributeName: color}];
    txtaddress.textAlignment=NSTextAlignmentLeft;
    txtaddress.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtaddress setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtaddress.delegate = self;
    txtaddress.returnKeyType=UIReturnKeyNext;
    // txtaddress.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtaddress.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [addressView addSubview:txtaddress];
    
    
    AddressLbl = [[UILabel alloc]init];
    AddressLbl.frame = CGRectMake(addressView.frame.size.width/2+10, 10, addressView.frame.size.width/2-20, 30);
    AddressLbl.backgroundColor = [UIColor clearColor];
    AddressLbl.textColor = [UIColor yellowColor];
    AddressLbl.textAlignment = NSTextAlignmentRight;
    AddressLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [addressView addSubview:AddressLbl];
    
    if ([[signupDetailDict valueForKey:@"address"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        AddressLbl.text = [signupDetailDict valueForKey:@"address"];
    }
    
    
    yy = yy+60;
    
    //textfield Password
    
    UIView * passwordView=[[UIView alloc]init];
    passwordView.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    passwordView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:passwordView];
    
    UIImageView * passwordIcon = [[UIImageView alloc]init];
    passwordIcon.backgroundColor = [UIColor clearColor];
    passwordIcon.image  =[UIImage imageNamed:@"password"];
    passwordIcon.frame = CGRectMake(05, 12.05, 21, 25);
    [passwordView addSubview:passwordIcon];
    
    
    txtPassword=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,passwordView.frame.size.width-50, 50)];
    txtPassword.textColor=[UIColor whiteColor];
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    txtPassword.textAlignment=NSTextAlignmentLeft;
    txtPassword.secureTextEntry=YES;
    txtPassword.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtPassword setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtPassword.delegate = self;
    txtPassword.returnKeyType=UIReturnKeyNext;
    // txtPassword.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtPassword.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [passwordView addSubview:txtPassword];
    
    PasswordLbl = [[UITextField alloc]init];
    PasswordLbl.frame = CGRectMake(passwordView.frame.size.width/2+10, 10, passwordView.frame.size.width/2-20, 30);
    PasswordLbl.backgroundColor = [UIColor clearColor];
    PasswordLbl.textColor = [UIColor yellowColor];
    PasswordLbl.textAlignment = NSTextAlignmentRight;
    PasswordLbl.secureTextEntry=YES;
    PasswordLbl.userInteractionEnabled = NO;
    PasswordLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [passwordView addSubview:PasswordLbl];
    
    if ([[signupDetailDict valueForKey:@"password"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        PasswordLbl.text = [signupDetailDict valueForKey:@"password"];
    }
    
    
    //textfield Conform Password
    yy = yy+60;
    
    UIView * ConformPassView=[[UIView alloc]init];
    ConformPassView.frame =CGRectMake(20 ,yy,scrollview.frame.size.width-40, 50);
    ConformPassView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollview addSubview:ConformPassView];
    
    UIImageView * ConformPassIcon = [[UIImageView alloc]init];
    ConformPassIcon.backgroundColor = [UIColor clearColor];
    ConformPassIcon.image  =[UIImage imageNamed:@"password"];
    ConformPassIcon.frame = CGRectMake(05, 12.05, 21, 25);
    [ConformPassView addSubview:ConformPassIcon];
    
    
    txtConformPass=[[UITextField alloc]initWithFrame:CGRectMake(50,0,ConformPassView.frame.size.width-50, 50)];
    txtConformPass.textColor=[UIColor whiteColor];
    txtConformPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CONFIRM PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    txtConformPass.textAlignment=NSTextAlignmentLeft;
    txtConformPass.secureTextEntry=YES;
    txtConformPass.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtConformPass setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtConformPass.delegate = self;
    // txtConformPass.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtConformPass.returnKeyType=UIReturnKeyDone;
    txtConformPass.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [ConformPassView addSubview:txtConformPass];
    
    ConformPassLbl = [[UITextField alloc]init];
    ConformPassLbl.frame = CGRectMake(ConformPassView.frame.size.width/2+10, 10, ConformPassView.frame.size.width/2-20, 30);
    ConformPassLbl.backgroundColor = [UIColor clearColor];
    ConformPassLbl.textColor = [UIColor yellowColor];
    ConformPassLbl.textAlignment = NSTextAlignmentRight;
    ConformPassLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    ConformPassLbl.secureTextEntry=YES;
    ConformPassLbl.userInteractionEnabled = NO;
    [ConformPassView addSubview:ConformPassLbl];
    
    if ([[signupDetailDict valueForKey:@"conformPassword"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        ConformPassLbl.text = [signupDetailDict valueForKey:@"conformPassword"];
    }
    
    
    registeredBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [registeredBtn setFrame:CGRectMake(0,signUpView.frame.size.height-50, scrollview.frame.size.width, 50)];
    [registeredBtn setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [registeredBtn addTarget:self action:@selector(registeredClick) forControlEvents:UIControlEventTouchUpInside];
    registeredBtn.backgroundColor=[UIColor clearColor];
    [registeredBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam
    [registeredBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    registeredBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [signUpView addSubview:registeredBtn];
    
    
    fieldArray=[[NSArray alloc]init];
    fieldArray = [NSArray arrayWithObjects: txtfirstname, txtLastname,txtemailId,txtCompanyName,txtcontactNo,txtaddress,txtPassword,txtConformPass, nil];
    
    
    //=========================jam_03-06-2015 for sign up page stop=======================//
    
    
    //=========================jam_03-06-2015 for login page start=======================//
    
    loginbackImg = [[UIView alloc]init];
    loginbackImg.frame = CGRectMake(0, 768, 1024, 768);
    loginbackImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay.png"]];
    loginbackImg.hidden = YES;
    [self.view addSubview:loginbackImg];
    
    loginView = [[UIView alloc]init];
    loginView.frame = CGRectMake(150, 100, loginbackImg.frame.size.width-300, 400);
    loginView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [loginbackImg addSubview:loginView];
    
    UILabel * loginHeader = [[UILabel alloc]init];
    loginHeader.frame = CGRectMake(0, 30, scrollview.frame.size.width, 30);
    loginHeader.text = @"LOGIN HERE";
    loginHeader.backgroundColor = [UIColor clearColor];
    loginHeader.textColor = [UIColor whiteColor];
    loginHeader.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    loginHeader.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:loginHeader];
    
    
    
    yy = 80;
    
    UIView * emailLoginView=[[UIView alloc]init];
    emailLoginView.frame =CGRectMake(20 ,yy,loginView.frame.size.width-40, 50);
    emailLoginView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [loginView addSubview:emailLoginView];
    
    UIImageView * idIcon = [[UIImageView alloc]init];
    idIcon.backgroundColor = [UIColor clearColor];
    idIcon.image  =[UIImage imageNamed:@"email"];
    idIcon.frame = CGRectMake(05, 16, 25, 18);
    [emailLoginView addSubview:idIcon];
    
    txtLoginId=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,emailLoginView.frame.size.width-50, 50)];
    txtLoginId.textColor=[UIColor whiteColor];
    txtLoginId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL ID" attributes:@{NSForegroundColorAttributeName: color}];
    txtLoginId.keyboardType=UIKeyboardTypeEmailAddress;
    txtLoginId.textAlignment = NSTextAlignmentLeft;
    txtLoginId.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtLoginId setFont:[UIFont boldSystemFontOfSize:12]];
    txtLoginId.delegate = self;
    txtLoginId.returnKeyType=UIReturnKeyNext;
    // txtemailId.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtLoginId.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [emailLoginView addSubview:txtLoginId];
    
    
    
    yy = yy +60;
    
    UIView * passLoginView=[[UIView alloc]init];
    passLoginView.frame =CGRectMake(20 ,yy,loginView.frame.size.width-40, 50);
    passLoginView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [loginView addSubview:passLoginView];
    
    UIImageView * passIcon = [[UIImageView alloc]init];
    passIcon.backgroundColor = [UIColor clearColor];
    passIcon.image  =[UIImage imageNamed:@"password"];
    passIcon.frame = CGRectMake(05, 12.05, 21, 25);
    [passLoginView addSubview:passIcon];
    
    //textfield For Password
    
    txtLoginPassword=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,passLoginView.frame.size.width-50, 50)];
    txtLoginPassword.textColor=[UIColor whiteColor];
    txtLoginPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    txtLoginPassword.textAlignment=NSTextAlignmentLeft;
    txtLoginPassword.secureTextEntry=YES;
    txtLoginPassword.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtLoginPassword setFont:[UIFont boldSystemFontOfSize:12]];
    txtLoginPassword.delegate = self;
    //txtLoginPassword.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtLoginPassword.returnKeyType=UIReturnKeyDone;
    txtLoginPassword.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [passLoginView addSubview:txtLoginPassword];
    
    
    yy = yy +90;
    
    LoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [LoginBtn setFrame:CGRectMake(0, yy, loginView.frame.size.width, 50)];
    [LoginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
    [LoginBtn addTarget:self action:@selector(login_login) forControlEvents:UIControlEventTouchUpInside];
    [LoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam
    [LoginBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    LoginBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [loginView addSubview:LoginBtn];
    
    yy = yy+60;
    
    BtnForget=[UIButton buttonWithType:UIButtonTypeCustom];
    [BtnForget setFrame:CGRectMake(230, yy,loginView.frame.size.width-460, 30)];
    [BtnForget setTitle:@"FORGET PASSWORD ?" forState:UIControlStateNormal];
    [BtnForget setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BtnForget.titleLabel setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    [BtnForget addTarget:self action:@selector(forgot) forControlEvents:UIControlEventTouchUpInside];
    BtnForget.backgroundColor = [UIColor clearColor];
    [loginView addSubview:BtnForget];
    
    yy = yy+70;
    
    UILabel * accountLbl = [[UILabel alloc]init];
    accountLbl.frame = CGRectMake(60, yy,300, 30);
    accountLbl.text = @"NEW TO PREMIUM TIMING ?";
    accountLbl.textAlignment = NSTextAlignmentLeft;
    accountLbl.backgroundColor = [UIColor clearColor];
    accountLbl.textColor = [UIColor whiteColor];
    [accountLbl setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    [loginView addSubview:accountLbl];
    
    
    
    // BY RAJU 9-7-2015
    
    UIButton *btnnew=[UIButton buttonWithType:UIButtonTypeCustom];
    btnnew.frame=CGRectMake(60, yy, 300, 30);
    //    btnnew.backgroundColor=[UIColor grayColor];
    [btnnew addTarget:self action:@selector(SingUp_Login) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:btnnew];
    
    
    
    SignUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [SignUpBtn setFrame:CGRectMake(350, yy-10, 350, 50)];
    [SignUpBtn setTitle:@"CREATE AN ACCOUNT" forState:UIControlStateNormal];
    [SignUpBtn addTarget:self action:@selector(SingUp_Login) forControlEvents:UIControlEventTouchUpInside];
    SignUpBtn.backgroundColor=[UIColor clearColor];
    SignUpBtn.titleLabel.textColor=[UIColor yellowColor];
    [SignUpBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];//jam
    [SignUpBtn.titleLabel setFont: [UIFont fontWithName:@"Century Gothic" size:20.0f]];
    [loginView addSubview:SignUpBtn];
    
    
    signCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signCloseBtn.frame = CGRectMake(10, 10, 30, 30);
    signCloseBtn.backgroundColor = [UIColor clearColor];
    [signCloseBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [signCloseBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [signUpView addSubview:signCloseBtn];
    [signCloseBtn bringSubviewToFront:signUpbackImg];
    
    loginCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginCloseBtn.frame = CGRectMake(10, 10, 30, 30);
    loginCloseBtn.backgroundColor = [UIColor clearColor];
    [loginCloseBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginCloseBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [loginView addSubview:loginCloseBtn];
    
    [loginCloseBtn bringSubviewToFront:loginbackImg];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUpcomingEventList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpcomingEventList) name:@"getUpcomingEventList" object:nil];
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark Button Click
-(void)loginBtnClick
{
    btnSingUp.enabled = NO;
    btnLogin.enabled = NO;
    
    loginbackImg.hidden = NO;
    
    isFromLoginBtn = YES;
    scrollview.hidden = NO;
    if (isFromSignUp == YES)
    {
        isFromSignUp = NO;
        txtLoginId.text = EmailIdLbl.text;
        txtLoginPassword.text = PasswordLbl.text;
    }
    else
    {
        txtLoginPassword.text = @"";
        txtLoginId.text = @"";
    }
    
    
    
    if (isClick==NO)
    {
        isClick=YES;
        
        // BY RAJU 9-7-2015
        loginbackImg.frame=CGRectMake(0,768, 1024,768);
        
        [UIView transitionWithView:loginbackImg
                          duration:0.45
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [loginbackImg setFrame:CGRectMake(0, 0, 1024,768)];
                            }
                            else
                            {
                                [loginbackImg setFrame:CGRectMake(0, 0, 1024,768)];
                            }
                            
                            
                        }
                        completion:nil];
        
        
        ;
    }
    else
    {
        isClick=NO;
        
        
        [UIView transitionWithView:loginbackImg
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [loginbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                            else
                            {
                                [loginbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                        }
                        completion:nil];
        
        ;
        
    }
    
    
}
-(void)SingUp
{
    txtfirstname.text = @"";
    txtLastname.text = @"";
    txtemailId.text = @"";
    txtcontactNo.text = @"";
    txtPassword.text =@"";
    txtConformPass.text = @"";
    txtaddress.text = @"";
    txtCompanyName.text = @"";
    
    btnSingUp.enabled = NO;
    btnLogin.enabled = NO;
    signUpbackImg.hidden = NO;
    isFromLoginBtn = NO;
    scrollview.hidden = NO;
    
    if (isClick==NO)
    {
        isClick=YES;
        
        [UIView transitionWithView:signUpbackImg
                          duration:0.30
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [signUpbackImg setFrame:CGRectMake(0, 0, 1024,768)];
                            }
                            else
                            {
                                [signUpbackImg setFrame:CGRectMake(0, 0, 1024,768)];
                            }
                            
                            
                        }
                        completion:nil];
        
        
        ;
    }
    else
    {
        isClick=NO;
        
        
        [UIView transitionWithView:signUpbackImg
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [signUpbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                            else
                            {
                                [signUpbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                        }
                        completion:nil];
        
        ;
        
    }
    
    
}
-(void)closeBtnClick:(id)sender
{
    
    [txtfirstname resignFirstResponder];
    [txtLastname resignFirstResponder];
    [txtemailId resignFirstResponder];
    [txtcontactNo resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConformPass resignFirstResponder];
    [txtaddress resignFirstResponder];
    [txtCompanyName resignFirstResponder];
    [txtLoginId resignFirstResponder];
    [txtLoginPassword resignFirstResponder];
    
    FirstNameLbl.text = @"";
    LastNameLbl.text = @"";
    EmailIdLbl.text = @"";
    CompanyNameLbl.text=@"";
    ContactNoLbl.text = @"";
    AddressLbl.text = @"";
    PasswordLbl.text = @"";
    ConformPassLbl.text = @"";
    
    
    btnSingUp.enabled = YES;
    btnLogin.enabled = YES;
    isClick=NO;
    if (isFromLoginBtn == YES)
    {
        [UIView transitionWithView:signUpbackImg
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [loginbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                            else
                            {
                                [loginbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                        }
                        completion:nil];
        
    }
    else
    {
        [UIView transitionWithView:signUpbackImg
                          duration:0.50
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [signUpbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                            else
                            {
                                [signUpbackImg setFrame:CGRectMake(0,768, 1024, 768)];
                            }
                        }
                        completion:nil];
        
    }
    
    
    
    
    // BY RAJU 9-7-2015
    //    scrollview.hidden = YES;
}
-(void)registeredClick
{
    
    if (FirstNameLbl.text.length==0)
    {
        
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter frist name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        
        [altfname show];
        
    }
    else if (LastNameLbl.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter last name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
        
    }
    else if(PasswordLbl.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
        
        
    }
    else if(ConformPassLbl.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter confirm password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
        
    }
    else if (![ConformPassLbl.text isEqualToString:PasswordLbl.text])
    {
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter both password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if(EmailIdLbl.text.length==0)
    {
        
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter email id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
    }
    else if ([self validateEmail:EmailIdLbl.text] ==NO)
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(AddressLbl.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
        
    }
    else
    {
        [app hudForprocessMethod:@"Registering..."];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[signupDetailDict valueForKey:@"firstName"] forKey:@"first_name"];
        [dict setValue:[signupDetailDict valueForKey:@"lastName"] forKey:@"last_name"];
        [dict setValue:[signupDetailDict valueForKey:@"emailId"] forKey:@"email"];
        [dict setValue:[signupDetailDict valueForKey:@"companyName"] forKey:@"company_name"];
        [dict setValue:[signupDetailDict valueForKey:@"contact"] forKey:@"contact"];
        [dict setValue:[signupDetailDict valueForKey:@"address"] forKey:@"address"];
        [dict setValue:[signupDetailDict valueForKey:@"password"] forKey:@"password"];
        
        NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
        if (deviceToken ==nil)
        {
            [dict setValue:@"123" forKey:@"token"];
        }
        else
        {
            [dict setValue:deviceToken forKey:@"token"];
        }
        
        
        [dict setValue:@"ios" forKey:@"device_type"];
        
        URLManager *manager = [[URLManager alloc] init];
        manager.commandName = @"signUp";
        manager.delegate = self;
        [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/signupOrganizer" withParameters:dict];
        
    }
    
}

#pragma mark Login Part

-(void)login_login
{
    if (txtLoginId.text.length == 0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter Email Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
    }
    else if ([self validateEmail:txtLoginId.text] ==NO)
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(txtLoginPassword.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
        
        
    }
    else
    {
        [txtLoginId resignFirstResponder];
        [txtLoginPassword resignFirstResponder];
        
        [app hudForprocessMethod:@"Loging..."];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setValue:txtLoginId.text forKey:@"email"];
        [dict setValue:txtLoginPassword.text forKey:@"password"];
        
        NSString *deviceToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
        if (deviceToken ==nil)
        {
            [dict setValue:@"123" forKey:@"token"];
        }
        else
        {
            [dict setValue:deviceToken forKey:@"token"];
        }
        
        
        [dict setValue:@"ios" forKey:@"device_type"];
        
        URLManager *manager = [[URLManager alloc] init];
        manager.commandName = @"login";
        manager.delegate = self;
        [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/login" withParameters:dict];
        
    }
    
    
}
-(void)SingUp_Login
{
    loginbackImg.hidden = YES;
    isClick=NO;
    [self SingUp];
}
-(void)forgot
{
    NSLog(@"Forgot Password");
    ForGotPassword *forgot=[[ForGotPassword alloc]init];
    [self.navigationController pushViewController:forgot animated:NO];
}
#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            isClick = NO;
            signUpbackImg.hidden = YES;
            isFromSignUp = YES;
            [[NSUserDefaults standardUserDefaults] setValue:signupDetailDict forKey:@"userDetail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self loginBtnClick];
            
        }
        else
        {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
            [UIView commitAnimations];
            Welcome *welcome=[[Welcome alloc]init];
            [self.navigationController pushViewController:welcome animated:NO];
            
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            AppDelegate * ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            splitViewController =[[UISplitViewController alloc] init];
            
            homeVC = [[UpComingEventVC alloc] init];
            mainNavController   = [[UINavigationController alloc] initWithRootViewController:homeVC];
            
            listViewController = [[Leftmenu alloc] init];
            listNavController   = [[UINavigationController alloc] initWithRootViewController:listViewController];
            listNavController.navigationBar.tintColor = [UIColor blackColor];
            listNavController.navigationBarHidden  = NO;
            
            splitViewController.viewControllers = [NSArray arrayWithObjects:listNavController,mainNavController, nil];
            splitViewController.delegate        = self;
            ap.window.rootViewController = splitViewController;
            
        }
        else
        {
            
        }
    }
    
}
- (CustomCalendarViewController *)demoController
{
    return [[CustomCalendarViewController alloc] init];
}

- (UINavigationController *)navigationController1
{
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}
#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtfirstname)
    {
        [txtLastname becomeFirstResponder];
    }
    else if (textField == txtLastname)
    {
        [txtemailId becomeFirstResponder];
    }
    else if (textField == txtemailId)
    {
        [txtCompanyName becomeFirstResponder];
    }
    else if (textField == txtCompanyName)
    {
        [txtcontactNo becomeFirstResponder];
    }
    else if (textField == txtcontactNo)
    {
        [txtaddress becomeFirstResponder];
    }
    else if (textField == txtaddress)
    {
        [txtPassword becomeFirstResponder];
    }
    else if (textField == txtPassword)
    {
        [txtConformPass becomeFirstResponder];
    }
    else if (textField == txtConformPass)
    {
        [textField resignFirstResponder];
    }
    if (textField == txtLoginId)
    {
        [txtLoginPassword becomeFirstResponder];
    }
    else if (textField == txtLoginPassword)
    {
        [self login_login];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtfirstname)
    {
        FirstNameLbl.hidden = YES;
        txtfirstname.text = FirstNameLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"firstName"];
        
    }
    else if (textField == txtLastname)
    {
        LastNameLbl.hidden = YES;
        txtLastname.text = LastNameLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"lastName"];
    }
    else if (textField == txtemailId)
    {
        EmailIdLbl.hidden = YES;
        txtemailId.text = EmailIdLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"emailId"];
    }
    else if (textField == txtCompanyName)
    {
        CompanyNameLbl.hidden = YES;
        txtCompanyName.text = CompanyNameLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"companyName"];
    }
    else if (textField == txtcontactNo)
    {
        ContactNoLbl.hidden = YES;
        txtcontactNo.text = ContactNoLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"contact"];
    }
    else if (textField == txtaddress)
    {
        AddressLbl.hidden = YES;
        txtaddress.text = AddressLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"address"];
    }
    else if (textField == txtPassword)
    {
        PasswordLbl.hidden = YES;
        txtPassword.text = PasswordLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"password"];
    }
    else if (textField == txtConformPass)
    {
        ConformPassLbl.hidden = YES;
        txtConformPass.text = ConformPassLbl.text;
        [signupDetailDict setValue:textField.text forKey:@"conformPassword"];
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (isFromLoginBtn)
    {
        if (textField == txtLoginId)
        {
            //            [txtLoginPassword becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
            loginView.frame = CGRectMake(150, 100, loginbackImg.frame.size.width-300, 400);
        }
        
    }
    else
    {
        if (textField == txtfirstname)
        {
            FirstNameLbl.hidden = NO;
            FirstNameLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"firstName"];
            txtfirstname.text = @"";
            
        }
        else if (textField == txtLastname)
        {
            LastNameLbl.hidden = NO;
            LastNameLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"lastName"];
            txtLastname.text = @"";
        }
        else if (textField == txtemailId)
        {
            EmailIdLbl.hidden = NO;
            EmailIdLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"emailId"];
            txtemailId.text = @"";
        }
        else if (textField == txtCompanyName)
        {
            CompanyNameLbl.hidden = NO;
            CompanyNameLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"companyName"];
            txtCompanyName.text = @"";
        }
        else if (textField == txtcontactNo)
        {
            ContactNoLbl.hidden = NO;
            ContactNoLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"contact"];
            txtcontactNo.text = @"";
        }
        else if (textField == txtaddress)
        {
            AddressLbl.hidden = NO;
            AddressLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"address"];
            txtaddress.text = @"";
        }
        else if (textField == txtPassword)
        {
            PasswordLbl.hidden = NO;
            PasswordLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"password"];
            txtPassword.text = @"";
        }
        else if (textField == txtConformPass)
        {
            ConformPassLbl.hidden = NO;
            ConformPassLbl.text = textField.text;
            [signupDetailDict setValue:textField.text forKey:@"conformPassword"];
            txtConformPass.text = @"";
            scrollview.frame =CGRectMake(0 , 70, signUpView.frame.size.width, signUpView.frame.size.height-40);
            
        }
        
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
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


#pragma mark
#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    [app hudEndProcessMethod];
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"signUp"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You have registered successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 5;
            [alert show];
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please check the details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"login"])
    {
        if ([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            loginDetailArr = [[NSMutableArray alloc]init];
            loginDetailArr = [[[result valueForKey:@"result"] valueForKey:@"data"]mutableCopy];
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[loginDetailArr valueForKey:@"first_name"] forKey:@"firstName"];
            [dict setValue:[loginDetailArr valueForKey:@"last_name"] forKey:@"lastName"];
            [dict setValue:[loginDetailArr valueForKey:@"email"] forKey:@"emailId"];
            [dict setValue:[loginDetailArr valueForKey:@"contact_no"] forKey:@"contact"];
            [dict setValue:[loginDetailArr valueForKey:@"company_name"] forKey:@"company"];
            [dict setValue:[loginDetailArr valueForKey:@"website_url"] forKey:@"website"];
            [dict setValue:[loginDetailArr valueForKey:@"fb_page_link"] forKey:@"socialLink"];
            [dict setValue:[loginDetailArr valueForKey:@"photo_url"] forKey:@"photo"];
            [dict setValue:@"required" forKey:@"eventCategory"];
            [dict setValue:[loginDetailArr valueForKey:@"address"] forKey:@"address"];
            [dict setValue:[loginDetailArr valueForKey:@"user_id"] forKey:@"user_id"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[loginDetailArr valueForKey:@"user_id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString * str = [NSString stringWithFormat:@"delete from Profile_Table"];
            [[DataBaseManager dataBaseManager] execute:str];
            [[DataBaseManager dataBaseManager] insertProfileDetail:dict];
            
            [self getSponsorsList];
            
            
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Logged in successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please check the details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getSponsors"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strsponsor = [NSString stringWithFormat:@"delete from Sponsors_Table"];
            [[DataBaseManager dataBaseManager] execute:strsponsor];
            
            for (int i = 0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                dict = [[[tempArr objectAtIndex:i] valueForKey:@"sponsers"] mutableCopy];
                
                [[DataBaseManager dataBaseManager] insertTotalSponsorsDetail:dict];
            }
            
        }
        else
        {
            
        }
        
        [self getRaceType];
        
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getRaceType"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strRace = [NSString stringWithFormat:@"delete from RaceType_Table"];
            [[DataBaseManager dataBaseManager] execute:strRace];
            
            for (int i = 0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                dict = [[[tempArr objectAtIndex:i] valueForKey:@"pt_race_type"] mutableCopy];
                
                [[DataBaseManager dataBaseManager] insertRaceTypeDetail:dict];
            }
            
        }
        else
        {
            
        }
        
        [self getEventCategory];
        
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getEventCategory"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strCategory = [NSString stringWithFormat:@"delete from EventCategory_Table"];
            [[DataBaseManager dataBaseManager] execute:strCategory];
            
            for (int i = 0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                dict = [[[tempArr objectAtIndex:i] valueForKey:@"pt_event_category"] mutableCopy];
                
                [[DataBaseManager dataBaseManager] insertEventCategoryDetail:dict];
            }
        }
        else
        {
            
        }
        
        [self getEventDevices];
        
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getEventDevices"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            NSString * strDevice = [NSString stringWithFormat:@"delete from EventDevices_Table"];
            [[DataBaseManager dataBaseManager] execute:strDevice];
            
            for (int i = 0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                dict = [[[tempArr objectAtIndex:i] valueForKey:@"pt_bluetooth_device_master"] mutableCopy];
                
                [[DataBaseManager dataBaseManager] insertEventDevicesDetail:dict];
            }
        }
        else
        {
            
        }
        
        [self getParticipantsList];
        
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getCompetitors"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strCategory = [NSString stringWithFormat:@"delete from Participants_Table"];
            [[DataBaseManager dataBaseManager] execute:strCategory];
            
            for (int i = 0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"user_id"] forKey:@"user_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"first_name"] forKey:@"name"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"email"] forKey:@"emailId"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"country"] forKey:@"country"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"pt_users"] valueForKey:@"competitor_number"] forKey:@"compititorNumber"];
                
                [dict setValue:@"yes" forKey:@"verified"];

                [[DataBaseManager dataBaseManager] insertTotalParticipantsDetail:dict];
            }
        }
        else
        {
            
        }
        
        [self getUpcomingEventList];
    }
    else if([[result valueForKey:@"commandName"] isEqualToString:@"getUpcomingEvents"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc]init];
            tempArr = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            
            NSString * strCategory = [NSString stringWithFormat:@"delete from Main_Table"];
            [[DataBaseManager dataBaseManager] execute:strCategory];
            
            for (int i = 0; i<[tempArr count]; i++)
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"event_id"] forKey:@"event_id"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"event_name"] forKey:@"event_name"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"location"] forKey:@"location"];
                
                
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"photo"]]]];
                
                [dict setValue:[imageData base64Encoding] forKey:@"photo"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"start_time"] forKey:@"start_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"end_time"] forKey:@"end_time"];
                
                [dict setValue:[[[tempArr objectAtIndex:i] valueForKey:@"event"] valueForKey:@"event_date"] forKey:@"event_date"];
                
                [dict setValue:[loginDetailArr valueForKey:@"first_name"] forKey:@"organiser_name"];//jam14-07-2015.
                
                
                [[DataBaseManager dataBaseManager] insertMainDetail:dict];
            }
        }
        else
        {
            
        }
    }
    
    
    
}
- (void)onError:(NSError *)error
{
    [app hudEndProcessMethod];
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

#pragma mark First Time call WebServices

-(void)getSponsorsList
{
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getSponsors";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getEventSponsers"];
}

-(void)getRaceType
{
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getRaceType";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getRaceType"];
}
-(void)getEventCategory
{
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getEventCategory";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getEventCategory"];
}
-(void)getEventDevices
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[loginDetailArr valueForKey:@"user_id"] forKey:@"user_id"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getEventDevices";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getEventOrganizerAssignDevices" withParameters:dict];
    
}

-(void)getParticipantsList
{
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getCompetitors";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/getCompetitors"];
}

-(void)getUpcomingEventList
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[loginDetailArr valueForKey:@"user_id"] forKey:@"user_id"];
    
    URLManager *manager = [[URLManager alloc] init];
    manager.commandName = @"getUpcomingEvents";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/organizerEvents" withParameters:dict];
    
}

@end
