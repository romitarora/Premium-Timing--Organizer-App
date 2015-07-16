//
//  os4MapsViewController.h
//  os4Maps
//
//  Created by Craig Spitzkoff on 7/4/10.
//  Copyright Craig Spitzkoff 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface os4MapsViewController : UIViewController <MKMapViewDelegate>{

	// the map view
	MKMapView* _mapView;
	
	// the data representing the route points. 
	MKPolyline* _routeLine;
	

	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

// load the points of the route from the data source, in this case
// a CSV file. 
-(void) loadRoute;

// use the computed _routeRect to zoom in on the route. 
-(void) zoomInOnRoute;


@end

