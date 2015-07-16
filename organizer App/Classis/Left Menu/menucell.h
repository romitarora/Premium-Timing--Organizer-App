//
//  menucell.h
//  organizer App
//
//  Created by i-MaC on 5/26/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menucell : UITableViewCell
{
    
}
@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UILabel *lblTitle;
@property(nonatomic,strong)UIImageView *ImgIcon;//jam
@property(nonatomic,strong)UIImageView * selectedImg ;
@end
