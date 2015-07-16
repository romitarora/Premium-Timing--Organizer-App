
#import "CalendarView.h"

@interface CalendarView()

// Gregorian calendar
@property (nonatomic, strong) NSCalendar *gregorian;

// Selected day
@property (nonatomic, strong) NSDate * selectedDate;

// Width in point of a day button
@property (nonatomic, assign) NSInteger dayWidth;

// NSCalendarUnit for day, month, year and era.
@property (nonatomic, assign) NSCalendarUnit dayInfoUnits;

// Array of label of weekdays
@property (nonatomic, strong) NSArray * weekDayNames;

// View shake
@property (nonatomic, assign) NSInteger shakes;
@property (nonatomic, assign) NSInteger shakeDirection;

// Gesture recognizers
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeleft;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeRight;



@end
@implementation CalendarView

#pragma mark - Init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dayWidth                   = frame.size.width/8;
        _originX                    = (frame.size.width - 7*_dayWidth)/2;
        _gregorian                  = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _borderWidth                = 4;
        _originY                    = _dayWidth;
        _calendarDate               = [NSDate date];
        _dayInfoUnits               = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        _monthAndDayTextColor       = [UIColor brownColor];
        _dayBgColorWithoutData      = [UIColor whiteColor];
        _dayBgColorWithData         = [UIColor whiteColor];
        _dayBgColorSelected         = [UIColor brownColor];
        
        _dayTxtColorWithoutData     = [UIColor brownColor];;
        _dayTxtColorWithData        = [UIColor brownColor];
        _dayTxtColorSelected        = [UIColor whiteColor];
        
        _borderColor                = [UIColor brownColor];
        _allowsChangeMonthByDayTap  = NO;
        _allowsChangeMonthByButtons = NO;
        _allowsChangeMonthBySwipe   = YES;
        _hideMonthLabel             = NO;
        _keepSelDayWhenMonthChange  = NO;
        
        _nextMonthAnimation         = UIViewAnimationOptionTransitionCrossDissolve;
        _prevMonthAnimation         = UIViewAnimationOptionTransitionCrossDissolve;
        
        _defaultFont                = [UIFont fontWithName:@"Century Gothic" size:20.0f];
        _titleFont                  = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        
        
        _swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showNextMonth)];
        _swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeleft];
        _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPreviousMonth)];
        _swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_swipeRight];
        
        NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:[NSDate date]];
        components.hour         = 0;
        components.minute       = 0;
        components.second       = 0;
        
        
        // BY RAJU 9-7-2015
        
        
        if (lastdate!=nil) {
            _selectedDate=lastdate;
        }
        else
        {
            _selectedDate = [_gregorian dateFromComponents:components];
        }
        NSArray * shortWeekdaySymbols = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
        _weekDayNames  = @[shortWeekdaySymbols[1], shortWeekdaySymbols[2], shortWeekdaySymbols[3], shortWeekdaySymbols[4],
                           shortWeekdaySymbols[5], shortWeekdaySymbols[6], shortWeekdaySymbols[0]];
        
        self.backgroundColor = [UIColor clearColor];
        
        //        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showNextMonth" object:nil];
        //
        //        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showPreviousMonth" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextMonth) name:@"showNextMonth" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPreviousMonth) name:@"showPreviousMonth" object:nil];
        self.frame=CGRectMake(0, 80, 704,768-80);
        
        
    }
    return self;
}

-(id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 768, 1024)];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Custom setters

-(void)setAllowsChangeMonthByButtons:(BOOL)allows
{
    _allowsChangeMonthByButtons = allows;
    [self setNeedsDisplay];
}

-(void)setAllowsChangeMonthBySwipe:(BOOL)allows
{
    _allowsChangeMonthBySwipe   = allows;
    _swipeleft.enabled          = allows;
    _swipeRight.enabled         = allows;
}

-(void)setHideMonthLabel:(BOOL)hideMonthLabel
{
    _hideMonthLabel = hideMonthLabel;
    [self setNeedsDisplay];
}

-(void)setSelectedDate:(NSDate *)selectedDate
{
    //    if (lastcaldate!=nil) {
    //        _selectedDate = lastcaldate;
    //
    //    }
    //    else
    //    {
    _selectedDate = selectedDate;
    //    }
    [self setNeedsDisplay];
}

-(void)setCalendarDate:(NSDate *)calendarDate
{
    
    
    //    if (lastcaldate!=nil) {
    //
    //    }
    //    else
    //    {
    //
    _calendarDate = calendarDate;
    
    [self setNeedsDisplay];
}


#pragma mark - Public methods

-(void)showNextMonth
{
    
    NSDateFormatter *format         = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    components.day = 1;
    components.month ++;
    NSDate * nextMonthDate =[_gregorian dateFromComponents:components];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _calendarDate = nextMonthDate;
    components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    if (!_keepSelDayWhenMonthChange)
    {
        _selectedDate = [_gregorian dateFromComponents:components];
    }
    [self performViewAnimation:_nextMonthAnimation];
}


