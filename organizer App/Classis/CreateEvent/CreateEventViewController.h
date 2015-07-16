//
//  CreateEventViewController.h
//  organizer App
//
//  Created by Romit on 01/06/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddParticipantsView.h"
#import <MapKit/MapKit.h>
#import "URLManager.h"
#import "Reachability.h"
@class AppDelegate;
@interface CreateEventViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate,MKMapViewDelegate,URLManagerDelegate,CLLocationManagerDelegate>
{
    AppDelegate * app;
    NSInteger yy;
    UIView * navView;
    UIButton * backBtn;
    UIButton * saveBtn;
    UILabel * titleLbl;
    UIScrollView * scrollContent;
    UITableView * eventDetailTbl;
    UITableView * stageDetailTbl;
    
    NSString * eventId;
    
    UILabel * eventNameLbl;
    UILabel * shortDescLbl;
    UILabel * categoryLbl;
    UILabel * startTimeLbl;
    UILabel * locationLbl;
    UILabel * racetypeLbl;
    UILabel * raceStartLbl;
    UILabel * DescriptionLbl;
    UILabel * stagesLbl;
    UILabel * splitsLbl;
    UILabel * websiteLbl;
    UILabel * browseImgLbl;
    UILabel * roleLbl;
    UILabel * competitorsLbl;
    UILabel * sponsorLbl;
    UILabel * routemapLbl;
    UILabel * ageLbl;
    UILabel * categoryNameLbl;
    UILabel * lbl;
    UILabel * eventDateLbl;
    UILabel * manualStartLbl;
    UILabel * participantNumerLbl;
    UILabel * sponsorNumberLbl;
    UILabel * startMethodLbl;
    UILabel * endDateTimeLbl;
    UILabel * detailLbl;
    UILabel * genralLbl;
    UILabel * routMapLbl;
    UILabel * stagesTitleLbl;
    UILabel * selectedViewLbl;
    UILabel * organiserNameLbl;
    
    
    UITextField * txtname;
    UITextField * txtAge;
    UITextField * txtLocation;
    UITextField * txtWebsite;
    UITextField * txtOrganiserName;
    
    UITextView * txtDescription;
    UITextView * txtShortDescription;
    
    UIButton * categoryBtn;;
    UIButton * selectDateBtn;
    UIButton * raceListBtn;
    UIButton * raceStartBtn;
    UIButton * addStagesBtn;
    UIButton * addSplitsBtn;
    UIButton * startTimeBtn;
    UIButton * participantsBtn;
    UIButton * sponsorsBtn;
    UIButton * endDateTimeBtn;
    UIButton * btnNext;
    UIButton * btnNext1;
    UIButton * addImageBtn;
    UIButton * profileBtn1;
    UIButton * profileBtn2;
    UIButton * profileBtn3;
    
    UIImageView * calenderIconImg;
    UIImageView * addStagesImg;
    UIImageView * addSplitsImg;
    UIImageView * profileImg1;
    UIImageView * profileImg2;
    UIImageView * profileImg3;
    UIImageView * backimg;
    
    UIView * pickerView;
    UIView * tapbarView;
    UIView * headerView;
    UIView * generalView;
    UIView * stagesView;
    UIView * routeMapView;
    
    
    UIDatePicker * startDate;
    UIDatePicker * startTime;
    UIDatePicker * endDateTime;
    
    
    BOOL isCollapsed;
    BOOL EditProfile1;
    BOOL EditProfile2;
    BOOL EditProfile3;
    BOOL isValidDate;
    
    NSString * globalStr;
    UISwitch * manualSwitch;
    
    NSMutableDictionary * eventdetailDict;
    NSMutableArray * categoryArr;
    NSMutableArray * raceTypeArr;
    NSMutableArray * methodArr;
    NSMutableArray * ageCategoryArr;
    NSMutableArray * totalStages;
    NSMutableArray * totalSplits;
    NSMutableArray * totalImages;
    
    NSInteger imagePicFlag;
    NSInteger stageIndex;
    UIImagePickerController *imagePicker;
    
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
    
    int startingCount;
    NSString * appLatitude,*appLongitude;
    NSMutableArray * trackpointArray;
    CLLocationManager * locationManager;
    NSMutableArray * savedLocationLatLong;
    NSMutableDictionary *savedLatLndDict;
    
    NSMutableArray * mapStagesArr;
    NSMutableArray * mapSplitsArr;
    NSMutableArray * routeMapArr;
    UIButton * startTrackBtn;
    UIButton * stopTrackBtn;
    BOOL isTracking;
    
}
@property(nonatomic,strong)NSMutableDictionary * editDict;
@property (nonatomic, strong) UIPopoverController *popOver;
@property BOOL isFromEdit;
@property BOOL isFromStages;
@property (strong)UIPopoverController * pop;
@property (nonatomic , strong)NSString * mainId;
@property (nonatomic , strong)NSString * eventName;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic , strong)NSString * tableId;

// load the points of the route from the data source, in this case
// a CSV file.
-(void) loadRoute;
// use the computed _routeRect to zoom in on the route.
-(void) zoomInOnRoute;

@end
