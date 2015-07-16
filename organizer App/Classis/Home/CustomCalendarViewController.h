//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by Michael Azevedo on 21/07/2014.
//  Copyright (c) 2014 Michael Azevedo All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "AppDelegate.h"
#import <EventKit/EventKit.h>
@class AppDelegate;
@interface CustomCalendarViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray * differencedates;
    NSCalendar *gregorian;
    
    UIView *bottemView;
    UIView *navView;
    
    UIButton *btnReports;
    UIButton * btnNoFishing;
    UIButton *btnToday;
    UIButton * btnInfo;
    
    UIButton * btnMenu;
    
    UIImageView * imgMenu;
    
    UIImageView * imgProfile;
    UIImageView * imgAbout;
    UIImageView * imgVessel;
    UIImageView * imgHelp;
    UIImageView * imgPref;
    
    
    UILabel * lblProfile;
    UILabel * lblAbout;
    UILabel * lblVessel;
    UILabel * lblHelp;
    UILabel * lblPref;
    
    
    UIButton * btnProfile;
    UIButton * btnAbout;
    UIButton * btnVessel;
    UIButton * btnHelp;
    UIButton * btnPref;
    UIButton * previousBtn;
    UIButton * nextBtn;
    
    BOOL Isopen;
    //NSMutableArray *temp1;
    
    AppDelegate * appDelegateObj;
    
    UIScrollView * scrollCalender;
    EKEventStore *eventStore;
    NSString *savedEventId;
}
-(void) orientationChanged:(id)object;
@end
