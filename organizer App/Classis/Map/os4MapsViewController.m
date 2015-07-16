//
//  os4MapsViewController.m
//  os4Maps
//
//  Created by Craig Spitzkoff on 7/4/10.
//  Copyright Craig Spitzkoff 2010. All rights reserved.
//

#import "os4MapsViewController.h"
#import <MapKit/MapKit.h>

#import "UICRouteOverlayMapView.h"
#import "UICRouteAnnotation.h"
#import "MyAnnotation.h"
@implementation os4MapsViewController
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 710, 768)];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
	// create the overlay
	[self loadRoute];
	
	// add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
	
	// zoom in on the route. 
	[self zoomInOnRoute];
    
    
    UIButton * startBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame=CGRectMake(20, 50, 100, 100);
    [startBtn addTarget:self action:@selector(addPinAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:startBtn];
    
	
}

- (void)addPinAnnotation:(id)sender
{
    
//    MyAnnotation *myPin = [[MyAnnotation alloc] initWithCoordinate:self.mapView.centerCoordinate]; // Or whatever coordinates...
//    [self.mapView addAnnotation:myPin];

    
   MyAnnotation *pinAnnotation = [[[MyAnnotation alloc] initWithCoordinate:[self.mapView centerCoordinate]] autorelease];

    [self.mapView addAnnotation:pinAnnotation];
}
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil) {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"] autorelease]; // If you use ARC, take out 'autorelease'
    } else {
        pin.annotation = annotation;
    }
    pin.animatesDrop = YES;
    pin.draggable = YES;
    pin.pinColor=[UIColor purpleColor];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}
// creates the route (MKPolyline) overlay
-(void) loadRoute
{
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	
	// while we create the route points, we will also be calculating the bounding box of our route
	// so we can easily zoom in on it. 
	MKMapPoint northEastPoint; 
	MKMapPoint southWestPoint; 
	
	// create a c array of points. 
	MKMapPoint* pointArr = (malloc(sizeof(CLLocationCoordinate2D) * pointStrings.count));
    

	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
	
		CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
		CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
		 

		// create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

		MKMapPoint point = MKMapPointForCoordinate(coordinate);

		
		//
		// adjust the bounding box
		//
		
		// if it is the first point, just use them, since we have nothing to compare to yet. 
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		}
		else 
		{
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}

		pointArr[idx] = point;

	}
	
	// create the polyline based on the array of points. 
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
    
    

	_routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
		
	// clear the memory allocated earlier for the points
	free(pointArr);
	
}

-(void) zoomInOnRoute
{
	[self.mapView setVisibleMapRect:_routeRect];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}


- (void)dealloc 
{
	self.mapView = nil;
	self.routeLine = nil;
	self.routeLineView = nil;
	
    [super dealloc];
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
			self.routeLineView.fillColor = [UIColor redColor];
			self.routeLineView.strokeColor = [UIColor redColor];
			self.routeLineView.lineWidth = 10;
		}
		
		overlayView = self.routeLineView;
		
	}
	
	return overlayView;
	
}
@end