-(void)showPreviousMonth
{
    NSDateFormatter *format         = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM"];
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    components.day = 1;
    components.month --;
    NSDate * prevMonthDate = [_gregorian dateFromComponents:components];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _calendarDate = prevMonthDate;
    components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    if (!_keepSelDayWhenMonthChange)
    {
        _selectedDate = [_gregorian dateFromComponents:components];
    }
    [self performViewAnimation:_prevMonthAnimation];
}

#pragma mark - Various methods


-(NSInteger)buttonTagForDate:(NSDate *)date
{
    NSDateComponents * componentsDate       = [_gregorian components:_dayInfoUnits fromDate:date];
    NSDateComponents * componentsDateCal    = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    if (componentsDate.month == componentsDateCal.month && componentsDate.year == componentsDateCal.year)
    {
        // Both dates are within the same month : buttonTag = day
        return componentsDate.day;
    }
    else
    {
        //  buttonTag = deltaMonth * 40 + day
        NSInteger offsetMonth =  (componentsDate.year - componentsDateCal.year)*12 + (componentsDate.month - componentsDateCal.month);
        return componentsDate.day + offsetMonth*40;
    }
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    if (_datasource == nil)
        return YES;
    return [_datasource canSwipeToDate:date];
}

-(void)performViewAnimation:(UIViewAnimationOptions)animation
{
    NSDateComponents * components = [_gregorian components:_dayInfoUnits fromDate:_selectedDate];
    
    NSDate *clickedDate = [_gregorian dateFromComponents:components];
    //    [_delegate dayChangedToDate:clickedDate];
    
    [UIView transitionWithView:self
                      duration:0.5f
                       options:animation
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}

-(void)performViewNoSwipeAnimation
{
    _shakeDirection = 1;
    _shakes = 0;
    [self shakeView:self];
}

// Taken from http://github.com/kosyloa/PinPad
-(void)shakeView:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.05 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_shakeDirection, 0);
         
     } completion:^(BOOL finished)
     {
         if(_shakes >= 4)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         _shakes++;
         _shakeDirection = _shakeDirection * -1;
         [self shakeView:theOneYouWannaShake];
     }];
}

#pragma mark - Button creation and configuration

-(UIButton *)dayButtonWithFrame:(CGRect)frame
{
    UIButton *button                = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font          = _defaultFont;
    button.frame                    = frame;
    button.layer.borderColor        = _borderColor.CGColor;
    [button     addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)configureDayButton:(UIButton *)button withDate:(NSDate*)date withType:(NSString *)type
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
    [button setTitle:[NSString stringWithFormat:@"%ld",(long)components.day] forState:UIControlStateNormal];
    button.tag = [self buttonTagForDate:date];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSDateComponents* components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    // Unselected button
    button.layer.borderWidth = _borderWidth/2.f;
    [button setTitleColor:_dayTxtColorWithoutData forState:UIControlStateNormal];
    [button setBackgroundColor:_dayBgColorWithoutData];
    NSDateFormatter * myFormat =[[NSDateFormatter alloc] init];
    [myFormat setDateFormat:@"dd-MM-yyyy"];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:90.0/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1]];
    button.enabled=YES;
    if ([components1 month]==[components2 month])
    {
        button.enabled=YES;
    }
    else
    {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:90.0/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1]];
        button.enabled=YES;
        button.alpha=1.0;
    }
    
    if ([type isEqualToString:@"current"])
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor yellowColor]];
        
    }
    else
    {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:90.0/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1]];
        
    }
    
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:24]];
    
    button.enabled=YES;
    
    NSDateComponents * componentsDateCal = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    if (components.month != componentsDateCal.month)
        button.alpha = 1.0f;
}

#pragma mark - Action methods

-(IBAction)tappedDate:(UIButton *)sender
{
    
    
    
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    
    
    
    if (sender.tag < 0 || sender.tag >= 40)
    {
        // The day tapped is in another month than the one currently displayed
        
        /* if (!_allowsChangeMonthByDayTap)
         return;
         
         NSInteger offsetMonth   = (sender.tag < 0)?-1:1;
         NSInteger offsetTag     = (sender.tag < 0)?40:-40;
         
         // otherMonthDate set to beginning of the next/previous month
         components.day = 1;
         components.month += offsetMonth;
         NSDate * otherMonthDate =[_gregorian dateFromComponents:components];
         
         if ([self canSwipeToDate:otherMonthDate])
         {
         [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         _calendarDate = otherMonthDate;
         
         // New selected date set to the day tapped
         components.day = sender.tag + offsetTag;
         _selectedDate = [_gregorian dateFromComponents:components];
         
         
         
         UIViewAnimationOptions animation = (offsetMonth >0)?_nextMonthAnimation:_prevMonthAnimation;
         
         // Animate the transition
         [self performViewAnimation:animation];
         }
         else
         {
         [self performViewNoSwipeAnimation];
         }
         return;*/
    }
    
    // Day taped within the the displayed month
    NSDateComponents * componentsDateSel = [_gregorian components:_dayInfoUnits fromDate:_selectedDate];
    //        if(componentsDateSel.day != sender.tag || componentsDateSel.month != components.month || componentsDateSel.year != components.year)
    //        {
    // Let's keep a backup of the old selectedDay
    //        NSDate * oldSelectedDate = [_selectedDate copy];
    
    // We redifine the selected day
    componentsDateSel.day       = sender.tag;
    componentsDateSel.month     = components.month;
    componentsDateSel.year      = components.year;
    _selectedDate               = [_gregorian dateFromComponents:componentsDateSel];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    NSDateComponents* components12 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_selectedDate];
    
    
    
    
    
    /*
     // Configure  the new selected day button
     [self configureDayButton:sender             withDate:_selectedDate withType:@"same"];
     
     // Configure the previously selected button, if it's visible
     UIButton *previousSelected =(UIButton *) [self viewWithTag:[self buttonTagForDate:oldSelectedDate]];
     if (previousSelected)
     [self configureDayButton:previousSelected   withDate:oldSelectedDate withType:@"same"];*/
    
    // Finally, notify the delegate
    /* if ([components12 day]<= [components1 day])
     {
     [_delegate dayChangedToDate:_selectedDate];
     
     }
     else
     {
     
     }*/
    
    
    [_delegate dayChangedToDate:_selectedDate];//jam01-06-2015
    lastdate=_selectedDate;
    
    
    
    
}

