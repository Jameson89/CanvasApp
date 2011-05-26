//
//  CustomCellBackground.h
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellBackground : UIView {
    BOOL _firstCell;
    BOOL _lastCell;
    BOOL _selected;
}

@property  BOOL firstCell;
@property  BOOL lastCell;
@property  BOOL selected;

- (void)CGContextAddRoundedRect:(CGRect)rect cornerRadius:(int)corner_radius outside:(BOOL)yesOrNo;

@end
