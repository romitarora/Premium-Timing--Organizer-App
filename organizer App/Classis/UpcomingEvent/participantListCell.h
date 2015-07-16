//
//  participantListCell.h
//  organizer App
//
//  Created by Romit on 09/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface participantListCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UILabel * idLbl;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UILabel * unverifiedLbl;
@property(nonatomic,strong)UILabel * nationalityLbl;
@property(nonatomic,strong)UIImageView * flagImg;
@property(nonatomic,strong)UIView * headerView;
@property(nonatomic,strong)UIImageView * checkImg;
@property(nonatomic,strong)UIView * temp;
@end
