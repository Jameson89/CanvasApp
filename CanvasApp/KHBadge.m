//
//  KHBadge.m
//  Draw Practice
//
//  Created by Klint Holmes on 6/17/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#define kCornerRadius 10.1
#define kAddjustment 3
#define kFontSize 18

#import "KHBadge.h"
#import <QuartzCore/QuartzCore.h>

@implementation KHBadge

- (id)initWithBadgeNumber:(NSString *)badgeNumber {
	[super init];
	CGSize size;
	size = [badgeNumber sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:kFontSize] constrainedToSize:CGSizeMake(55.0, 25) lineBreakMode:UILineBreakModeCharacterWrap];
	self.frame = CGRectMake(65-(size.width+13), -4, size.width+14, 24);
	
	self.clipsToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(-1, 2);
	self.layer.shadowOpacity = 1.0;	
	self.backgroundColor = [UIColor clearColor];
	
	badge = [[UILabel alloc] initWithFrame:CGRectMake(0.5, -.2, self.frame.size.width, self.frame.size.height)];
	badge.backgroundColor = [UIColor clearColor];
	badge.textColor = [UIColor whiteColor];
	badge.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFontSize];
	badge.textAlignment = UITextAlignmentCenter;
	badge.text = badgeNumber;
	[self addSubview:badge];
	
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
		
	CGContextRef line = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(line, 2.5);  
	CGContextSetRGBStrokeColor(line, 255, 255, 255, 1); 
	[self CGContextAddRoundedRect:rect cornerRadius:kCornerRadius outside:YES];  
	 
	CGContextStrokePath(line); 
	
	CGContextRef fill = UIGraphicsGetCurrentContext();
	[self CGContextAddRoundedRect:rect cornerRadius:kCornerRadius-1 outside:NO];
	CGContextClip(fill);
		
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
    size_t num_locations = 3;
    CGFloat locations[3] = { 0.0, 0.5, 1.0 };
    CGFloat components[12] = { 255./255., 255./255., 255./255., 1.0, // White
							   255./255., 0./255., 0./255., 1.0,     // Red
		                       157./255, 0./0., 6./255., 1.0 };      // Dark Red
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0); 
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)CGContextAddRoundedRect:(CGRect)rect cornerRadius:(int)corner_radius outside:(BOOL)yesOrNo {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	int x_left = rect.origin.x;
	int x_left_center = rect.origin.x + corner_radius;
	int x_right_center = rect.origin.x + rect.size.width - corner_radius;
	int x_right = rect.origin.x + rect.size.width;
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + corner_radius;
	int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
	int y_bottom = rect.origin.y + rect.size.height;
	// Makes the fill circel smaller so there is id does not show on the outside edge
	if (!yesOrNo) {
		x_left += kAddjustment;
		x_right -= kAddjustment;
		y_top += kAddjustment;
		y_bottom -= kAddjustment;
	} else {
		x_left += (kAddjustment-1);
		x_right -= (kAddjustment-1);
		y_top += (kAddjustment-1);
		y_bottom -= (kAddjustment-1);
	}

	// Start
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, x_left, y_top_center);
	
	// First corner 
	CGContextAddArcToPoint(context, x_left, y_top, x_left_center, y_top, corner_radius);
	CGContextAddLineToPoint(context, x_right_center, y_top);
	
	// Second corner
	CGContextAddArcToPoint(context, x_right, y_top, x_right, y_top_center, corner_radius);
	CGContextAddLineToPoint(context, x_right, y_bottom_center);
	
	// Third corner 
	CGContextAddArcToPoint(context, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
	CGContextAddLineToPoint(context, x_left_center, y_bottom);
	
	// Fourth corner
	CGContextAddArcToPoint(context, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
	CGContextAddLineToPoint(context, x_left, y_top_center);
	
	// End
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}


- (void)dealloc {
    [super dealloc];
	[badge release];
}


@end
