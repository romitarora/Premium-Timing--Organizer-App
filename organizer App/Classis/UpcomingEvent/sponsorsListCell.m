//
//  sponsorsListCell.m
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "sponsorsListCell.h"

@implementation sponsorsListCell
@synthesize headerView,nameLbl,webURL,checkImg;
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
        
        UIView * temp = [[UIView alloc]init];
        temp.frame = CGRectMake(0, 10, 370, 40);
        temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow1.png"]];
        [headerView addSubview:temp];
        
        nameLbl = [[UILabel alloc]init];
        nameLbl.frame = CGRectMake(10, 0, 340, 40);
        nameLbl.text = @"Event Name";
        nameLbl.textColor = [UIColor blackColor];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        [temp addSubview:nameLbl];
        
        
        webURL = [[UILabel alloc]init];
        webURL.frame = CGRectMake(380, 10, 300, 40);
        webURL.text = @"www.apple.com";
        webURL.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        webURL.textAlignment = NSTextAlignmentLeft;
        webURL.backgroundColor = [UIColor clearColor];
        webURL.textColor = [UIColor whiteColor];
        [headerView addSubview:webURL];
        
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
