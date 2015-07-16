//
//  Welcome.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "URLManager.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenuShadow.h"
#import "Leftmenu.h"
#import "CustomCalendarViewController.h"
#import "UpComingEventVC.h"
#import "ForGotPassword.h"
#import "Constant.h"
#import "TPKeyboardAvoidingScrollView.h"

@class UpComingEventVC;
@class Leftmenu;
@class AppDelegate;
@interface Welcome : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,URLManagerDelegate,UISplitViewControllerDelegate>
{
    AppDelegate * app;
    NSInteger yy;
    UISplitViewController *splitViewController;
    UINavigationController *listNavController;
    Leftmenu * listViewController;
    UINavigationController *mainNavController;
    UpComingEventVC *homeVC;
    //-----------------------------for sign up page-----------------//
    
    UILabel *lblTitle;
    UIButton *btnLogin;
    UIButton *btnSingUp;
    UIButton *signCloseBtn;
    
    UIButton * registeredBtn;
    
    NSArray *fieldArray;
    
    UIView *buttomView;
    UIView * signUpView;
    UIView * loginView;
    
    UIView * signUpbackImg;
    UIView * loginbackImg;
    
    TPKeyboardAvoidingScrollView *scrollview;
    UITextField *txtfirstname;
    UITextField *txtLastname;
    UITextField *txtemailId;
    UITextField *txtcontactNo;
    UITextField *txtaddress;
    UITextField *txtCompanyName ;
    UITextField *txtPassword;
    UITextField *txtConformPass;
    
    UILabel *FirstNameLbl;
    UILabel *LastNameLbl;
    UILabel *EmailIdLbl;
    UILabel *ContactNoLbl;
    UILabel *AddressLbl;
    UILabel *CompanyNameLbl ;
    UITextField *PasswordLbl;
    UITextField *ConformPassLbl;
    
    NSMutableDictionary * signupDetailDict;
    NSMutableArray * loginDetailArr;
    
    BOOL isClick;
    
    //-------------------------- for login screen ------------------//
    
    UITextField *txtLoginId;
    UITextField *txtLoginPassword;
    UIButton *BtnForget;
    UIButton *LoginBtn;
    UIButton *SignUpBtn;
    UIButton *loginCloseBtn;
    
    BOOL isFromLoginBtn;
}
@end
