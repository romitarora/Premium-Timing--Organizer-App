//
//  ProfileSetUpVC.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "ProfileSetUpVC.h"
#import "AppDelegate.h"
#import "Leftmenu.h"
#import "Constant.h"
@interface ProfileSetUpVC ()

@end

@implementation ProfileSetUpVC
@synthesize pop;
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
    titleLbl.text = @"Profile";
    titleLbl.font = [UIFont fontWithName:@"Century Gothic" size:25.0f];
    [navView addSubview:titleLbl];
    
    saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(navView.frame.size.width-100, 30, 80, 30);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    saveBtn.hidden = YES;
    saveBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:saveBtn];
    
    btnEdit = [[UIButton alloc]init];
    btnEdit.frame = CGRectMake(navView.frame.size.width-100, 30, 80, 30);
    btnEdit.backgroundColor = [UIColor clearColor];
    //[saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    [btnEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"sign-up"] forState:UIControlStateNormal];
    btnEdit.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [navView addSubview:btnEdit];
    
    NSMutableArray * temp = [[NSMutableArray alloc]init];
    NSString * str = [NSString stringWithFormat:@"select * from Profile_Table"];
    
    [[DataBaseManager dataBaseManager] execute:str resultsArray:temp];
    
    if (temp.count == 0)
    {
        profileDetailDict = [[NSMutableDictionary alloc]init];
        [profileDetailDict setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userDetail"] valueForKey:@"firstName"] forKey:@"firstName"];
        [profileDetailDict setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userDetail"] valueForKey:@"lastName"] forKey:@"lastName"];
        [profileDetailDict setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userDetail"] valueForKey:@"emailId"] forKey:@"emailId"];
        [profileDetailDict setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userDetail"] valueForKey:@"contact"]forKey:@"contact"];
        [profileDetailDict setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userDetail"] valueForKey:@"companyName"] forKey:@"company"];
        [profileDetailDict setValue:@"required" forKey:@"website"];
        [profileDetailDict setValue:@"required" forKey:@"socialLink"];
        [profileDetailDict setValue:@"required" forKey:@"eventCategory"];
        [profileDetailDict setValue:@"required" forKey:@"photo"];
        
    }
    else
    {
        profileDetailDict = [[NSMutableDictionary alloc]init];
        profileDetailDict = [[temp objectAtIndex:0] mutableCopy];
    }
    
    if (IS_IPAD)
    {
        scrollContent = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(20, 100, 704-40, 768-120)];
        [scrollContent setContentSize:CGSizeMake(scrollContent.frame.size.width, 768-120)];
        
    }
    else
    {
        
    }
    [scrollContent setBackgroundColor:[UIColor blackColor]];
    scrollContent.bounces = NO;
    scrollContent.delegate = self;
    scrollContent.userInteractionEnabled = YES;
    [scrollContent setShowsHorizontalScrollIndicator:NO];
    [scrollContent setShowsVerticalScrollIndicator:NO];
    scrollContent.scrollEnabled=YES;
    [scrollContent setContentMode:UIViewContentModeScaleAspectFit];
    [scrollContent sizeToFit];
    [self.view addSubview:scrollContent];
    [self.view bringSubviewToFront:scrollContent];
    
    UIColor *color = [UIColor lightGrayColor];
    
    yy = 20;
    
    profileImg =[[AsyncImageView alloc]init];
    profileImg.frame = CGRectMake(282, yy, 100, 100);
    profileImg.backgroundColor = [UIColor clearColor];
    
    // BY RAJU 9-7-2015
    profileBtn.contentMode=UIViewContentModeScaleAspectFill;
    
    
    profileImg.layer.cornerRadius = 50;
    profileImg.layer.cornerRadius = 50;
    profileImg.layer.masksToBounds = YES;
    
    [scrollContent addSubview:profileImg];
    
    profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame =CGRectMake(282-74, yy, 137, 137);
    profileBtn.backgroundColor = [UIColor clearColor];
    [profileBtn addTarget:self action:@selector(profileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    profileImg.image = [UIImage imageNamed:@"profileImg@2x.png"];
    
    [scrollContent addSubview:profileBtn];
    
    profileImg.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[profileDetailDict valueForKey:@"photo"]]];
    
    
    yy = yy+120;
    
    UIView * tempfirst=[[UIView alloc]init];
    tempfirst.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    tempfirst.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:tempfirst];
    
    firstNameIcon = [[UIImageView alloc]init];
    firstNameIcon.backgroundColor = [UIColor clearColor];
    firstNameIcon.image  =[UIImage imageNamed:@"firstname"];
    firstNameIcon.frame = CGRectMake(10, 12.05, 25, 25);
    [tempfirst addSubview:firstNameIcon];
    
    
    txtFirstName=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,tempfirst.frame.size.width-50, 50)];
    txtFirstName.textColor=[UIColor whiteColor];
    txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FRIST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtFirstName.textAlignment=NSTextAlignmentLeft;
    txtFirstName.returnKeyType=UIReturnKeyNext;
    txtFirstName.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtFirstName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtFirstName.delegate = self;
    txtFirstName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [tempfirst addSubview:txtFirstName];
    
    firstNameLbl = [[UILabel alloc]init];
    firstNameLbl.frame = CGRectMake(tempfirst.frame.size.width/2+10, 10, tempfirst.frame.size.width/2-20, 30);
    firstNameLbl.backgroundColor = [UIColor clearColor];
    firstNameLbl.textColor = [UIColor yellowColor];
    firstNameLbl.textAlignment = NSTextAlignmentRight;
    firstNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [tempfirst addSubview:firstNameLbl];
    
    if ([[profileDetailDict valueForKey:@"firstName"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        firstNameLbl.text = [profileDetailDict valueForKey:@"firstName"];
    }
    
    yy = yy+60;
    
    UIView * lastview=[[UIView alloc]init];
    lastview.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    lastview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:lastview];
    
    lastNameIcon = [[UIImageView alloc]init];
    lastNameIcon.backgroundColor = [UIColor clearColor];
    lastNameIcon.image  =[UIImage imageNamed:@"firstname"];
    lastNameIcon.frame = CGRectMake(10, 12.05, 25, 25);
    [lastview addSubview:lastNameIcon];
    
    txtLastName=[[UITextField alloc]initWithFrame:CGRectMake(50,0,lastview.frame.size.width-50, 50)];
    txtLastName.textColor=[UIColor whiteColor];
    txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LAST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    txtLastName.textAlignment=NSTextAlignmentLeft;
    txtLastName.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtLastName setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtLastName.delegate = self;
    txtLastName.returnKeyType=UIReturnKeyNext;
    txtLastName.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [lastview addSubview:txtLastName];
    
    lastNameLbl = [[UILabel alloc]init];
    lastNameLbl.frame = CGRectMake(lastview.frame.size.width/2+10, 10, lastview.frame.size.width/2-20, 30);
    lastNameLbl.backgroundColor = [UIColor clearColor];
    lastNameLbl.textColor = [UIColor yellowColor];
    lastNameLbl.textAlignment = NSTextAlignmentRight;
    lastNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [lastview addSubview:lastNameLbl];
    
    if ([[profileDetailDict valueForKey:@"lastName"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        lastNameLbl.text = [profileDetailDict valueForKey:@"lastName"];
    }
    
    
    yy = yy+60;
    
    
    UIView * emailview=[[UIView alloc]init];
    emailview.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    emailview.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:emailview];
    
    emailIdIcon = [[UIImageView alloc]init];
    emailIdIcon.backgroundColor = [UIColor clearColor];
    emailIdIcon.image  =[UIImage imageNamed:@"email"];
    emailIdIcon.frame = CGRectMake(10, 16, 25, 18);
    [emailview addSubview:emailIdIcon];
    
    txtEmailId=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,emailview.frame.size.width-50, 50)];
    txtEmailId.textColor=[UIColor whiteColor];
    txtEmailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL ID" attributes:@{NSForegroundColorAttributeName: color}];
    txtEmailId.keyboardType=UIKeyboardTypeEmailAddress;
    txtEmailId.textAlignment = NSTextAlignmentLeft;
    txtEmailId.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtEmailId setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtEmailId.delegate = self;
    txtEmailId.returnKeyType=UIReturnKeyNext;
    txtEmailId.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [emailview addSubview:txtEmailId];
    
    emailIdLbl = [[UILabel alloc]init];
    emailIdLbl.frame = CGRectMake(emailview.frame.size.width/2+10, 10, emailview.frame.size.width/2-20, 30);
    emailIdLbl.backgroundColor = [UIColor clearColor];
    emailIdLbl.textColor = [UIColor yellowColor];
    emailIdLbl.textAlignment = NSTextAlignmentRight;
    emailIdLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [emailview addSubview:emailIdLbl];
    
    if ([[profileDetailDict valueForKey:@"emailId"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        emailIdLbl.text = [profileDetailDict valueForKey:@"emailId"];
    }
    
    
    yy = yy+60;
    
    
    UIView * contactView=[[UIView alloc]init];
    contactView.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    contactView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:contactView];
    
    ContactIcon = [[UIImageView alloc]init];
    ContactIcon.backgroundColor = [UIColor clearColor];
    ContactIcon.image  =[UIImage imageNamed:@"contact"];
    ContactIcon.frame = CGRectMake(10, 13, 15, 24);
    [contactView addSubview:ContactIcon];
    
    txtContactNum=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,emailview.frame.size.width-50, 50)];
    txtContactNum.textColor=[UIColor whiteColor];
    txtContactNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CONTACT NUMBER" attributes:@{NSForegroundColorAttributeName: color}];
    txtContactNum.keyboardType=UIKeyboardTypeNumberPad;
    txtContactNum.textAlignment = NSTextAlignmentLeft;
    txtContactNum.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtContactNum setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtContactNum.delegate = self;
    txtContactNum.returnKeyType=UIReturnKeyNext;
    txtContactNum.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [contactView addSubview:txtContactNum];
    
    contactNumberLbl = [[UILabel alloc]init];
    contactNumberLbl.frame = CGRectMake(contactView.frame.size.width/2+10, 10, contactView.frame.size.width/2-20, 30);
    contactNumberLbl.backgroundColor = [UIColor clearColor];
    contactNumberLbl.textColor = [UIColor yellowColor];
    contactNumberLbl.textAlignment = NSTextAlignmentRight;
    contactNumberLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [contactView addSubview:contactNumberLbl];
    
    if ([[profileDetailDict valueForKey:@"contact"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        contactNumberLbl.text = [profileDetailDict valueForKey:@"contact"];
    }
    
    yy = yy+60;
    
    
    UIView * CompanyNameView=[[UIView alloc]init];
    CompanyNameView.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    CompanyNameView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:CompanyNameView];
    
    companyIcon = [[UIImageView alloc]init];
    companyIcon.backgroundColor = [UIColor clearColor];
    companyIcon.image  =[UIImage imageNamed:@"comapny-name.png"];
    companyIcon.frame = CGRectMake(10, 14, 22, 22);
    [CompanyNameView addSubview:companyIcon];
    
    txtCompanyName=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,scrollContent.frame.size.width-50, 50)];
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
    
    companyNameLbl = [[UILabel alloc]init];
    companyNameLbl.frame = CGRectMake(CompanyNameView.frame.size.width/2+10, 10, CompanyNameView.frame.size.width/2-20, 30);
    companyNameLbl.backgroundColor = [UIColor clearColor];
    companyNameLbl.textColor = [UIColor yellowColor];
    companyNameLbl.textAlignment = NSTextAlignmentRight;
    companyNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [CompanyNameView addSubview:companyNameLbl];
    
    if ([[profileDetailDict valueForKey:@"company"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        companyNameLbl.text = [profileDetailDict valueForKey:@"company"];
    }
    
    
    yy = yy+60;
    
    
    UIView * websiteView=[[UIView alloc]init];
    websiteView.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    websiteView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:websiteView];
    
    websiteIcon = [[UIImageView alloc]init];
    websiteIcon.backgroundColor = [UIColor clearColor];
    websiteIcon.image  =[UIImage imageNamed:@"website"];
    websiteIcon.frame = CGRectMake(10, 14, 23, 22);
    [websiteView addSubview:websiteIcon];
    
    txtWebsite=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,scrollContent.frame.size.width-50, 50)];
    txtWebsite.textColor=[UIColor whiteColor];
    txtWebsite.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"WEBSITE URL" attributes:@{NSForegroundColorAttributeName: color}];
    txtWebsite.textAlignment=NSTextAlignmentLeft;
    txtWebsite.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtWebsite setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtWebsite.delegate = self;
    txtWebsite.returnKeyType=UIReturnKeyNext;
    txtWebsite.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [websiteView addSubview:txtWebsite];
    
    websiteLbl = [[UILabel alloc]init];
    websiteLbl.frame = CGRectMake(websiteView.frame.size.width/2+10, 10, websiteView.frame.size.width/2-20, 30);
    websiteLbl.backgroundColor = [UIColor clearColor];
    websiteLbl.textColor = [UIColor yellowColor];
    websiteLbl.textAlignment = NSTextAlignmentRight;
    websiteLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [websiteView addSubview:websiteLbl];
    
    if ([[profileDetailDict valueForKey:@"website"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        websiteLbl.text = [profileDetailDict valueForKey:@"website"];
    }
    
    
    yy = yy+60;
    
    
    UIView * socialView=[[UIView alloc]init];
    socialView.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    socialView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:socialView];
    
    socialLinkIcon = [[UIImageView alloc]init];
    socialLinkIcon.backgroundColor = [UIColor clearColor];
    socialLinkIcon.image  =[UIImage imageNamed:@"fb.png"];
    socialLinkIcon.frame = CGRectMake(10, 13.05, 23, 23);
    [socialView addSubview:socialLinkIcon];
    
    txtSocialLink=[[UITextField alloc]initWithFrame:CGRectMake(50 ,0,scrollContent.frame.size.width-50, 50)];
    txtSocialLink.textColor=[UIColor whiteColor];
    txtSocialLink.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FACEBOOK LINK" attributes:@{NSForegroundColorAttributeName: color}];
    txtSocialLink.textAlignment=NSTextAlignmentLeft;
    txtSocialLink.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [txtSocialLink setFont:[UIFont fontWithName:@"Century Gothic" size:20.0f]];
    txtSocialLink.delegate = self;
    txtSocialLink.returnKeyType=UIReturnKeyNext;
    txtSocialLink.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    
    [socialView addSubview:txtSocialLink];
    
    socialLinkLbl = [[UILabel alloc]init];
    socialLinkLbl.frame = CGRectMake(socialView.frame.size.width/2+10, 10, socialView.frame.size.width/2-20, 30);
    socialLinkLbl.backgroundColor = [UIColor clearColor];
    socialLinkLbl.textColor = [UIColor yellowColor];
    socialLinkLbl.textAlignment = NSTextAlignmentRight;
    socialLinkLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [socialView addSubview:socialLinkLbl];
    
    if ([[profileDetailDict valueForKey:@"socialLink"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        socialLinkLbl.text = [profileDetailDict valueForKey:@"socialLink"];
    }
    
    
    yy = yy+60;
    
    UIView * categoryView=[[UIView alloc]init];
    categoryView.frame =CGRectMake(20 ,yy,scrollContent.frame.size.width-40, 50);
    categoryView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"newtext-field.png"]];
    [scrollContent addSubview:categoryView];
    
    categoryIcon = [[UIImageView alloc]init];
    categoryIcon.backgroundColor = [UIColor clearColor];
    categoryIcon.image  =[UIImage imageNamed:@"eventdetail"];
    categoryIcon.frame = CGRectMake(10, 15.05, 23, 19);
    [categoryView addSubview:categoryIcon];
    
    categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.frame = CGRectMake(50, 0, categoryView.frame.size.width-50, categoryView.frame.size.height);
    categoryBtn.backgroundColor = [UIColor clearColor];
    [categoryBtn setTitle:@"EVENT CATEGORIES" forState:UIControlStateNormal];
    [categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
    [categoryBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    categoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
    [categoryView addSubview:categoryBtn];
    
    
    categoeyLbl = [[UILabel alloc]init];
    categoeyLbl.frame = CGRectMake(categoryView.frame.size.width/2+10, 10, categoryView.frame.size.width/2-20, 30);
    categoeyLbl.backgroundColor = [UIColor clearColor];
    categoeyLbl.textColor = [UIColor yellowColor];
    categoeyLbl.textAlignment = NSTextAlignmentRight;
    categoeyLbl.font = [UIFont fontWithName:@"Century Gothic" size:18.0f];
    [categoryView addSubview:categoeyLbl];
    
    if ([[profileDetailDict valueForKey:@"eventCategory"] isEqualToString:@"required"])
    {
        
    }
    else
    {
        categoeyLbl.text = [profileDetailDict valueForKey:@"eventCategory"];
    }
    
    eventPikerView = [[UIView alloc]init];
    eventPikerView.frame = CGRectMake(192.5, 768, 320, 300);
    eventPikerView.backgroundColor =[UIColor whiteColor];
    eventPikerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    eventPikerView.layer.borderWidth = 1.0f;
    eventPikerView.hidden = YES;
    [self.view addSubview:eventPikerView];
    
    UIView *backTitlt =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    backTitlt.backgroundColor=[UIColor darkGrayColor];
    [eventPikerView addSubview:backTitlt];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 25)];
    title.text=@"Select Category";
    title.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    [backTitlt addSubview:title];
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(250, 10, 50, 30)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone addTarget:self action:@selector(evetDoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backTitlt addSubview:btnDone];
    
    eventCategoryTbl =[[UITableView alloc] initWithFrame:CGRectMake(0 ,50, 320, 250) style:UITableViewStylePlain];
    eventCategoryTbl.backgroundColor = [UIColor clearColor];
    [eventCategoryTbl setDelegate:self];
    [eventCategoryTbl setDataSource:self];
    [eventCategoryTbl setSeparatorColor:[UIColor clearColor]];
    [eventCategoryTbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    eventCategoryTbl.showsVerticalScrollIndicator=NO;
    [eventPikerView addSubview:eventCategoryTbl];
    
    //    NSArray *test = [[NSArray alloc]init];
    //    test = @[ @{@"Name": @"Race 123"},@{@"Name": @"Car Race"},@{@"Name": @"Bike Race"},@{@"Name": @"Boat Race"},@{@"Name": @"Anduro Race"},@{@"Name": @"Run for Nation"}];
    
    categoryArr = [[NSMutableArray alloc] init];
    
    NSString * strCategory = [NSString stringWithFormat:@"select * from EventCategory_Table"];
    
    [[DataBaseManager dataBaseManager] execute:strCategory resultsArray:categoryArr];
    
    isClick = NO;
    
    txtFirstName.userInteractionEnabled = NO;
    txtLastName.userInteractionEnabled = NO;
    txtEmailId.userInteractionEnabled = NO;
    txtContactNum.userInteractionEnabled = NO;
    txtCompanyName.userInteractionEnabled = NO;
    txtWebsite.userInteractionEnabled = NO;
    txtSocialLink.userInteractionEnabled = NO;
    categoryBtn.userInteractionEnabled = NO;
    profileBtn.userInteractionEnabled = NO;
}

#pragma mark ButtonClick EVENTS
-(void)saveBtnClick:(id)sender
{
    
    saveBtn.userInteractionEnabled = NO;
    txtFirstName.userInteractionEnabled = NO;
    txtLastName.userInteractionEnabled = NO;
    txtEmailId.userInteractionEnabled = NO;
    txtContactNum.userInteractionEnabled = NO;
    txtCompanyName.userInteractionEnabled = NO;
    txtWebsite.userInteractionEnabled = NO;
    txtSocialLink.userInteractionEnabled = NO;
    categoryBtn.userInteractionEnabled = NO;
    profileBtn.userInteractionEnabled = NO;
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[profileDetailDict valueForKey:@"firstName"] forKey:@"first_name"];
    [dict setValue:[profileDetailDict valueForKey:@"lastName"] forKey:@"last_name"];
    [dict setValue:[profileDetailDict valueForKey:@"emailId"] forKey:@"email"];
    [dict setValue:[profileDetailDict valueForKey:@"company"] forKey:@"company_name"];
    [dict setValue:[profileDetailDict valueForKey:@"contact"] forKey:@"contact"];
    [dict setValue:[profileDetailDict valueForKey:@"address"] forKey:@"address"];
    [dict setValue:[profileDetailDict valueForKey:@"user_id"] forKey:@"user_id"];
    [dict setValue:[profileDetailDict valueForKey:@"socialLink"] forKey:@"fb_id"];
    [dict setValue:[profileDetailDict valueForKey:@"website"] forKey:@"website"];
    [dict setValue:[profileDetailDict valueForKey:@"photo"] forKey:@"photo"];
    
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
    manager.commandName = @"EditProfile";
    manager.delegate = self;
    [manager urlCall:@"http://103.240.35.200/subdomain/premium_timing/webservice/editProfile" withParameters:dict];
    
}
-(void)editBtnClick:(id)sender
{
    
    
    // BY RAJU 9-7-2015
    
    //
    //    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Now You Can Edit Your Information" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
    
    saveBtn.hidden = NO;
    btnEdit.hidden = YES;
    profileBtn.userInteractionEnabled = YES;
    txtFirstName.userInteractionEnabled = YES;
    txtLastName.userInteractionEnabled = YES;
    txtEmailId.userInteractionEnabled = YES;
    txtContactNum.userInteractionEnabled = YES;
    txtCompanyName.userInteractionEnabled = YES;
    txtWebsite.userInteractionEnabled = YES;
    txtSocialLink.userInteractionEnabled = YES;
    categoryBtn.userInteractionEnabled = YES;
    
    
}
-(void)profileBtnClick:(id)sender
{
    
    if (self.pop)
    {
        [self.pop dismissPopoverAnimated:YES];
        
    }
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES; //if you want to edit the image
    
    self.pop=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [self.pop presentPopoverFromRect:CGRectMake(300, 75, 100, 100)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
-(void)evetDoneClick:(id)sender
{
    
    categoeyLbl.hidden = NO;
    
    isClick=NO;
    
    [UIView transitionWithView:eventPikerView
                      duration:0.50
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        //                            [myview removeFromSuperview];
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            [eventPikerView setFrame:CGRectMake(192.5, 768, 320, 300)];
                        }
                        else
                        {
                            [eventPikerView setFrame:CGRectMake(192.5, 768, 320, 300)];
                        }
                    }
                    completion:nil];
    
    ;
    eventPikerView.hidden  = YES;
    
}

