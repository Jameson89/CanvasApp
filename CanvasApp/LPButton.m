//
//  dragButton.m
//  ViewTests
//
//  Created by Klint Holmes on 1/26/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//


#import "LPButton.h"
#import "KHBadge.h"
#import <QuartzCore/QuartzCore.h>

@implementation LPButton
@synthesize moving;
@synthesize edit;
@synthesize label;
@synthesize badge;
@synthesize buttonViewController;

- (void)setButtonViewController:(UIViewController *) vc {
	buttonViewController = [vc retain];
	[self createLable:buttonViewController.title];
}

- (void)createLable:(NSString *)labelTitle {
	CGRect lFrame = CGRectMake(-5.0, 53.0, 70.0, 30.0);
	
	label = [[UILabel alloc] initWithFrame:lFrame];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor whiteColor]];
	[label setTextAlignment:UITextAlignmentCenter]; 
	[label setFont:[UIFont systemFontOfSize:12]];
	[label setText:labelTitle];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(0, 1);
	[self addSubview:label];
}

#pragma mark -
#pragma mark Badge Delegate

- (void)showBadge:(NSString *)number {
	badge = [[KHBadge alloc] initWithBadgeNumber:number];
	[self addSubview:badge];
}

- (void)updateBadge:(NSString *)number {
	if (!badge) {
		[self showBadge:number];
	} else if ([number isEqualToString:@"0"]) {
		[badge removeFromSuperview];
		[badge release];
		badge = nil;
	} else {
		[badge removeFromSuperview];
		[self showBadge:number];
	}
}

#pragma mark -
#pragma mark Touch Responders

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	[[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[[self nextResponder] touchesEnded:touches withEvent:event];
}



#pragma mark -

- (void)dealloc {
	[label release];
	[buttonViewController release];
	[super dealloc];
}

@end
