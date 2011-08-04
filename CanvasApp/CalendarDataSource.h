//
//  CalendarDataSource.h
//  ChiMobile
//
//  Created by Klint Holmes on 11/23/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import "Kal.h"

@class CanvasAppAppDelegate, CTTimeObject;

@interface CalendarDataSource : NSObject <KalDataSource> {
	NSMutableArray *items;
    NSMutableArray *days;
	NSMutableData *buffer;
	CanvasAppAppDelegate *appDelegate;
	id<KalDataSourceCallbacks> callback;
	BOOL dataReady;
}

+ (CalendarDataSource *)dataSource;
- (CTTimeObject *)holidayAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)parseGMTDate:(NSString *)dateString;


@end
