//
//  dragButton.h
//  ViewTests
//
//  Created by Klint Holmes on 1/26/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>

/*typedef enum {
	testList,
	testSummary,
	manageList,
	labUsage,
	campusMap,
	appointmentList,
	settings
} ButtonType;*/

@class KHBadge;

@interface LPButton : UIButton {
	BOOL moving;
	BOOL edit;
	UILabel *label;
	UIViewController *buttonViewController;
	KHBadge *badge;	
}

@property (nonatomic, retain) UIViewController *buttonViewController;
@property (nonatomic) BOOL moving;
@property (nonatomic) BOOL edit;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) KHBadge *badge;

- (void)showBadge:(NSString *)number;
- (void)updateBadge:(NSString *)number;
- (void)createLable:(NSString *)labelTitle;

@end
