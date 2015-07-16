//
//  menucell.m
//  organizer App
//
//  Created by i-MaC on 5/26/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import "menucell.h"

@implementation menucell
@synthesize lblTitle;
@synthesize ImgIcon,headerView,selectedImg;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        headerView  = [[UIView alloc]init];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 60);
        headerView.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:headerView];
        
        lblTitle = [[UILabel alloc]init];
        lblTitle.frame = CGRectMake(60, 10, headerView.frame.size.width-60, 40);
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.font = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        lblTitle.backgroundColor =[UIColor clearColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:lblTitle];
        
        ImgIcon = [[UIImageView alloc]init];
        ImgIcon.frame = CGRectMake(10, 10, 30, 30);
        ImgIcon.backgroundColor =[UIColor clearColor];
        ImgIcon.image = [UIImage imageNamed:@""];
        [headerView addSubview:ImgIcon];
        
        selectedImg  = [[UIImageView alloc]init];
        selectedImg.frame = CGRectMake(headerView.frame.size.width-9, 0, 9, 60);
        selectedImg.image = [UIImage imageNamed:@"selected.png"];
        selectedImg.backgroundColor = [UIColor clearColor];
        [headerView addSubview:selectedImg];
        
        UILabel * lineLbl = [[UILabel alloc]init];
        lineLbl.frame = CGRectMake(60, 59, self.frame.size.width-60, 1);
        lineLbl.backgroundColor =[UIColor darkGrayColor];
        [headerView addSubview:lineLbl];
       
        return self;
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
