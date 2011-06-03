//
//  KHBadge.h
//  Draw Practice
//
//  Created by Klint Holmes on 6/17/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KHBadge : UIView {
	UILabel *badge;
}

- (id)initWithBadgeNumber:(NSString *)badgeNumber;
- (void)CGContextAddRoundedRect:(CGRect)rect cornerRadius:(int)corner_radius outside:(BOOL)yesOrNo;

@end
