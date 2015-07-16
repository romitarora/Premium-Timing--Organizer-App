//
//  EventViewCell.m
//  organizer App
//
//  Created by One Click IT Consultancy  on 5/30/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "EventViewCell.h"

@implementation EventViewCell
@synthesize header,timeLbl,locationLbl,eventImage,eventNameLbl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        header = [[UIView alloc]init];
        header.frame = CGRectMake(0, 0, self.frame.size.width, 100);
        header.backgroundColor = [UIColor clearColor];
        header.layer.borderWidth = 1.0;
        header.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.contentView addSubview:header];
        
        eventImage = [[UIImageView alloc]init];
        eventImage.frame = CGRectMake(10, 10, 80, 80);
        eventImage.backgroundColor = [UIColor clearColor];
        eventImage.image = [UIImage imageNamed:@""];
        eventImage.layer.borderWidth = 1.0;
        eventImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [header addSubview:eventImage];
        
        eventNameLbl = [[UILabel alloc]init];
        eventNameLbl.frame = CGRectMake(100, 10, 400, 30);
        eventNameLbl.text = @"Event Name";
        eventNameLbl.textColor = [UIColor whiteColor];
        eventNameLbl.textAlignment = NSTextAlignmentLeft;
        eventNameLbl.backgroundColor = [UIColor clearColor];
        [header addSubview:eventNameLbl];
        
        timeLbl = [[UILabel alloc]init];
        timeLbl.frame = CGRectMake(100, 35, 400, 30);
        timeLbl.text = @"3:30 pm to 5 pm";
        timeLbl.textColor = [UIColor whiteColor];
        timeLbl.textAlignment = NSTextAlignmentLeft;
        timeLbl.backgroundColor = [UIColor clearColor];
        [header addSubview:timeLbl];
        
        locationLbl = [[UILabel alloc]init];
        locationLbl.frame = CGRectMake(100, 65, 400, 30);
        locationLbl.text = @"Location";
        locationLbl.textColor = [UIColor whiteColor];
        locationLbl.textAlignment = NSTextAlignmentLeft;
        locationLbl.backgroundColor = [UIColor clearColor];
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