-(void)categoryBtnClick:(id)sender
{
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmailId resignFirstResponder];
    [txtContactNum resignFirstResponder];
    [txtCompanyName resignFirstResponder];
    [txtWebsite resignFirstResponder];
    [txtSocialLink resignFirstResponder];
    
    eventPikerView.hidden = NO;
    
    if (isClick == NO)
    {
        isClick=YES;
        [UIView transitionWithView:eventPikerView
                          duration:0.30
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            //                            [myview removeFromSuperview];
                            
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                [eventPikerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                            }
                            else
                            {
                                [eventPikerView setFrame:CGRectMake(192.5, 234, 320, 300)];
                            }
                            
                            
                        }
                        completion:nil];
    }
    
}

#pragma mark ON RESULT delegates

- (void)onResult:(NSDictionary *)result
{
    
    NSLog(@"The result is...%@", result);
    
    if([[result valueForKey:@"commandName"] isEqualToString:@"EditProfile"])
    {
        
        if([[[result valueForKey:@"result"]valueForKey:@"result"] isEqualToString:@"true"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your Profile Updated Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            saveBtn.hidden = YES;
            saveBtn.userInteractionEnabled = YES;
            btnEdit.hidden = NO;
            
            NSMutableDictionary * dict1 = [[NSMutableDictionary alloc]init];
            dict1 = [[[result valueForKey:@"result"] valueForKey:@"data"] mutableCopy];
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[dict1 valueForKey:@"first_name"] forKey:@"firstName"];
            [dict setValue:[dict1 valueForKey:@"last_name"] forKey:@"lastName"];
            [dict setValue:[dict1 valueForKey:@"email"] forKey:@"emailId"];
            [dict setValue:[dict1 valueForKey:@"contact_no"] forKey:@"contact"];
            [dict setValue:[dict1 valueForKey:@"company_name"] forKey:@"company"];
            [dict setValue:[dict1 valueForKey:@"website_url"] forKey:@"website"];
            [dict setValue:[dict1 valueForKey:@"fb_page_link"] forKey:@"socialLink"];
            [dict setValue:[dict1 valueForKey:@"photo"] forKey:@"photo"];
            [dict setValue:[profileDetailDict valueForKey:@"eventCategory"] forKey:@"eventCategory"];
            [dict setValue:[dict1 valueForKey:@"address"] forKey:@"address"];
            [dict setValue:[profileDetailDict valueForKey:@"user_id"] forKey:@"user_id"];
            
            NSString * strDelete = [NSString stringWithFormat:@"delete from Profile_Table"];
            [[DataBaseManager dataBaseManager] execute:strDelete];
            
            [[DataBaseManager dataBaseManager] insertProfileDetail:dict];
            
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please check the details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

#pragma mark - Image Picker  delegate

#pragma mark - Image Picker Controller Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    profileImg.image = image;
    
    profileImg.layer.cornerRadius = 50;
    profileImg.layer.masksToBounds = YES;
    
    NSData *data = UIImagePNGRepresentation(image);
    NSString *encodedString = [data base64Encoding];
    
    [profileDetailDict setObject:encodedString forKey:@"photo"];
    
    
    [self.pop dismissPopoverAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier=nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    cell.textLabel.text =[[categoryArr objectAtIndex:indexPath.row]valueForKey:@"cat_name"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Century Gothic" size:20.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel * line = [[UILabel alloc]init];
    line.frame = CGRectMake(0, 49, cell.frame.size.width, 1);
    line.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    categoeyLbl.text = [[categoryArr objectAtIndex:indexPath.row] valueForKey:@"cat_name"];
    [profileDetailDict setValue:[[categoryArr objectAtIndex:indexPath.row] valueForKey:@"cat_name"] forKey:@"eventCategory"];
}
#pragma mark textField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == txtFirstName)
    {
        [txtLastName becomeFirstResponder];
    }
    else if (textField == txtLastName)
    {
        [txtEmailId becomeFirstResponder];
    }
    else if (textField == txtEmailId)
    {
        [txtContactNum becomeFirstResponder];
    }
    else if (textField == txtContactNum)
    {
        [txtCompanyName becomeFirstResponder];
    }
    else if (textField == txtCompanyName)
    {
        [txtWebsite becomeFirstResponder];
    }
    else if (textField == txtWebsite)
    {
        [txtSocialLink becomeFirstResponder];
    }
    else if (textField == txtSocialLink)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self evetDoneClick:nil];
    
    if (textField == txtFirstName)
    {
        firstNameLbl.hidden = YES;
        txtFirstName.text = firstNameLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"firstName"];
    }
    else if (textField == txtLastName)
    {
        lastNameLbl.hidden = YES;
        txtLastName.text = lastNameLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"lastName"];
    }
    else if (textField == txtEmailId)
    {
        emailIdLbl.hidden = YES;
        txtEmailId.text = emailIdLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"emailId"];
    }
    else if (textField == txtContactNum)
    {
        contactNumberLbl.hidden = YES;
        txtContactNum.text = contactNumberLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"contact"];
    }
    else if (textField == txtCompanyName)
    {
        companyNameLbl.hidden = YES;
        txtCompanyName.text = companyNameLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"company"];
    }
    else if (textField == txtWebsite)
    {
        websiteLbl.hidden = YES;
        txtWebsite.text = websiteLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"website"];
    }
    else if (textField == txtSocialLink)
    {
        socialLinkLbl.hidden = YES;
        txtSocialLink.text = socialLinkLbl.text;
        [profileDetailDict setValue:textField.text forKey:@"socialLink"];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField == txtFirstName)
    {
        firstNameLbl.hidden = NO;
        firstNameLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"firstName"];
        txtFirstName.text = @"";
    }
    else if (textField == txtLastName)
    {
        lastNameLbl.hidden = NO;
        lastNameLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"lastName"];
        txtLastName.text = @"";
    }
    else if (textField  == txtEmailId)
    {
        emailIdLbl.hidden = NO;
        emailIdLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"emailId"];
        txtEmailId.text = @"";
    }
    else if (textField == txtContactNum)
    {
        contactNumberLbl.hidden = NO;
        contactNumberLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"contact"];
        txtContactNum.text = @"";
        
    }
    else if (textField == txtCompanyName)
    {
        companyNameLbl.hidden = NO;
        companyNameLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"company"];
        txtCompanyName.text = @"";
        
    }
    else if (textField == txtWebsite)
    {
        websiteLbl.hidden = NO;
        websiteLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"website"];
        txtWebsite.text = @"";
        
    }
    else if (textField == txtSocialLink)
    {
        socialLinkLbl.hidden = NO;
        socialLinkLbl.text = textField.text;
        [profileDetailDict setValue:textField.text forKey:@"socialLink"];
        txtSocialLink.text = @"";
        
    }
    if (textField == txtSocialLink)
    {
        scrollContent.frame =CGRectMake(20, 100, 704-40, 768-120);
        
    }
    
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
