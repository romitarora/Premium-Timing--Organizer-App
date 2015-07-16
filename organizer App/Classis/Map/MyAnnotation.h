//
//  MyAnnotation.h
//  os4Maps
//
//  Created by one click IT consultany on 6/22/15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>
{
    
    CLLocationCoordinate2D coordinate;
    
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
