//
//  ExploreCell.m
//  Glam
//
//  Created by One Click IT Consultancy  on 7/9/15.
//  Copyright (c) 2015 One Click IT Consultancy Pvt Ltd. All rights reserved.
//

#import "ExploreCell.h"

@implementation ExploreCell
@synthesize scrolImag,pageController,imgType,imgView,imgOffer,btnAddProduct,btnMens,btnPapular,btnGrid,lblDescription,lblPrice,lblLink;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        scrolImag = [[UIScrollView alloc] init];
        
        scrolImag.showsHorizontalScrollIndicator = NO;
        scrolImag.showsVerticalScrollIndicator=NO;
        scrolImag.pagingEnabled = YES;
        scrolImag.delegate = self;
        
        pageController = [[UIPageControl alloc] init];
        
        pageController.tintColor = [UIColor blackColor];
        //  pageControl.backgroundColor = [UIColor blackColor];
        pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageController.currentPageIndicatorTintColor = [UIColor blackColor];
     

        
        imgType = [[AsyncImageView alloc] init];
        imgView = [[AsyncImageView alloc] init];
        imgOffer=[[AsyncImageView alloc] init];
        
        btnAddProduct=[[UIButton alloc]init];
        btnMens=[[UIButton alloc]init];
        btnPapular=[[UIButton alloc]init];
        btnGrid=[[UIButton alloc]init];
        
        lblDescription=[[UILabel alloc]init];
        lblPrice=[[UILabel alloc]init];
        lblLink=[[UILabel alloc]init];
    }
    [self.contentView addSubview:scrolImag];
//    [self.contentView addSubview:pageController];
//    [self.contentView addSubview:imgType];
//    [self.contentView addSubview:imgView];
//    [self.contentView addSubview:imgOffer];
//    [self.contentView addSubview:btnAddProduct];
//    [self.contentView addSubview:btnMens];
//    [self.contentView addSubview:btnPapular];
//    [self.contentView addSubview:btnGrid];
//    [self.contentView addSubview:lblDescription];
//    [self.contentView addSubview:lblPrice];
//    [self.contentView addSubview:lblLink];

    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
