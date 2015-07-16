//
//  EventViewCell.h
//  organizer App
//
//  Created by One Click IT Consultancy  on 5/30/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UILabel * eventNameLbl;
@property(nonatomic,strong)UILabel * timeLbl;
@property(nonatomic,strong)UILabel * locationLbl;
@property(nonatomic,strong)UIImageView * eventImage;
@property(nonatomic,strong)UIView * header;

@end
