//
//  ViewTestsViewController.m
//  ViewTests
//
//  Created by Klint Holmes on 1/26/10.
//  Copyright Klint Holmes 2010. All rights reserved.
//

#define LP_INVALIDATE_TIMER(TIMER) { [TIMER invalidate]; TIMER = nil; }

#import "LPButton.h"
#import "KHBadge.h"
#import "LPViewController.h"

@implementation LPViewController

@synthesize editMode;

#pragma mark -
#pragma mark Touch Methods

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	if (!moveButton.edit && !editMode) {
		LP_INVALIDATE_TIMER(moveHoldTimer);
	}
	
	if (moveButton && moveButton.edit) {
		for (UITouch* touch in touches) {
			if (touch == moveTouch) {
				CGPoint origin = [moveTouch locationInView:self.view];
				moveButton.center = CGPointMake(startPoint.x + (origin.x - touchPoint.x),
												startPoint.y + (origin.y - touchPoint.y));
				
				NSInteger items = [buttons count];
				for (int i = 0; i < items; i++)
				{
					NSInteger x = (22 + ((i % 4) * 75 ));
					NSInteger y = (22 + ((i / 4) * 80 ));
					CGRect frame = CGRectMake( x, y, 50, 50);
					if (CGRectContainsPoint(frame, moveButton.center)) {
						if ([buttons objectAtIndex:i] != moveButton) {
							[buttons removeObject:moveButton];
							[buttons insertObject:moveButton atIndex:i];
							
						}
					}
				}

				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:0.3];
				[self layout];
				[UIView commitAnimations];
					
			}
		}
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];

	[moveButton setEdit:NO];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[moveButton setAlpha:1];
	moveButton.badge.alpha = 1;
	moveButton.transform = CGAffineTransformMakeScale(1, 1);
	moveButton = nil;
	[self layout];
	[UIView commitAnimations];
}

- (void)buttonTouchedUpInside:(LPButton *)button {
	if (!moveButton.edit && !editMode) {
		LP_INVALIDATE_TIMER(moveHoldTimer);
		if (button.buttonViewController ) {
			button.buttonViewController.title = button.label.text;
			[self.navigationController pushViewController:button.buttonViewController animated:YES];
		}
	}
}

- (void)buttonTouchedUpOutside:(LPButton *)button {
	if (!moveButton.edit && !editMode) {
		LP_INVALIDATE_TIMER(moveHoldTimer);
	}
}

- (void)buttonTouchedDown:(LPButton *)button withEvent:(UIEvent *)event {
	
	UITouch* touch = [[event allTouches] anyObject];
	touchPoint = [touch locationInView:self.view];
	startPoint = button.center;
	moveButton = button;
	moveTouch = touch;
	self.editMode = NO;
	button.badge.alpha = .80;
	
	LP_INVALIDATE_TIMER(moveHoldTimer);
	moveHoldTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
							target:self selector:@selector(editHoldTimer)
							userInfo:nil
							repeats:NO];
}

- (void)buttonTouchedDragOutside:(LPButton *)button {
	button.badge.alpha = 1.0;
}


