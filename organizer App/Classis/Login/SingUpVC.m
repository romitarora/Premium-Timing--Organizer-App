//
//  SingUpVC.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "SingUpVC.h"
#import "Constant.h"

@interface SingUpVC ()

@end

@implementation SingUpVC

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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"SIGN-UP-SCREEN-bg"]];
    UIColor *color = [UIColor darkGrayColor];
      
    
    //self.navigationItem.title=@"Sing UP";
    
    // Scrooll View
    self.navigationController.navigationBarHidden=YES;
    
    UIImageView *backImg = [[UIImageView alloc]init];
    backImg.frame = CGRectMake(15, 40, 12, 22);
    backImg.backgroundColor =[UIColor clearColor];
    backImg.image = [UIImage imageNamed:@"back.png"];
   
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 80, 80);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    scrollview = [[UIScrollView alloc]initWithFrame:
                    CGRectMake(0 , 50, self.view.frame.size.width, self.view.frame.size.height)];
    scrollview.accessibilityActivationPoint = CGPointMake(100, 100);
    scrollview.minimumZoomScale = 0.5;
    scrollview.maximumZoomScale = 3;
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width,
                                          self.view.frame.size.height+200);
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    
    NSInteger yy;
    yy = 230;
    
    txtfristname=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtfristname.textColor=[UIColor blackColor];
    txtfristname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FRIST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtfristname.textAlignment=NSTextAlignmentCenter;
    txtfristname.returnKeyType=UIReturnKeyNext;
    txtfristname.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtfristname setFont:[UIFont boldSystemFontOfSize:12]];
    txtfristname.delegate = self;
    txtfristname.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtfristname.font = [UIFont systemFontOfSize:20.0f];

    [scrollview addSubview:txtfristname];

    
    //textfield lastname

    yy = yy+50;
    
    
    txtLastname=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtLastname.textColor=[UIColor blackColor];
    txtLastname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LAST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtLastname.textAlignment=NSTextAlignmentCenter;
    txtLastname.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtLastname setFont:[UIFont boldSystemFontOfSize:12]];
    txtLastname.delegate = self;
    txtLastname.returnKeyType=UIReturnKeyNext;
    txtLastname.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtLastname.font = [UIFont systemFontOfSize:20.0f];

    [scrollview addSubview:txtLastname];
    
    //textfield Email ID
    
    yy = yy+50;

    
    txtemailId=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtemailId.textColor=[UIColor blackColor];
    txtemailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL ID" attributes:@{NSForegroundColorAttributeName: color}];
    txtemailId.keyboardType=UIKeyboardTypeEmailAddress;
    txtemailId.textAlignment = NSTextAlignmentCenter;
    txtemailId.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtemailId setFont:[UIFont boldSystemFontOfSize:12]];
    txtemailId.delegate = self;
    txtemailId.returnKeyType=UIReturnKeyNext;
    txtemailId.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtemailId.font = [UIFont systemFontOfSize:20.0f];

    [scrollview addSubview:txtemailId];
    
    
    yy = yy+50;

    //textfield userName
    
    txtusername=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtusername.textColor=[UIColor blackColor];
       txtusername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtusername.textAlignment=NSTextAlignmentCenter;
    txtusername.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtusername setFont:[UIFont boldSystemFontOfSize:12]];
    txtusername.delegate = self;
    txtusername.returnKeyType=UIReturnKeyNext;
    txtusername.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtusername.font = [UIFont systemFontOfSize:20.0f];

    [scrollview addSubview:txtusername];
    
    //textfield Contact No.
    yy = yy+50;

    
    txtcontactNo=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtcontactNo.textColor=[UIColor blackColor];
    txtcontactNo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CONTACT NO." attributes:@{NSForegroundColorAttributeName: color}];
    txtcontactNo.textAlignment=NSTextAlignmentCenter;
    txtcontactNo.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtcontactNo setFont:[UIFont boldSystemFontOfSize:12]];
    txtcontactNo.delegate = self;
    txtcontactNo.returnKeyType=UIReturnKeyNext;
    txtcontactNo.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtcontactNo.font = [UIFont systemFontOfSize:20.0f];
    txtcontactNo.keyboardType = UIKeyboardTypeNumberPad;
    [scrollview addSubview:txtcontactNo];
    
    
    yy = yy+50;

    //textfield Address.
    
    txtaddress=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtaddress.textColor=[UIColor blackColor];
    txtaddress.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ADDRESS." attributes:@{NSForegroundColorAttributeName: color}];
    txtaddress.textAlignment=NSTextAlignmentCenter;
    txtaddress.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtaddress setFont:[UIFont boldSystemFontOfSize:12]];
    txtaddress.delegate = self;
    txtaddress.returnKeyType=UIReturnKeyNext;
    txtaddress.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtaddress.font = [UIFont systemFontOfSize:20.0f];

    [scrollview addSubview:txtaddress];
    
    yy = yy+50;

    
 
    //textfield Password
    
    txtPassword=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtPassword.textColor=[UIColor blackColor];
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    txtPassword.textAlignment=NSTextAlignmentCenter;
    txtPassword.secureTextEntry=YES;
    txtPassword.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtPassword setFont:[UIFont boldSystemFontOfSize:12]];
    txtPassword.delegate = self;
    txtPassword.returnKeyType=UIReturnKeyNext;
    txtPassword.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtPassword.font = [UIFont systemFontOfSize:20.0f];

    [scrollview addSubview:txtPassword];
    
      //textfield Conform Password
    yy = yy+50;

    
    txtConformPass=[[UITextField alloc]initWithFrame:CGRectMake(150 ,yy,self.view.frame.size.width-300, 50)];
    txtConformPass.textColor=[UIColor blackColor];
    txtConformPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CONFORM PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    txtConformPass.textAlignment=NSTextAlignmentCenter;
    txtConformPass.secureTextEntry=YES;
    txtConformPass.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtConformPass setFont:[UIFont boldSystemFontOfSize:12]];
    txtConformPass.delegate = self;
    txtConformPass.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"text-filed"]];
    txtConformPass.returnKeyType=UIReturnKeyNext;
    txtConformPass.font = [UIFont systemFontOfSize:20.0f];
    [scrollview addSubview:txtConformPass];
    
    
    [self.view addSubview:scrollview];
    
    btnSingUp=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSingUp setFrame:CGRectMake(150,self.view.frame.size.height-60, self.view.frame.size.width-300, 60)];
    [btnSingUp setTitle:@"SignUp" forState:UIControlStateNormal];
    [btnSingUp addTarget:self action:@selector(SingUp) forControlEvents:UIControlEventTouchUpInside];
    btnSingUp.backgroundColor=[UIColor clearColor];
    [btnSingUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam
    [btnSingUp setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    btnSingUp.titleLabel.font = [UIFont systemFontOfSize:20.0f];

    [self.view addSubview:btnSingUp];
   
    
    
   /* buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    
    btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(0, 0, self.view.frame.size.width/2,60)];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin setTitle:@"Login" forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    btnLogin.layer.borderWidth=1.0f;
    btnLogin.backgroundColor=[UIColor whiteColor];
    btnLogin.titleLabel.textColor=[UIColor blackColor];
    [btnLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam

    [buttomView addSubview:btnLogin];
    
    
    
    btnSingUp=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSingUp setFrame:CGRectMake(self.view.frame.size.width/2,0, self.view.frame.size.width/2, 60)];
    [btnSingUp setTitle:@"SingUp" forState:UIControlStateNormal];
    [btnSingUp setTitle:@"SingUp" forState:UIControlStateHighlighted];
    btnSingUp.layer.borderWidth=1.0f;
    [btnSingUp addTarget:self action:@selector(SingUp) forControlEvents:UIControlEventTouchUpInside];
    btnSingUp.backgroundColor=[UIColor blueColor];
    btnSingUp.titleLabel.textColor=[UIColor blackColor];
    [btnSingUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//jam

    [buttomView addSubview:btnSingUp];
    [self.view addSubview:buttomView];*/

    
    
    
  
    
   /* if (IS_IPAD) {

        
        
        scrollview .frame=CGRectMake(0 , 0, 768, 1024);
        txtfristname.frame=CGRectMake(10,40,768-20, 80);
        txtfristname.font=[UIFont systemFontOfSize:24];
        txtLastname.frame=CGRectMake(10,140, 768-20, 80);
        txtLastname.font=[UIFont systemFontOfSize:24];
        txtemailId.frame=CGRectMake(10, 240, 768-20, 80);
        txtemailId.font=[UIFont systemFontOfSize:24];
        txtusername.frame=CGRectMake(10,340, 768-20, 80);
        txtusername.font=[UIFont systemFontOfSize:24];
        txtcontactNo.frame=CGRectMake(10,440, 768-20, 80);
        txtcontactNo.font=[UIFont systemFontOfSize:24];
        txtaddress.frame=CGRectMake(10,540, 768-20, 80);
        txtaddress.font=[UIFont systemFontOfSize:24];
        txtPassword.frame=CGRectMake(10,640,768-20, 80);
        txtPassword.font=[UIFont systemFontOfSize:24];
        txtConformPass.frame=CGRectMake(10,740,768-20,80);
        txtConformPass.font=[UIFont systemFontOfSize:24];
        buttomView.frame=CGRectMake(0,1024-80,768, 80);
        [btnLogin setFrame:CGRectMake(0,0,768/2, 80)];
        [btnSingUp setFrame:CGRectMake(768/2, 0, 768/2, 80)];
        
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            scrollview .frame=CGRectMake(0 , 0, 1024,768-80);
            txtfristname.frame=CGRectMake(10,40,1024-20, 80);
            txtLastname.frame=CGRectMake(10,140,1024-20, 80);
            txtemailId.frame=CGRectMake(10, 240,1024-20, 80);
            txtusername.frame=CGRectMake(10,340,1024-20, 80);
            txtcontactNo.frame=CGRectMake(10,440,1024-20, 80);
            txtaddress.frame=CGRectMake(10,540,1024-20, 80);
            txtPassword.frame=CGRectMake(10,640,1024-20, 80);
            txtConformPass.frame=CGRectMake(10,740,1024-20,80);
            buttomView.frame=CGRectMake(0,768-80,1024, 80);
            [btnLogin setFrame:CGRectMake(0,0,1024/2, 80)];
            [btnSingUp setFrame:CGRectMake(1024/2,0,1024/2, 80)];
            
        }
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            scrollview .frame=CGRectMake(0 , 0, 1024,768-80);
            txtfristname.frame=CGRectMake(10,40,1024-20, 80);
            txtLastname.frame=CGRectMake(10,140, 1024-20, 80);
            txtemailId.frame=CGRectMake(10, 240, 1024-20, 80);
            txtusername.frame=CGRectMake(10,340, 1024-20, 80);
            txtcontactNo.frame=CGRectMake(10,440, 1024-20, 80);
            txtaddress.frame=CGRectMake(10,540, 1024-20, 80);
            txtPassword.frame=CGRectMake(10,640,1024-20, 80);
            txtConformPass.frame=CGRectMake(10,740,1024-20,80);
            buttomView.frame=CGRectMake(0,768-80,1024, 80);
            [btnLogin setFrame:CGRectMake(0,0,1024/2, 80)];
            [btnSingUp setFrame:CGRectMake(1024/2, 0, 1024/2, 80)];
            
        }
    
    
    }*/
    
    fieldArray=[[NSArray alloc]init];
    fieldArray = [NSArray arrayWithObjects: txtfristname, txtLastname,txtemailId,txtusername,txtcontactNo,txtaddress,txtPassword,txtConformPass, nil];
    [self.view addSubview:backImg];
    [self.view addSubview:backBtn];

	// Do any additional setup after loading the view.
}

-(void)login
{
    
    LoginVC *login=[[LoginVC alloc]init];
    
    [self.navigationController pushViewController:login animated:NO];
   
   // [self presentModalViewController:EventRegvc animated:NO];
 
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SingUp
{
    
    if (txtfristname.text.length==0)
    {
        
    UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide Frist name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
    [altfname show];
        
    }
    else if (txtLastname.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide Last name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];

    }
   else if(txtPassword.text.length==0)
   {
       UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
       [altfname show];
       
     
   }
   else if(txtConformPass.text.length==0)
   {
       UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide Conform Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
       [altfname show];
       
       
   }
   else if(txtConformPass.text.length==0)
   {
       UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide Conform Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
       [altfname show];
       
       
   }

   else if(txtemailId.text.length==0)
   {
       
       UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide E-Mail" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
       [altfname show];
   }
    else if(txtaddress.text.length==0)
    {
        UIAlertView *altfname=[[UIAlertView alloc]initWithTitle:@"Invalide" message:@"Please Enter valide Address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:Nil, nil];
        [altfname show];
    
    }
    
   else
   {
   
       UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You have registered successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       alert.tag = 5;
       [alert show];//jam2-06
       
       /*ProfileSetUpVC *profsetup=[[ProfileSetUpVC alloc]init];
       
       [self.navigationController pushViewController:profsetup animated:NO];*/
   
   }

   
}
#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            LoginVC *login=[[LoginVC alloc]init];
            isFromSignUp = YES;
            login.userNameStr = txtusername.text;
            login.passwordStr = txtPassword.text;
            [self.navigationController pushViewController:login animated:NO];//jam
        }
        else
        {
            
        }
    }
    
}

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
        if (textField==txtConformPass)
        {
          scrollview.frame = CGRectMake(0, 50, self.view.frame.size.width,self.view.frame.size.height);
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
        
    if (IS_IPHONE_4)
    {
        if (textField==txtPassword)
        {
            [scrollview setContentOffset:CGPointMake(0,0) animated:YES];
        }
        else if(textField==txtConformPass)
        {
            [scrollview setContentOffset:CGPointMake(0,0) animated:YES];
            
        }
        else if(textField==txtaddress)
        {
            [scrollview setContentOffset:CGPointMake(0,0) animated:YES];
            
        }
    }
   
    
    if (textField==txtPassword)
    {
        [scrollview setContentOffset:CGPointMake(0,0) animated:YES];
    }
    else if(textField==txtConformPass)
    {
        [scrollview setContentOffset:CGPointMake(0,0) animated:YES];
    }
    [textField resignFirstResponder];
    return YES;
    }
   
   // scrollview.frame = CGRectMake(0, 50, self.view.frame.size.width,self.view.frame.size.height);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    /*if (IS_IPAD)
    {
        
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            if (textField==txtConformPass) {
                [scrollview setContentOffset:CGPointMake(0, 450)];
            }
            if (textField==txtPassword) {
                [scrollview setContentOffset:CGPointMake(0, 430)];
            }
            if (textField==txtaddress) {
                [scrollview setContentOffset:CGPointMake(0, 320)];
            }
            if (textField==txtcontactNo) {
                [scrollview setContentOffset:CGPointMake(0, 340)];
            }
            if (textField==txtusername) {
                [scrollview setContentOffset:CGPointMake(0, 250)];
            }

        }
        else if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            if (textField==txtConformPass) {
                [scrollview setContentOffset:CGPointMake(0, 450)];
            }
            if (textField==txtPassword) {
                [scrollview setContentOffset:CGPointMake(0, 430)];
            }
            if (textField==txtaddress) {
                [scrollview setContentOffset:CGPointMake(0, 320)];
            }
            if (textField==txtcontactNo) {
                [scrollview setContentOffset:CGPointMake(0, 340)];
            }
            if (textField==txtusername) {
                [scrollview setContentOffset:CGPointMake(0, 250)];
            }
            
        }
        
        else
        {
            
            
                if (textField==txtConformPass) {
                    [scrollview setContentOffset:CGPointMake(0, 240)];
                }
                if (textField==txtPassword) {
                    [scrollview setContentOffset:CGPointMake(0, 150)];
                }
    
        }
        
    }
    
    else
    {
        if (IS_IPHONE_4)
        {
            if (textField==txtusername)
            {
                [scrollview setContentOffset:CGPointMake(0, 10) animated:YES];
                
            }
            else if (textField==txtcontactNo)
            {
                [scrollview setContentOffset:CGPointMake(0, 30) animated:YES];
                
            }
            else if (textField==txtPassword) {
                [scrollview setContentOffset:CGPointMake(0,140) animated:YES];
            }
            else if(textField==txtConformPass)
            {
                [scrollview setContentOffset:CGPointMake(0,180) animated:YES];
            
            }
            else if(textField==txtaddress)
            {
                [scrollview setContentOffset:CGPointMake(0,100) animated:YES];

            }
        }
        else if(IS_IPHONE_5)
        {
            if (textField==txtaddress) {
                [scrollview setContentOffset:CGPointMake(0, 75)];
            }
            if (textField==txtPassword) {
                [scrollview setContentOffset:CGPointMake(0,100) animated:YES];
            }
            else if(textField==txtConformPass)
            {
                [scrollview setContentOffset:CGPointMake(0,150) animated:YES];

            }
        }
    }*/
    
    if (textField == txtfristname)
    {
        scrollview.frame = CGRectMake(0, -20, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtLastname)
    {
        scrollview.frame = CGRectMake(0, -50, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtemailId)
    {
        scrollview.frame = CGRectMake(0, -100, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtusername)
    {
        scrollview.frame = CGRectMake(0, -150, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtcontactNo)
    {
        scrollview.frame = CGRectMake(0, -200, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtaddress)
    {
        scrollview.frame = CGRectMake(0, -240, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtPassword)
    {
        scrollview.frame = CGRectMake(0, -260, self.view.frame.size.width,self.view.frame.size.height);
    }
    else if (textField == txtConformPass)
    {
        scrollview.frame = CGRectMake(0, -300, self.view.frame.size.width,self.view.frame.size.height);
    }





    
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   /* if (IS_IPAD)
    {
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        {
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];

        }
        else
        {
           if (textField==txtConformPass)
           {
                    [scrollview setContentOffset:CGPointMake(0, 145) animated:YES];
           }
        }
    }
    
    else
    {
        if (textField==txtConformPass)
        {
           
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }*/
    if (textField == txtConformPass)
    {
        scrollview.frame = CGRectMake(0, 50, self.view.frame.size.width,self.view.frame.size.height);
    }
    [textField resignFirstResponder];
   
    
    
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
        scrollview .frame=CGRectMake(0 , 0, 1024,768-80);
        txtfristname.frame=CGRectMake(10,40,1024-20,80);
        txtLastname.frame=CGRectMake(10,140, 1024-20,80);
        txtemailId.frame=CGRectMake(10, 240, 1024-20,80);
        txtusername.frame=CGRectMake(10,340, 1024-20,80);
        txtcontactNo.frame=CGRectMake(10,440, 1024-20,80);
        txtaddress.frame=CGRectMake(10,540, 1024-20,80);
        txtPassword.frame=CGRectMake(10,640,1024-20,80);
        txtConformPass.frame=CGRectMake(10,740,1024-20,80);
        buttomView.frame=CGRectMake(0,768-80,1024,80);
        [btnLogin setFrame:CGRectMake(0,0,1024/2,80)];
        [btnSingUp setFrame:CGRectMake(1024/2, 0, 1024/2,80)];
        

    }
    else
    {
        NSLog(@"Portrait");
        scrollview .frame=CGRectMake(0 , 0, 768, 1024);
        txtfristname.frame=CGRectMake(10,40,768-20, 80);
        txtfristname.font=[UIFont systemFontOfSize:24];
        txtLastname.frame=CGRectMake(10,140, 768-20, 80);
        txtLastname.font=[UIFont systemFontOfSize:24];
        txtemailId.frame=CGRectMake(10, 240, 768-20, 80);
        txtemailId.font=[UIFont systemFontOfSize:24];
        txtusername.frame=CGRectMake(10,340, 768-20, 80);
        txtusername.font=[UIFont systemFontOfSize:24];
        txtcontactNo.frame=CGRectMake(10,440, 768-20, 80);
        txtcontactNo.font=[UIFont systemFontOfSize:24];
        txtaddress.frame=CGRectMake(10,540, 768-20, 80);
        txtaddress.font=[UIFont systemFontOfSize:24];
        txtPassword.frame=CGRectMake(10,640,768-20, 80);
        txtPassword.font=[UIFont systemFontOfSize:24];
        txtConformPass.frame=CGRectMake(10,740,768-20,80);
        txtConformPass.font=[UIFont systemFontOfSize:24];
        buttomView.frame=CGRectMake(0,1024-80,768, 80);
        [btnLogin setFrame:CGRectMake(0,0,768/2, 80)];
        [btnSingUp setFrame:CGRectMake(768/2, 0, 768/2, 80)];
    }
    
}




@end
