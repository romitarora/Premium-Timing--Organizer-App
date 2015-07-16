//
//  EventDetailsVC.h
//  organizer App
//
//  Created by One Click IT Consultancy  on 5/30/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Leftmenu.h"
#import "AppDelegate.h"
#import "EventScheduleVC.h"
#import <MapKit/MapKit.h>
#import "URLManager.h"
@interface EventDetailsVC : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,URLManagerDelegate>
{
    UIView * navView;
    UIView * backView;
    UIView * sponsorView;
    UIView * participentView;
    UIView * tapbarView;
    UIView * headerView;
    
    
    UIButton * backBtn;
    UIButton * competitorBtn;
    UIButton * sponsorBtn;
    UIButton * editBtn;
    
    UILabel * titleLbl;
    UILabel * dateLbl;
    UILabel * racetypeLbl;
    UILabel * locationLbl;
    UILabel * timeLbl;
    UILabel * categoryLbl;
    UILabel * participantLbl;
    UILabel * sponsorsLbl;
    UILabel * genralLbl;
    UILabel * routMapLbl;
    UILabel * stagesLbl;
    UILabel * selectedViewLbl;
    
    
    UITextView * txtDetail;
    
    UIScrollView * scrlContent;
    UIScrollView * scrlImages;
    UIPageControl *pageControl;
    UITableView * detailViewTbl;
    UITableView * participentsListTbl;
    UITableView * stageDetailTbl;
    
    
    BOOL isClick;
    BOOL isSponsorClick;
    BOOL isparticipentClick;
    
    NSMutableDictionary * detailDict;
    NSMutableArray * detailArr;
    NSMutableArray * totalStages;
    NSString * endTime;
    NSMutableDictionary * eventDetailDict;
    
    
    // the map view
    MKMapView* _mapView;
    
    // the data representing the route points.
    MKPolyline* _routeLine;
    
    
    // the view we create for the line on the map
    MKPolylineView* _routeLineView;
    
    // the rect that bounds the loaded points
    MKMapRect _routeRect;
    
    int routeStagesTotal;
    int routeSplitsTotal;
    
    UIButton * generalBtn,*stageSplitBtn,*mapBtn;
    NSMutableArray *routeMapArr;
    UIPageControl *pageController1 ;
    int totalImagesCount;
    NSMutableArray * totalImgs;
    UIButton * btnNext;
    AppDelegate *app;
    UILabel *noticeMsgLbl;
}
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic,strong)NSString * mainId ;
@property (nonatomic,strong)NSString *  eventName ;
@property (nonatomic,strong)NSString *  tableId ;
@property (nonatomic,strong)NSString * organiserName;//jam15-07-2015

// load the points of the route from the data source, in this case
// a CSV file.
-(void) loadRoute;
// use the computed _routeRect to zoom in on the route.
-(void) zoomInOnRoute;
@end
