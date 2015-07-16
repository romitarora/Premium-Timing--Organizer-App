//
//  Home.h
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface Home : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton * btnRightMenu;
    UITableView *tblMenu;
}
@property (nonatomic,strong)NSString *selectedDate;
@end
