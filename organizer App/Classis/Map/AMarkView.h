//
//  AMarkView.h
//  AJMapView
//
//  Created by Oneclick IT Solution on 7/23/14.
//  Copyright (c) 2014 One Click IT Consultancy Pvt Ltd, Ind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMarkView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *latLbl;
@property (weak, nonatomic) IBOutlet UILabel *longLbl;
@property (weak, nonatomic) IBOutlet UIButton *callOutButton;

@end
