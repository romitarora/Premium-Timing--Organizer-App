//
//  participantListCell.m
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "participantListCell.h"

@implementation participantListCell
@synthesize idLbl,flagImg,nameLbl,headerView,checkImg,nationalityLbl,temp,unverifiedLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        headerView = [[UIView alloc]init];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 60);
        headerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:headerView];
        
        idLbl = [[UILabel alloc]init];
        idLbl.frame = CGRectMake(10, 10, 80, 40);
        idLbl.text = @"12";
        idLbl.textColor = [UIColor whiteColor];
        idLbl.textAlignment = NSTextAlignmentCenter;
        idLbl.backgroundColor = [UIColor clearColor];
        idLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [headerView addSubview:idLbl];
        
        temp = [[UIView alloc]init];
        temp.frame = CGRectMake(100, 10, 370, 40);
        temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow1.png"]];
        // BY RAJU 9-7-2015
        [self.contentView addSubview:temp];
        
        nameLbl = [[UILabel alloc]init];
        nameLbl.frame = CGRectMake(10, 0, 220, 40);
        nameLbl.text = @"Event Name";
        nameLbl.textColor = [UIColor blackColor];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [temp addSubview:nameLbl];
        
        unverifiedLbl = [[UILabel alloc]init];
        unverifiedLbl.frame = CGRectMake(235, 0, 220, 40);
        unverifiedLbl.text = @"Unverified";
        unverifiedLbl.textColor = [UIColor whiteColor];
        unverifiedLbl.textAlignment = NSTextAlignmentLeft;
        unverifiedLbl.backgroundColor = [UIColor clearColor];
        unverifiedLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [temp addSubview:unverifiedLbl];
        
        nationalityLbl = [[UILabel alloc]init];
        nationalityLbl.frame = CGRectMake(470, 10, 150, 40);
        nationalityLbl.text = @"Country Name";
        nationalityLbl.textColor = [UIColor whiteColor];
        nationalityLbl.textAlignment = NSTextAlignmentLeft;
        nationalityLbl.backgroundColor = [UIColor clearColor];
        nationalityLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [headerView addSubview:nationalityLbl];
        
        checkImg = [[UIImageView alloc]init];
        checkImg.frame = CGRectMake(625, 18.05, 25, 23);
        checkImg.image = [UIImage imageNamed:@""];
        checkImg.layer.cornerRadius = 12.5f;
        checkImg.backgroundColor = [UIColor clearColor];
        [headerView addSubview:checkImg];
        
        
    }
    return self;
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