- (void)editHoldTimer {
	moveHoldTimer = nil;
	self.editMode = YES;
	[moveButton setEdit:YES];
	[self.view bringSubviewToFront:moveButton];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[moveButton setAlpha:0.75];
	moveButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Layout

- (void)layout {
	NSInteger items = [buttons count];
	for (int i = 0; i < items; i++) {
		NSInteger x = (17 + ((i % 4) * 75 ));
		NSInteger y = (17 + ((i / 4) * 80 ));
		CGRect frame = CGRectMake( x, y, 60, 60);
		LPButton* temp = [buttons objectAtIndex:i];
		if (temp != moveButton) {
			temp.frame = frame;
		}
	}
}

- (void)addLPButton:(NSString *)className {
	CGRect bFrame = CGRectMake(0, 0, 60, 60);
	
	LPButton *button = [[[LPButton alloc] initWithFrame:bFrame] autorelease];
	[button setBackgroundColor:[UIColor clearColor]];
	[button setBackgroundImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
	
	[button setEdit:NO];
	
	[button setButtonViewController:[[NSClassFromString(className) alloc] initWithNibName:className bundle:nil]];
	[button addTarget:self action:@selector(buttonTouchedDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
	[button addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
	[button addTarget:self action:@selector(buttonTouchedDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    //[button se
	
	//if ([button.buttonViewController.title isEqualToString:@"Settings"]) { //Name Icons same as Title or add icon to view controllers
		//NSLog(@"%@", [NSString stringWithFormat:@"%@.png", button.buttonViewController.title]);
		//[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", button.buttonViewController.title]] forState:UIControlStateNormal];
	//}
	[buttons addObject:button];
	[self.view addSubview:button];
}

/*- (void)logout {
	//Clear Saved Username and Password
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[self writeLayoutSettings];
	[defaults setObject:@"" forKey:@"password"];
	
    if (appDelegate.testList != nil) {
        [appDelegate.testList removeAllObjects];
    }
    if (appDelegate.manageList != nil) {
        [appDelegate.manageList removeAllObjects];
    }
    if (appDelegate.summaryList != nil) {
        [appDelegate.summaryList removeAllObjects];
    }
    if (appDelegate.labList != nil) {
        [appDelegate.labList removeAllObjects];
    }
    if (appDelegate.appointmentList != nil) {
        [appDelegate.appointmentList removeAllObjects];
    }
    if (appDelegate.searchList != nil) {
        [appDelegate.searchList removeAllObjects];
    }
	
	//[appDelegate.manageList removeAllObjects];
	//[appDelegate.summaryList removeAllObjects];
	//[appDelegate.labList removeAllObjects];
	//[appDelegate.appointmentList removeAllObjects];
	//[appDelegate.searchList removeAllObjects];
	if ([appDelegate.facebook isSessionValid]) {
		[appDelegate logout];
	}
	
	CTLoginViewController *loginView = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];	
	[self presentModalViewController:loginView animated:YES];
	[loginView release];
}*/

// Load LPButtons to Screen, Set LPButton ViewController and Icon
- (void)viewDidLoad {
    self.title = @"Course View";
	buttons = [[NSMutableArray alloc] init];
    [self loadIcons];
	//appDelegate = (ChiMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadIcons) name:@"loginWillDismiss" object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonBadge:) name:@"updateBadgeNumber" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authThread) name:@"LoginRefresh" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeLayoutSettings) name:@"writeData" object:nil];
	[self readLayoutSettings];
	if ([appDelegate getAuthentication]) {
		CTLoginViewController *loginView = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
		[self presentModalViewController:loginView animated:YES];
		[loginView release];
	} else {
		[self loadIcons];
	}*/
}

// Detach new thread so interface does not freeze while logging in after app is put in background
//- (void)authThread {
//	[self authRefresh];
	//[NSThread detachNewThreadSelector:@selector(authRefresh) toTarget:self withObject:nil];
//}

/*- (void)authRefresh {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([appDelegate getAuthentication]) {
		//;
		CTLoginViewController *loginView = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
		[self presentModalViewController:loginView animated:YES];
		[loginView release];
	} else {
		[self loadIcons];
	}
	//[pool release];
}//apple_tester 5mTra|81*/


- (void)loadIcons {	
	//[self.navigationController popToRootViewControllerAnimated:YES];
	for (int i = 0; i < [buttons count]; i++) {
		LPButton *button = (LPButton *)[buttons objectAtIndex:i];
		[button removeFromSuperview];
		button = nil;
	}
	
	/*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *userPref = [layout objectForKey:[defaults objectForKey:@"username"]];
	if ([userPref count] == 0) {
		userPref = [layout objectForKey:@"default"];
	}*/
	
	[buttons removeAllObjects];
	
	/*if ([userPref count] == 6 && appDelegate.owner) {
		[self addLPButton:@"CTManageTestViewController"];
	}
	
	for (int i = 0; i < [userPref count]; i++) {
		if ([[userPref objectAtIndex:i] isEqualToString:@"CTManageTestViewController"] && !appDelegate.owner) {
			//[self addLPButton:[userPref objectAtIndex:i]];
		} else {
			[self addLPButton:[userPref objectAtIndex:i]];
		}
	}*/

	[self addLPButton:@"CanvasCourseViewController"];
	[self layout];	
}

- (void)updateButtonBadge:(NSNotification *)notification {
	//
}

/*- (NSString *)getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (void)readLayoutSettings  {
	NSString *path = [[self getDocumentsDirectory] stringByAppendingPathComponent:@"layoutPref.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path]) {
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"layoutPref" ofType:@"plist"];  
		[fileManager copyItemAtPath:filePath toPath:path error:nil];
	}
	
	layout = [[NSMutableDictionary alloc] initWithContentsOfFile:path]; 
}

- (void)writeLayoutSettings {
	NSString *path = [[self getDocumentsDirectory] stringByAppendingPathComponent:@"layoutPref.plist"];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 0; i < [buttons count]; i++) {
		LPButton *button = [buttons objectAtIndex:i];
		[array addObject:NSStringFromClass([button.buttonViewController class])];
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[layout setObject:array forKey:[defaults objectForKey:@"username"]];
	[layout writeToFile:path atomically:YES];
	[array release];
}*/

#pragma mark -
#pragma mark Default

- (void)didReceiveMemoryWarning {
	//[appDelegate.navController popToRootViewControllerAnimated:YES];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
