//
//  UpcomingEventCell.h
//  organizer App
//
//  Created by Romit on 04/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UpcomingEventCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UILabel * eventNameLbl;
@property(nonatomic,strong)UILabel * timeLbl;
@property(nonatomic,strong)UILabel * locationLbl;
@property(nonatomic,strong)UILabel * startMonthLbl;
@property(nonatomic,strong)UILabel * endMonthLbl;
@property(nonatomic,strong)UILabel * startDateLbl;
@property(nonatomic,strong)UILabel * endDateLbl;
@property(nonatomic,strong)UIImageView * eventImage;
@property(nonatomic,strong)UIView * header;

@end
