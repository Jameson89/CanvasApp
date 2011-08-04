//
//  CTTimeObject.h
//  ChiMobile
//
//  Created by Klint Holmes on 11/29/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTTimeObject : NSObject {
	NSDate *date;
    NSString *title;
	//BOOL errorMsg;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *title;
//@property (readwrite) BOOL errorMsg;

@end
