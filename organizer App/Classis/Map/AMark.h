//
//  AMark.h
//  AJMapView
//
//  Created by Oneclick IT Solution on 7/23/14.
//  Copyright (c) 2014 One Click IT Consultancy Pvt Ltd, Ind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface AMark:NSObject<MKAnnotation>
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *latStr;
@property (copy, nonatomic) NSString *longStr;
@property (copy, nonatomic) NSString *typeStr;
@property (copy, nonatomic) NSString *tokenStr;
@property (copy, nonatomic) NSString *sesstionStr;
@property (copy, nonatomic) NSString *userId;


@property (weak, nonatomic) IBOutlet UIButton *callOutButton;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title lat:(NSString *)latStr long:(NSString *)longStr type:(NSString *)typeStr withSesstionToken:(NSString *)tokenStr andSessionId:(NSString *)sessionStr withUserId:(NSString *)userId;
@end
