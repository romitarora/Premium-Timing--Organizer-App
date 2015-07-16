//
//  AMark.m
//  AJMapView
//
//  Created by Oneclick IT Solution on 7/23/14.
//  Copyright (c) 2014 One Click IT Consultancy Pvt Ltd, Ind. All rights reserved.
//

#import "AMark.h"

@implementation AMark
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title lat:(NSString *)latStr long:(NSString *)longStr type:(NSString *)typeStr withSesstionToken:(NSString *)tokenStr andSessionId:(NSString *)sessionStr withUserId:(NSString *)userId
{
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
        self.latStr=latStr;
        self.longStr=longStr;
        self.type=typeStr;
        self.tokenStr=tokenStr;
        self.sesstionStr=sessionStr;
        self.userId=userId;

       
        
    }
    return self;
}
@end

