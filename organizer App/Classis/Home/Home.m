//
//  Home.m
//  Premium Timing App
//
//  Created by Romit on 04/05/15.
//  Copyright (c) 2015 oneclick. All rights reserved.
//

#import "Home.h"
#import "MFSideMenu.h"

@interface Home ()

@end

@implementation Home
@synthesize selectedDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden=YES;
    [self setupMenuBarButtonItems];
    self.title=@"Home";
    
    tblMenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height))];
    tblMenu.delegate=self;
    tblMenu.dataSource=self;
    
    [self.view addSubview:tblMenu];
    
    
    if (IS_IPAD)
    {
        NSLog(@"UIInterfaceOrientationPortrait");
        tblMenu.frame=CGRectMake(0, 0, 768, 1024);
        
        
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            NSLog(@"UIInterfaceOrientationLandscapeLeft");
                    tblMenu.frame=CGRectMake(0, 0, 1024,768);
        }
        if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            NSLog(@"UIInterfaceOrientationLandscapeRight");
                    tblMenu.frame=CGRectMake(0, 0, 1024, 768);
        }

        
    }
    
    
	// Do any additional setup after loading the view.
}







#pragma mark - Table View Data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *stringForCell;
    stringForCell= [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    [cell.textLabel setText:stringForCell];
    return cell;
}

#pragma mark - ==================================================
#pragma mark - ==================================================
#pragma mark - TableView delegate
#pragma mark - ==================================================
#pragma mark - ==================================================


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%ld Row:%ld selected and its data is %@",
          (long)indexPath.section,(long)indexPath.row,cell.textLabel.text);
}

- (void)setupMenuBarButtonItems
{
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self])
    {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem
{
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(leftSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)rightMenuBarButtonItem
{
    return Nil;
}

- (UIBarButtonItem *)backBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(backButtonPressed:)];
}
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

-(void)pushview
{

    [self.navigationController pushViewController:Nil animated:YES];
    
}
- (void)rightSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"landscape");
        
        tblMenu.frame=CGRectMake(0, 0, 1024,768);

        
        
    }
    else
    {
        NSLog(@"Portrait");
        tblMenu.frame=CGRectMake(0, 0, 768,1024);

        
    }
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait ||
		interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
	else
    {
		return NO;
	}
    
}







@end
