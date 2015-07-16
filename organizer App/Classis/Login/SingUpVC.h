//
//  SingUpVC.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "ProfileSetUpVC.h"

@interface SingUpVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
   // TextFieldValidator *txtDemo;
    UIButton *btnSingUp;
    UIButton *btnLogin;
    UIView *buttomView;
    NSArray *fieldArray;
    
    UIScrollView *scrollview;
    UITextField *txtfristname;
    UITextField *txtLastname;
    UITextField *txtemailId;
    UITextField *txtcontactNo;
    UITextField *txtaddress;
    UITextField *txtusername;
    UITextField *txtPassword;
    UITextField *txtConformPass;
    
}
@end
