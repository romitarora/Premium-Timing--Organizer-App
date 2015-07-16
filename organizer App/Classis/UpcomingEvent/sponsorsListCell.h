//
//  sponsorsListCell.h
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface sponsorsListCell : UITableViewCell<UITextViewDelegate>
{
    
}
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UILabel * nameLbl;
@property (nonatomic,strong)UILabel * webURL;
@property(nonatomic,strong)UIImageView * checkImg;
@end
