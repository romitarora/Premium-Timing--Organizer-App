//
//  LoginVC.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingUpVC.h"
#import "ForGotPassword.h"
#import "Home.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "Leftmenu.h"
#import "Constant.h"
@interface LoginVC : UIViewController<UITextFieldDelegate>
{
    UITextField *txtusername;
    UITextField *txtPassword;
    UIButton *BtnForget;
    UIButton *btnSingUp;
    UIButton *btnLogin;
    UIView *buttomView;
    
}
@property(nonatomic,strong)NSString * userNameStr;
@property(nonatomic,strong)NSString * passwordStr;

@end
