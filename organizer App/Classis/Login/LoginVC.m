//
//  LoginVC.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC
@synthesize userNameStr,passwordStr;
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LOGIN-SCREEN-bg"]]];
    
    UIImageView *backImg = [[UIImageView alloc]init];
    backImg.frame = CGRectMake(15, 40, 12, 22);
    backImg.backgroundColor =[UIColor clearColor];
    backImg.image = [UIImage imageNamed:@"back.png"];
    [self.view addSubview:backImg];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 80, 80);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.navigationController.navigationBarHidden=YES;
    
    
    //textfield For userName
    NSInteger yy;
    yy = 300;
    
    txtusername=[[UITextField alloc]initWithFrame:CGRectMake(0 ,yy,self.view.frame.size.width, 50)];
    txtusername.textColor=[UIColor blackColor];
    UIColor *color = [UIColor grayColor];
    txtusername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USER NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtusername.textAlignment=NSTextAlignmentCenter;
    txtusername.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtusername setFont:[UIFont boldSystemFontOfSize:12]];
    txtusername.delegate = self;
    txtusername.returnKeyType=UIReturnKeyNext;
    txtusername.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtusername.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [self.view addSubview:txtusername];
    
    
    yy = yy +50;
    
    
    //textfield For Password
    
    txtPassword=[[UITextField alloc]initWithFrame:CGRectMake(0 ,yy,self.view.frame.size.width, 50)];
    txtPassword.textColor=[UIColor blackColor];
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    txtPassword.textAlignment=NSTextAlignmentCenter;
    txtPassword.secureTextEntry=YES;
    txtPassword.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtPassword setFont:[UIFont boldSystemFontOfSize:12]];
    txtPassword.delegate = self;
    txtPassword.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtPassword.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [self.view addSubview:txtPassword];
    
    
    yy = yy +80;
    
  
    
    
    
    btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(0, yy, self.view.frame.size.width, 50)];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(login_login) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    [self.view addSubview:btnLogin];
    
    yy = yy+60;
    
    BtnForget=[UIButton buttonWithType:UIButtonTypeCustom];
    [BtnForget setFrame:CGRectMake(0, yy, self.view.frame.size.width, 30)];
    [BtnForget setTitle:@"ForGot Password ?" forState:UIControlStateNormal];
    [BtnForget setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [BtnForget.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [BtnForget addTarget:self action:@selector(forgot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BtnForget];
    
    yy = yy+40;
    
    UILabel * accountLbl = [[UILabel alloc]init];
    accountLbl.frame = CGRectMake(0, yy, self.view.frame.size.width, 30);
    accountLbl.text = @"Need a new Account?";
    accountLbl.textAlignment = NSTextAlignmentCenter;
    accountLbl.backgroundColor = [UIColor clearColor];
    accountLbl.textColor = [UIColor blackColor];
    [accountLbl setFont:[UIFont systemFontOfSize:20.0f]];

    [self.view addSubview:accountLbl];
    
    yy = yy+40;
    
    btnSingUp=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSingUp setFrame:CGRectMake(400, yy, 224, 60)];
    [btnSingUp setTitle:@"Sign up now" forState:UIControlStateNormal];
    [btnSingUp addTarget:self action:@selector(SingUp_Login) forControlEvents:UIControlEventTouchUpInside];
    btnSingUp.backgroundColor=[UIColor clearColor];
    btnSingUp.titleLabel.textColor=[UIColor blackColor];
    [btnSingUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam
    [btnSingUp setBackgroundImage:[UIImage imageNamed:@"signup-btn"] forState:UIControlStateNormal];
    [btnSingUp.titleLabel setFont: [UIFont systemFontOfSize:20.0f]];
    [self.view addSubview:btnSingUp];


    
   /* buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
   
    buttomView.backgroundColor=[UIColor grayColor];
    
    
    btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 60)];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin setTitle:@"Login" forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(login_login) forControlEvents:UIControlEventTouchUpInside];
    
    btnLogin.layer.borderWidth=1.0f;
    btnLogin.backgroundColor=[UIColor blueColor];
    btnLogin.titleLabel.textColor=[UIColor blackColor];
    [btnLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam
    [buttomView addSubview:btnLogin];
    
    
    btnSingUp=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSingUp setFrame:CGRectMake(self.view.frame.size.width/2, 00, self.view.frame.size.width/2, 60)];
    [btnSingUp setTitle:@"SingUp" forState:UIControlStateNormal];
    [btnSingUp setTitle:@"SingUp" forState:UIControlStateHighlighted];
    btnSingUp.layer.borderWidth=1.0f;
    [btnSingUp addTarget:self action:@selector(SingUp_Login) forControlEvents:UIControlEventTouchUpInside];
    btnSingUp.backgroundColor=[UIColor whiteColor];
    btnSingUp.titleLabel.textColor=[UIColor blackColor];
    [btnSingUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam

    [buttomView addSubview:btnSingUp];
    [self.view addSubview:buttomView];*/
    
    
    
    // Do any additional setup after loading the view.

    
    
   /* if (IS_IPAD)
    {
        
        buttomView.frame=CGRectMake(0,1024-80,768, 80);
        [btnLogin setFrame:CGRectMake(0,0,768/2, 80)];
        [btnSingUp setFrame:CGRectMake(768/2, 0, 768/2, 80)];
        btnLogin.titleLabel.textColor=[UIColor blackColor];
        btnSingUp.titleLabel.textColor=[UIColor blackColor];
        txtusername.frame=CGRectMake(10 ,300,768-20, 80);
        txtPassword.frame=CGRectMake(10 ,400,768-20, 80);
        [BtnForget.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [BtnForget setFrame:CGRectMake(20, 480, 240, 63)];
        [txtusername setFont:[UIFont boldSystemFontOfSize:18]];
        [txtPassword setFont:[UIFont boldSystemFontOfSize:18]];

    
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            txtusername.frame=CGRectMake(10 ,200,1024-20, 80);
            txtPassword.frame=CGRectMake(10 ,300,1024-20, 80);
            BtnForget.frame=CGRectMake(10, 380,200, 60);
            [btnSingUp setFrame:CGRectMake(1024/2,0,1024/2,80)];
            [btnLogin setFrame:CGRectMake(0,0, 1024/2, 80)];
            btnLogin.titleLabel.textColor=[UIColor blackColor];
            btnSingUp.titleLabel.textColor=[UIColor blackColor];
            buttomView.frame=CGRectMake(0,768-80,1024,80);
        }
       else if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            txtusername.frame=CGRectMake(10 ,200,1024-20, 80);
            txtPassword.frame=CGRectMake(10 ,300,1024-20, 80);
            BtnForget.frame=CGRectMake(10, 380,200, 60);
            [btnSingUp setFrame:CGRectMake(1024/2,0, 1024/2,80)];
            [btnLogin setFrame:CGRectMake(0, 0, 1024/2,80)];
            btnLogin.titleLabel.textColor=[UIColor blackColor];
            btnSingUp.titleLabel.textColor=[UIColor blackColor];
            buttomView.frame=CGRectMake(0, 768-80, 1024,80);
        }

    }*/
    
    if (isFromSignUp == YES)
    {
        txtusername.text = userNameStr;
        txtPassword.text = passwordStr;
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
-(void)login_login
{
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Login successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
   // [self navigate];//jam
    
    //    LoginVC *login=[[LoginVC alloc]init];
//    [self.navigationController pushViewController:login animated:NO];
}
/*
-(void)navigate
{
    
    
    AppDelegate  *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    Leftmenu *leftMenuViewController = [[Leftmenu alloc] init];
    //Leftmenu *rightMenuViewController = [[Leftmenu alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:Nil];
    app.window.rootViewController = container;
    [app.window makeKeyAndVisible];
    
    
}
- (CustomCalendarViewController *)demoController
{
    return [[CustomCalendarViewController alloc] init];
}

- (UINavigationController *)navigationController
{
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}
*/
-(void)SingUp_Login
{
    SingUpVC *singUp=[[SingUpVC alloc]init];
    AppDelegate *ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:singUp];
    ap.window.rootViewController=nav;
    [ap.window makeKeyAndVisible];
}
-(void)forgot
{
    NSLog(@"Forgot Password");
    ForGotPassword *forgot=[[ForGotPassword alloc]init];
    [self.navigationController pushViewController:forgot animated:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txtusername)
    {
        [txtPassword becomeFirstResponder];
        
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"landscape");
        
        txtusername.frame=CGRectMake(10 ,200,1024-20, 80);
        txtPassword.frame=CGRectMake(10 ,300,1024-20, 80);
        BtnForget.frame=CGRectMake(10, 400,200, 60);
        [btnSingUp setFrame:CGRectMake(1024/2,0, 1024/2, 80)];
        [btnLogin setFrame:CGRectMake(0,0, 1024/2,80)];
        btnLogin.titleLabel.textColor=[UIColor blackColor];
        btnSingUp.titleLabel.textColor=[UIColor blackColor];
        buttomView.frame=CGRectMake(0, 768-80, 1024, 80);
//        lblTitle.frame=CGRectMake(25, 200, 1024-50, 200);
//
//        [btnLogin setFrame:CGRectMake(0, 10, 1024/2, 40)];
              //lblTitle.font=[UIFont systemFontOfSize:34.0];
        
        //        [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
        //
        //        [btnSingUp setTitle:@"SingUp" forState:UIControlStateNormal];
        
        //  [btnLogin setFrame:CGRectMake(0, 20,, 40)];
    }
    else
    {
        NSLog(@"Portrait");
        
        buttomView.frame=CGRectMake(0,1024-80,768, 80);
        [btnLogin setFrame:CGRectMake(0, 0,768/2, 80)];
        [btnSingUp setFrame:CGRectMake(768/2, 0, 768/2, 80)];
        btnLogin.titleLabel.textColor=[UIColor blackColor];
        btnSingUp.titleLabel.textColor=[UIColor blackColor];
        txtusername.frame=CGRectMake(10 ,300,768-20, 80);
        txtPassword.frame=CGRectMake(10 ,400,768-20, 80);
        [BtnForget.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [BtnForget setFrame:CGRectMake(20, 480, 240, 63)];
    }
    
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait ||
		interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        
    {
        return YES;
    }
    
	else {
		return NO;
	}
    
}
*/


@end
