//
//  ProfileSetUpVC.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "URLManager.h"
#import "AsyncImageView.h"
@interface ProfileSetUpVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,URLManagerDelegate>
{
    UIView * navView;
    UIView * eventPikerView;
    
    
    UIButton * backBtn;
    UIButton * saveBtn;
    UIButton * profileBtn;
    UIButton * categoryBtn;
    UIButton *btnsave;
    UIButton * btnEdit;
    
    
    UITextField *txtFirstName;
    UITextField *txtLastName;
    UITextField *txtEmailId;
    UITextField *txtContactNum;
    UITextField *txtCompanyName;
    UITextField *txtWebsite;
    UITextField *txtSocialLink;
    
    UILabel * firstNameLbl;
    UILabel * lastNameLbl;
    UILabel * emailIdLbl;
    UILabel * contactNumberLbl;
    UILabel * companyNameLbl;
    UILabel * websiteLbl;
    UILabel * socialLinkLbl;
    UILabel * categoeyLbl;
    UILabel * titleLbl;
    
    AsyncImageView * profileImg;
    UIImageView *firstNameIcon;
    UIImageView *lastNameIcon;
    UIImageView *emailIdIcon;
    UIImageView *ContactIcon;
    UIImageView *companyIcon;
    UIImageView *websiteIcon;
    UIImageView *socialLinkIcon;
    UIImageView *categoryIcon;
    
    NSArray *fieldArray;
    
    TPKeyboardAvoidingScrollView *scrollContent;
    NSInteger yy;
    NSInteger imagePicFlag;
    UIImagePickerController * imagePicker;
    NSMutableDictionary * profileDetailDict;
    NSMutableArray * categoryArr;
    UITableView * eventCategoryTbl;
    BOOL isClick;
}
@property (strong) UIPopoverController *pop;
@end