#pragma mark - Drawing methods

- (void)drawRect:(CGRect)rect
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    components.day = 1;
    NSDate *firstDayOfMonth         = [_gregorian dateFromComponents:components];
    NSDateComponents *comps         = [_gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    
    NSInteger weekdayBeginning      = [comps weekday];  // Starts at 1 on Sunday
    weekdayBeginning -=2;
    if(weekdayBeginning < 0)
        weekdayBeginning += 7;                          // Starts now at 0 on Monday
    
    NSRange days = [_gregorian rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:_calendarDate];
    
    NSInteger monthLength = days.length;
    
    
    // Month label
    NSDateFormatter *format         = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM yyyy"];
    
    NSString *dateString            = [[format stringFromDate:_calendarDate] uppercaseString];
    [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"currentMonth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMonthName" object:nil];
    
    
    // Day labels
    __block CGRect frameWeekLabel = CGRectMake(0, 0,90,40);
    [_weekDayNames  enumerateObjectsUsingBlock:^(NSString * dayOfWeekString, NSUInteger idx, BOOL *stop)
     {
         frameWeekLabel.origin.x         = _originX+(90*idx);
         UILabel *weekNameLabel          = [[UILabel alloc] initWithFrame:frameWeekLabel];
         weekNameLabel.text              = dayOfWeekString;
         weekNameLabel.textColor         = _monthAndDayTextColor;
         weekNameLabel.font              = _defaultFont;
         weekNameLabel.backgroundColor   = [UIColor clearColor];
         weekNameLabel.textAlignment     = NSTextAlignmentCenter;
         [weekNameLabel setFont:[UIFont systemFontOfSize:24.0]];
         
         [self addSubview:weekNameLabel];
     }];
    
    
    NSMutableArray * allDateArr =[[NSMutableArray alloc] init];
    allDateArr=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"allEventReports"] mutableCopy];
    
    
    for (NSInteger i= 0; i<monthLength; i++)
    {
        components.day      = i+1;
        NSInteger offsetX   = (90*((i+weekdayBeginning)%7));
        NSInteger offsetY   = (90 *((i+weekdayBeginning)/7));
        UIButton *button    = [self dayButtonWithFrame:CGRectMake(_originX+offsetX, 80+offsetY+((i+weekdayBeginning)/7)*10, 90, 90+10)];
        
        if ([components month]==3)
        {
            
            //            offsetX=(80*((i+weekdayBeginning)%7));
            //            offsetY=(80 *((i+weekdayBeginning)/7));
            button.frame=CGRectMake(_originX+offsetX, 80+offsetY+((i+weekdayBeginning)/7)*10-30,90, 90+10);
        }
        
        
        NSDateFormatter * dFrmt =[[NSDateFormatter alloc] init];
        [dFrmt setDateFormat:@"yyyy-MM-dd"];
        NSString * cmpDatestr =[dFrmt stringFromDate:[_gregorian dateFromComponents:components]];
        
        BOOL isAvail =NO;
        
        for (int kp=0; kp<[allDateArr count]; kp++)
        {
            
            if ([[[allDateArr objectAtIndex:kp] objectForKey:@"event_date"] isEqualToString:cmpDatestr])
            {
                isAvail=YES;
                [self configureDayButton:button withDate:[_gregorian dateFromComponents:components]withType:@"current"];
                button.enabled=YES;
                break;
                
            }
            else
            {
                isAvail=NO;
            }
        }
        
        
        
        if (isAvail)
        {
            
        }
        else
        {
            [self configureDayButton:button withDate:[_gregorian dateFromComponents:components]withType:@"other"];
        }
        [self addSubview:button];
    }
    
    
}

-(void)reportBtnClick
{
    [_delegate dayChangedToDate:[NSDate date]];
    
}
@end
