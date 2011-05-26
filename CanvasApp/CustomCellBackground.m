//
//  CustomCellBackground.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "CustomCellBackground.h"
//#import "Common.h"

@implementation CustomCellBackground
@synthesize firstCell = _firstCell;
@synthesize lastCell = _lastCell;
@synthesize selected = _selected;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#define kCornerRadius 10
#define kAddjustment 1

- (void)drawRect:(CGRect)rect {
	
	CGContextRef line = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(line, .1);  
	CGContextSetRGBStrokeColor(line, .4, .4, .4, 1.0); 
	[self CGContextAddRoundedRect:rect cornerRadius:kCornerRadius outside:YES];  
	CGContextStrokePath(line); 
	
	CGContextRef bg = UIGraphicsGetCurrentContext();
	//CGContextSetRGBFillColor(bg, 84./255., 86./255., 94./255., 0.0);
    CGContextSetRGBFillColor(bg, 255./255., 255./255., 255./255., 1.0);
	[self CGContextAddRoundedRect:rect cornerRadius:kCornerRadius-1 outside:NO];
	CGContextFillPath(bg);
	
	CGContextRef fill = UIGraphicsGetCurrentContext();
	[self CGContextAddRoundedRect:rect cornerRadius:kCornerRadius-1 outside:NO];
	CGContextClip(fill);
	
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
    size_t num_locations = 4;
    CGFloat locations[4] = { 0.0, 0.3, .07, 1.0};
    CGFloat components[16] = { 
           // Dark Gray
		0.0, 0.0, 0.0, 0.0,
        0.2, 0.2, 0.2, 0.1,
        0.2, 0.2, 0.2, 0.1,
        0.0, 0.0, 0.0, 0.0// Clear
        
		//1.0, 1.0, 1.0, .15 
    }; // White
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
    //if (_firstCell) { x_left_center += 10; }
	int x_right_center = rect.origin.x + rect.size.width - corner_radius;
   // if (_firstCell) { x_right_center -= 10; }
	int x_right = rect.origin.x + rect.size.width;
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + corner_radius;
    //if (_firstCell) { y_top_center += 10; }
	int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
    //if (_firstCell) { y_bottom_center -= 10; }
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
	
    if (_firstCell && _lastCell) {
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
        
    } else if (_firstCell){
        
        CGContextAddArcToPoint(context, x_left, y_top, x_left_center, y_top, corner_radius);
        CGContextAddLineToPoint(context, x_right_center, y_top);
	
        // Second corner
        CGContextAddArcToPoint(context, x_right, y_top, x_right, y_top_center, corner_radius);
        CGContextAddLineToPoint(context, x_right, y_bottom_center);
	
        // Third corner 
        CGContextAddArcToPoint(context, x_right, y_bottom, x_right_center, y_bottom, 0);
        CGContextAddLineToPoint(context, x_left_center, y_bottom);
	
        // Fourth corner
        CGContextAddArcToPoint(context, x_left, y_bottom, x_left, y_bottom_center, 0);
        CGContextAddLineToPoint(context, x_left, y_top_center);
    } else if (_lastCell) {
       
        CGContextAddArcToPoint(context, x_left, y_top, x_left_center, y_top, 0);
        CGContextAddLineToPoint(context, x_right_center, y_top);
        
        // Second corner
        CGContextAddArcToPoint(context, x_right, y_top, x_right, y_top_center, 0);
        CGContextAddLineToPoint(context, x_right, y_bottom_center);
        
        // Third corner 
        CGContextAddArcToPoint(context, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
        CGContextAddLineToPoint(context, x_left_center, y_bottom);
        
        // Fourth corner
        CGContextAddArcToPoint(context, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
        CGContextAddLineToPoint(context, x_left, y_top_center);
    } else {
        
        CGContextAddArcToPoint(context, x_left, y_top, x_left_center, y_top, 0);
        CGContextAddLineToPoint(context, x_right_center, y_top);
        
        // Second corner
        CGContextAddArcToPoint(context, x_right, y_top, x_right, y_top_center, 0);
        CGContextAddLineToPoint(context, x_right, y_bottom_center);
        
        // Third corner 
        CGContextAddArcToPoint(context, x_right, y_bottom, x_right_center, y_bottom, 0);
        CGContextAddLineToPoint(context, x_left_center, y_bottom);
        
        // Fourth corner
        CGContextAddArcToPoint(context, x_left, y_bottom, x_left, y_bottom_center, 0);
        CGContextAddLineToPoint(context, x_left, y_top_center);
    }
	
	// End
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
