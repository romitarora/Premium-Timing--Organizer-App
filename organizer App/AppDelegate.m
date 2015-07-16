//
//  AppDelegate.m
//  organizer App
//
//  Created by i-MaC on 5/26/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    isEventSavedCorrect = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashAfterLogin) name:@"splashAfterLogin" object:nil];
    [self createDatabase];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  
    
    spl=[[SplashVC alloc]init];
    nav=[[UINavigationController alloc] initWithRootViewController:spl];
    self.window.rootViewController=nav;
  
    
    if (IS_OS_8_OR_LATER)
    {
        spl=[[SplashVC alloc]init];
        nav=[[UINavigationController alloc] initWithRootViewController:spl];
        // self.window.rootViewController=nav;
        [self.window addSubview:nav.view];
         [self.window makeKeyAndVisible];
    }
    else
    {
        spl=[[SplashVC alloc]init];
        nav=[[UINavigationController alloc] initWithRootViewController:spl];
        self.window.rootViewController=nav;
         [self.window makeKeyAndVisible];
    }
    
   /* AppDelegate * ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    splitViewController =[[UISplitViewController alloc] init];
    
    homeVC = [[UpComingEventVC alloc] init];
    
    mainNavController   = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    listViewController = [[Leftmenu alloc] init];
    listNavController   = [[UINavigationController alloc] initWithRootViewController:listViewController];
    listNavController.navigationBar.tintColor = [UIColor blackColor];
    listNavController.navigationBarHidden  = NO;
    
    
    if (IS_OS_8_OR_LATER)
    {
        
        splitViewController.viewControllers = [NSArray arrayWithObjects:listNavController,mainNavController, nil];
        splitViewController.delegate = self;
        //  ap.window.rootViewController = splitViewController;
        [ap.window addSubview:splitViewController.view];
        
    }
    else
    {
        splitViewController.viewControllers = [NSArray arrayWithObjects:listNavController,mainNavController, nil];
        splitViewController.delegate = self;
        ap.window.rootViewController = splitViewController;
        
        
    }*/


    
  /*  if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];//jam30-04-2015
        
    }
    else
    {
        [[UIApplication sharedApplication]enabledRemoteNotificationTypes];
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }*/
    
    
    return YES;

}
#pragma mark - Create Database
-(void)createDatabase
{
    [[DataBaseManager dataBaseManager] createMainTable];
    [[DataBaseManager dataBaseManager] createStagesTable];
    [[DataBaseManager dataBaseManager] createSplitsTable];
    [[DataBaseManager dataBaseManager] createGeneralInfoTable];
    [[DataBaseManager dataBaseManager] createEventSponsorsTable];
    [[DataBaseManager dataBaseManager] createEventParticipantsTable];
    [[DataBaseManager dataBaseManager] createImagesTable];
    [[DataBaseManager dataBaseManager] createMapTable];
    [[DataBaseManager dataBaseManager] createProfileDetailTable];
    [[DataBaseManager dataBaseManager] createTotalParticipantsTable];
    [[DataBaseManager dataBaseManager] createTotalSponsorsTable];
    [[DataBaseManager dataBaseManager] createEventCategoryTable];
    [[DataBaseManager dataBaseManager] createRaceTypeTable];
    [[DataBaseManager dataBaseManager] createDevicesListTable];
}
-(void)splashAfterLogin
{
    if (IS_OS_8_OR_LATER)
    {
        spl=[[SplashVC alloc]init];
        nav=[[UINavigationController alloc] initWithRootViewController:spl];
        // self.window.rootViewController=nav;
        [self.window addSubview:nav.view];
    }
    else
    {
        spl=[[SplashVC alloc]init];
        nav=[[UINavigationController alloc] initWithRootViewController:spl];
       self.window.rootViewController=nav;
       /// [self.window addSubview:nav.view];
    }
  
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
  //  return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark Hud Method
-(void)hudForprocessMethod:(NSString *)text
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    HUD.labelText = text;
    HUD.transform = CGAffineTransformMakeRotation(0);
    [self.window addSubview:HUD];
    [HUD show:YES];
    
}
-(void)hudEndProcessMethod
{
    [HUD hide:YES];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"alert" message:identifier delegate:self cancelButtonTitle:OK_BTN otherButtonTitles:nil, nil];
    [alert show];
    
    
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    
    NSLog(@"My Token =%@",deviceTokenStr);
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"updatedDeviceToken"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
