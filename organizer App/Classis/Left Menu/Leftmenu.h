//
//  Leftmenu.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "URLManager.h"
@interface Leftmenu : UIViewController<UITableViewDataSource,UITableViewDelegate,URLManagerDelegate>
{
    UITableView *tblMenu;
    NSMutableArray *menu;
    UIImageView *bg;
    UIView * navView;
    NSInteger selectedOne;
    
}
@end
