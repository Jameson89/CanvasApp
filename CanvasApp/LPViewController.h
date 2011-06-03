//
//  ViewTestsViewController.h
//  ViewTests
//
//  Created by Klint Holmes on 1/26/10.
//  Copyright Klint Holmes 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPButton.h"

@class ChiMobileAppDelegate;

@interface LPViewController : UIViewController {
	NSMutableArray *buttons;
	NSMutableDictionary *layout;
	NSInteger indexPosition;
	CGPoint startPoint;
	CGPoint touchPoint;
	UITouch *moveTouch;
	LPButton *moveButton;
	NSTimer *moveHoldTimer;
	ChiMobileAppDelegate *appDelegate;
	BOOL editMode;
}

@property (nonatomic) BOOL editMode;

- (void)addLPButton:(NSString *)className;
//- (void)writeLayoutSettings;
//- (void)readLayoutSettings;
- (void)updateButtonBadge:(NSNotification *)notification;
- (void)layout;
//- (void)logout;
- (void)loadIcons;
//- (void)authRefresh;

@end

