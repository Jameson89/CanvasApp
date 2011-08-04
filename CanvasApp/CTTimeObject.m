//
//  CTTimeObject.m
//  ChiMobile
//
//  Created by Klint Holmes on 11/29/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import "CTTimeObject.h"


@implementation CTTimeObject
@synthesize date, title;//, errorMsg;

- (id)init {
	[super init];
	date = [[NSDate alloc] init];
	title = [[NSString alloc] init];
	//errorMsg = [[NSString alloc] init];
	return self;
}

- (void)dealloc {
	[super dealloc];
	[date release];
	[title release];
	//[errorMsg release];
}

@end
