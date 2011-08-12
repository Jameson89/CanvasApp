//
//  CalendarDataSource.m
//  ChiMobile
//
//  Created by Klint Holmes on 11/23/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import "JSON.h"
#import "CTTimeObject.h"
#import "CalendarDataSource.h"
#import "CanvasAppAppDelegate.h"
#import "EventViewCell.h"

#define kAccessToken @"accesstoken"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface CalendarDataSource ()
- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation CalendarDataSource

+ (CalendarDataSource *)dataSource {
	return [[[[self class] alloc] init] autorelease];
}

- (id)init {
	if ((self = [super init])) {
		appDelegate = (CanvasAppAppDelegate *)[[UIApplication sharedApplication] delegate];
		items = [[NSMutableArray alloc] init];
        days = [[NSMutableArray alloc] init];
		buffer = [[NSMutableData alloc] init];
	}
	return self;
}

- (CTTimeObject *)holidayAtIndexPath:(NSIndexPath *)indexPath {
	return [items objectAtIndex:indexPath.row];
}


#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"MyCell";
    
    EventViewCell *cell = (EventViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}

    CTTimeObject *holiday = [self holidayAtIndexPath:indexPath];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm"];
    cell.eventName.text = [NSString stringWithFormat:@"%@ Due", [holiday title]];
    cell.time.text = [df stringFromDate:[holiday date]];
    [df setDateFormat:@"a"];
    cell.AMPM.text = [df stringFromDate:[holiday date]];
    cell.userInteractionEnabled = YES;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

#pragma mark Fetch from the internet
//@"https://learn-wsu.uen.org/api/v1/courses/895/assignments.json?access_token=YvorTmtYXBr1VH9HgjVdVUrVIYqj3UfxCAv0qyhu76k4yb0Qcj5e6kj9nj8Ud5w7"
- (void)fetchHolidays {
    dataReady = NO;
	[days removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *accessToken = [defaults objectForKey:kAccessToken];
    //NSString *courseID = [appDelegate courseID];
    NSString *url = [NSString stringWithFormat:@"%@/api/v1/courses/%@/assignments.json?access_token=%@", canvas_host, [appDelegate courseID], accessToken];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    [conn start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
							 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[buffer setLength:0];
}
							 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *str = [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
	if (![str JSONValue])
		return;
	

    NSArray *results = [str JSONValue];
    for ( NSDictionary *event in results) {
        CTTimeObject *time = [[CTTimeObject alloc] init];
        if (![[event objectForKey:@"due_at"] isKindOfClass:[NSNull class]] ) {
            time.date = [self parseGMTDate:[event objectForKey:@"due_at"]];
            time.title = [event objectForKey:@"name"];
            [days addObject:time];
            
        }
        [time release];
        //time.date = [self parseGMTDate:[event objectForKey:@"due_at"]];

    }

	
	dataReady = YES;
	[callback loadedDataSource:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
		NSLog(@"HolidaysCalendarDataSource connection failure: %@", error);
}
							 

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate {
	//dataReady = NO;
	if (dataReady) {
		[callback loadedDataSource:self];
		return;
	}
	
	callback = delegate;
	[self fetchHolidays];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate {
	if (!dataReady)
		return [NSArray array];
	
	return [[self holidaysFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
	
	if (!dataReady)
		return;
	[items addObjectsFromArray:[self holidaysFrom:fromDate to:toDate]];
}

- (void)removeAllItems {
	[items removeAllObjects];
}

#pragma mark -

- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate {
	NSMutableArray *matches = [NSMutableArray array];
	for (CTTimeObject *obj in days)
         if (IsDateBetweenInclusive(obj.date, fromDate, toDate))
			[matches addObject:obj];
	
	return matches;
}

- (NSDate *)parseGMTDate:(NSString *)dateString {
    NSDateFormatter *rfc3339TimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
    [rfc3339TimestampFormatterWithTimeZone setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    [rfc3339TimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *theDate = nil;
    NSError *error = nil; 
    if (![rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
    }
    
    [rfc3339TimestampFormatterWithTimeZone release];
    return theDate;
}

- (void)dealloc {
	[items release];
	[days release];
	[buffer release];
	[super dealloc];
}



@end
