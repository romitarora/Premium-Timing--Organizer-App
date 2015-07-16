//
//  ExploreCell.h
//  Glam
//
//  Created by One Click IT Consultancy  on 7/9/15.
//  Copyright (c) 2015 One Click IT Consultancy Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ExploreCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView * scrolImag;
@property (nonatomic , strong) UIPageControl * pageController;
@property (nonatomic ,strong) AsyncImageView * imgType;

@property (nonatomic ,strong) AsyncImageView * imgView;
@property (nonatomic ,strong) AsyncImageView * imgOffer;

@property (nonatomic , strong) UIButton * btnAddProduct;
@property (nonatomic , strong) UIButton * btnMens;
@property (nonatomic , strong) UIButton * btnPapular;
@property (nonatomic , strong) UIButton * btnGrid;

@property (nonatomic , strong) UILabel * lblDescription;
@property (nonatomic , strong) UILabel * lblPrice;
@property (nonatomic , strong) UILabel * lblLink;


@end
