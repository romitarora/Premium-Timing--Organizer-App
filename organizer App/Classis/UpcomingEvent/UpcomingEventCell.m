//
//  UpcomingEventCell.m
//  organizer App
//
//  Created by Romit on 04/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "UpcomingEventCell.h"

@implementation UpcomingEventCell
@synthesize header,timeLbl,locationLbl,eventImage,eventNameLbl,startDateLbl,endDateLbl,endMonthLbl,startMonthLbl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        header = [[UIView alloc]init];
        header.frame = CGRectMake(0, 0, self.frame.size.width, 150);
        header.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:header];
        
        eventImage = [[UIImageView alloc]init];
        eventImage.frame = CGRectMake(15, 15, 120, 120);
        eventImage.backgroundColor = [UIColor clearColor];
        eventImage.image = [UIImage imageNamed:@""];
        eventImage.layer.masksToBounds = YES;
        eventImage.layer.cornerRadius = 8;
        eventImage.layer.borderColor = [UIColor clearColor].CGColor;
        eventImage.layer.borderWidth = 1;
        eventImage.layer.shadowColor = [UIColor blackColor].CGColor;
        eventImage.layer.shadowOpacity = 0.4f;
        eventImage.layer.shadowOffset = CGSizeMake(0, 2);
        eventImage.contentMode = UIViewContentModeScaleAspectFill;
        [header addSubview:eventImage];
        
        eventNameLbl = [[UILabel alloc]init];
        eventNameLbl.frame = CGRectMake(150, 20, 310, 60);
        eventNameLbl.text = @"Event Name";
        eventNameLbl.textColor = [UIColor whiteColor];
        eventNameLbl.textAlignment = NSTextAlignmentLeft;
        eventNameLbl.backgroundColor = [UIColor clearColor];
        eventNameLbl.font = [UIFont fontWithName:@"Century Gothic" size:30.0f];
        [header addSubview:eventNameLbl];
        
        UIImageView * startdateIcon = [[UIImageView alloc]init];
        startdateIcon.frame = CGRectMake(470, 40, 68, 66);
        startdateIcon.backgroundColor = [UIColor clearColor];
        startdateIcon.image = [UIImage imageNamed:@"calender_grey.png"];
        [header addSubview:startdateIcon];
        
        startMonthLbl = [[UILabel alloc]init];
        startMonthLbl.frame = CGRectMake(0, 15, 68, 20);
        startMonthLbl.text = @"JUNE";
        startMonthLbl.textColor = [UIColor blackColor];
        startMonthLbl.textAlignment = NSTextAlignmentCenter;
        startMonthLbl.backgroundColor = [UIColor clearColor];
        startMonthLbl.font = [UIFont fontWithName:@"Century Gothic" size:12.0f];
        [startdateIcon addSubview:startMonthLbl];
        
        startDateLbl = [[UILabel alloc]init];
        startDateLbl.frame = CGRectMake(0, 30, 68, 36);
        startDateLbl.text = @"18";
        startDateLbl.textColor = [UIColor blackColor];
        startDateLbl.textAlignment = NSTextAlignmentCenter;
        startDateLbl.backgroundColor = [UIColor clearColor];
        startDateLbl.font = [UIFont fontWithName:@"Century Gothic" size:30.0f];
        [startdateIcon addSubview:startDateLbl];
        
        UILabel * start = [[UILabel alloc]init];
        start.frame = CGRectMake(470, 110, 68, 20);
        start.text = @"START";
        start.textColor = [UIColor whiteColor];
        start.textAlignment = NSTextAlignmentCenter;
        start.backgroundColor = [UIColor clearColor];
        start.font = [UIFont fontWithName:@"Century Gothic" size:15.0f];
        [header addSubview:start];
        
        
        UIImageView * enddateIcon = [[UIImageView alloc]init];
        enddateIcon.frame = CGRectMake(570, 40, 68, 66);
        enddateIcon.backgroundColor = [UIColor clearColor];
        enddateIcon.image = [UIImage imageNamed:@"calender_grey.png"];
        [header addSubview:enddateIcon];
        
        endMonthLbl = [[UILabel alloc]init];
        endMonthLbl.frame = CGRectMake(0, 15, 68, 20);
        endMonthLbl.text = @"JUNE";
        endMonthLbl.textColor = [UIColor blackColor];
        endMonthLbl.textAlignment = NSTextAlignmentCenter;
        endMonthLbl.backgroundColor = [UIColor clearColor];
        endMonthLbl.font = [UIFont fontWithName:@"Century Gothic" size:12.0f];
        [enddateIcon addSubview:endMonthLbl];
        
        endDateLbl = [[UILabel alloc]init];
        endDateLbl.frame = CGRectMake(0, 30, 68, 36);
        endDateLbl.text = @"18";
        endDateLbl.textColor = [UIColor blackColor];
        endDateLbl.textAlignment = NSTextAlignmentCenter;
        endDateLbl.backgroundColor = [UIColor clearColor];
        endDateLbl.font = [UIFont fontWithName:@"Century Gothic" size:30.0f];
        [enddateIcon addSubview:endDateLbl];
        
        UILabel * end = [[UILabel alloc]init];
        end.frame = CGRectMake(570, 110, 68, 20);
        end.text = @"FINISH";
        end.textColor = [UIColor whiteColor];
        end.textAlignment = NSTextAlignmentCenter;
        end.backgroundColor = [UIColor clearColor];
        end.font = [UIFont fontWithName:@"Century Gothic" size:15.0f];
        [header addSubview:end];
        

        UIImageView * locationIcon = [[UIImageView alloc]init];
        locationIcon.frame = CGRectMake(150, 90, 28-5, 37-5);
        locationIcon.backgroundColor = [UIColor clearColor];
        locationIcon.image = [UIImage imageNamed:@"venue_grey.png"];
        [header addSubview:locationIcon];
        
        locationLbl = [[UILabel alloc]init];
        locationLbl.frame = CGRectMake(190, 90, 270, 30);
        locationLbl.text = @"Location";
        locationLbl.textColor = [UIColor lightGrayColor];
        locationLbl.textAlignment = NSTextAlignmentLeft;
        locationLbl.backgroundColor = [UIColor clearColor];
        locationLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [header addSubview:locationLbl];
        
      
    }
    return self;
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
