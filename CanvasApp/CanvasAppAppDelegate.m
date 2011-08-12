//
//  CanvasAppAppDelegate.m
//  CanvasApp
//
//  Created by Klint Holmes on 5/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CanvasAppAppDelegate.h"
#import "CalendarDataSource.h"
#import "CanvasAppViewController.h"
#import "Kal.h"
//#import "CalendarDataSource.h"

@implementation CanvasAppAppDelegate


@synthesize window=_window;

@synthesize navController=_viewController;
@synthesize calendar, source, courseID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    courseID = [[NSString alloc] init];
    // Override point for customization after application launch.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelected:) name:@"KalDataSourceChangedNotification" object:nil];
    
    // Calendar for Creating Appointments
	source			= [[CalendarDataSource alloc] init];
	calendar		= [[KalViewController alloc] init];
	calendar.dataSource = source;
	calendar.delegate = self;
    calendar.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Calendar Delegate

- (void)showAndSelectToday {
	[calendar showAndSelectDate:[NSDate date]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
