//
//  CurrentEventSettingVC.h
//  organizer App
//
//  Created by Romit on 02/07/15.
//  Copyright (c) 2015 OneClickITSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Leftmenu.h"
#import "AppDelegate.h"
#import "EventScheduleVC.h"
#import "AddParticipantsView.h"
#import "URLManager.h"
#import <MapKit/MapKit.h>
@interface CurrentEventSettingVC : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UISearchBarDelegate,URLManagerDelegate,UITextFieldDelegate>
{
    UIButton *btnNext;
    UIButton *btnNext2;
    UIButton * btnStartRace;//jam14-07

    NSString *pageNo;
    
    UIView * navView;
    UIView * backView;
    UIView * sponsorView;
    UIView * participentView;
    UIView * tapbarView;
    UIView * headerView;
    
    UIImageView * backimg;
    UIImageView * settingImg;
    
    UIButton * backBtn;
    UIButton * competitorBtn;
    UIButton * sponsorBtn;
    UIButton * editBtn;
    UIButton * addParticipantBtn;
    
    UILabel * titleLbl;
    UILabel * dateLbl;
    UILabel * racetypeLbl;
    UILabel * locationLbl;
    UILabel * timeLbl;
    UILabel * categoryLbl;
    UILabel * participantLbl;
    UILabel * sponsorsLbl;
    UILabel * currentEventLbl;
    UILabel * routMapLbl;
    UILabel * compititorLbl;
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
    
    UIButton * currentBtn,*compititorBtn,*mapBtn,*settingBtn;
    int totalImagesCount;
    NSMutableArray * totalImgs;
    UIPageControl *pageController1;
    NSMutableArray *routeMapArr,*totalParticipants;
    UILabel *noticeMsgLbl;
    
    NSInteger selectedRow;//jam15-07
    BOOL isedit;//jam15-07
    
    UIView * disclimerView;//jam15-07
    UITextView * txtdiscDetail;//jam15-07
    UIButton * agreeBtn;//jam15-07
    UIButton * disagree;//jam15-07
    UIButton * closeBtn;//jam15-07

    // For add compititor
    
    UIView * addparticipants;//jam15-07
    UIView * addNewComititor;//jam15-07
    UIView * numberView;//jam15-07
    
    UIButton * saveBtn;//jam15-07
    UIButton * cancelBtn;//jam15-07
    UIButton * addBtn;//jam15-07
    
    UISearchBar * PTsearchBar;//jam15-07
    UITableView * participantListTbl;//jam15-07
    NSMutableDictionary * participantsDict;//jam15-07
    
    UITextField * txtemail;//jam15-07
    UITextField * txtName;//jam15-07
    UITextField * txtNumberId;//jam15-07
    UITextField * txtNationality;//jam15-07
    
    UILabel * emailLbl;//jam15-07
    UILabel * nameLbl;//jam15-07
    UILabel * numberIdLbl;//jam15-07
    UILabel * nationalityLbl;//jam15-07
    
   
    BOOL isSearching;//jam15-07
    BOOL isFromAdd;//jam15-07
    BOOL isClickNew;//jam15-07
    
    NSMutableArray *filteredContentArray;//jam15-07
    NSMutableArray * newAddedArr;//jam15-07
    NSArray * myArray;//jam15-07
    NSArray * fieldArray;//jam15-07
}
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic,strong)NSString * mainId ;
// load the points of the route from the data source, in this case
// a CSV file.
-(void) loadRoute;
// use the computed _routeRect to zoom in on the route.
-(void) zoomInOnRoute;
@end

