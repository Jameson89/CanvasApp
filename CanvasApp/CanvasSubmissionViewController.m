//
//  CanvasSubmissionViewController.m
//  CanvasApp
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CanvasSubmissionViewController.h"
#import "CustomCellBackground.h"
#import "MyRequest.h"
#import "JSON.h"


@implementation CanvasSubmissionViewController
@synthesize locked, lock, unauth, listView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Submissions";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    list = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)connectionSuccessful:(BOOL)success request:(id)request{
    MyRequest *responce = (MyRequest *)request;
	NSString *jsonString = [[NSString alloc] initWithData:responce.buffer encoding:NSUTF8StringEncoding];
	NSDictionary *results = [jsonString JSONValue];
    if ([results isKindOfClass:[NSDictionary class]]) {
        if ([results objectForKey:@"status"]) {
            locked.hidden = NO;
            lock.hidden = NO;
            unauth.hidden = NO;
        } else {
            list = [[jsonString JSONValue] copy];
            locked.hidden = YES;
            lock.hidden = YES;
            unauth.hidden = YES;
            //NSLog(@"%@", [jsonString JSONValue]);
            [listView reloadData];
        }
    } else {
        //[jsonString JSONValue]);
        list = [[jsonString JSONValue] copy];
        locked.hidden = YES;
        lock.hidden = YES;
        unauth.hidden = YES;
        NSLog(@"%@", list);
        [listView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [list count];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
	return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	static NSString *TableID = @"MyCell";
	
    // Will make custom table view cell for this item
	// *cell = ( *)[tableView dequeueReusableCellWithIdentifier:TableID];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
	if (cell == nil) {
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil];
		//cell = [nib objectAtIndex:0];
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableID];
	}
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
    ((CustomCellBackground *)cell.backgroundView).firstCell = indexPath.row == 0;
    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == 2;
	
    if (row == 0) {
        cell.textLabel.text = @"Score"; 
        if ([[[list objectAtIndex:section] objectForKey:@"score"] isKindOfClass:[NSNull class]]) {
            cell.detailTextLabel.text = @"Not Scored";
        } else {
            cell.detailTextLabel.text =[[[list objectAtIndex:section] objectForKey:@"score"] stringValue];
        }
        [[cell viewWithTag:100] removeFromSuperview];
    } else if (row == 1) {
        cell.textLabel.text = @"Submitted";
       // NSLog(@"%@", [[list objectAtIndex:section] objectForKey:@"submitted_at"]);
        if (![[[list objectAtIndex:section] objectForKey:@"submitted_at"] isKindOfClass:[NSNull class]]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
           // [df setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
            //NSString *formattedDate = [[[list objectAtIndex:section] objectForKey:@"submitted_at"] substringToIndex:[[[list objectAtIndex:section] objectForKey:@"submitted_at"] length] -3];
            //formattedDate = [NSString stringWithFormat:@"%@00", formattedDate];
            NSDate *date = [self parseGMTDate:[[list objectAtIndex:section] objectForKey:@"submitted_at"]];//[df dateFromString:formattedDate];
            [df setDateFormat:@"MMM d '@' h:mm a"];
            cell.detailTextLabel.text = [df stringFromDate:date];
        } else {
            cell.detailTextLabel.text = @"No Date Available";
        }
       
    } else {
        cell.textLabel.text = @"Attachments";
         NSArray *attachments  = [[list objectAtIndex:section] objectForKey:@"attachments"];
        for (int i = 0; i < [attachments count]; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130,  13 + (i * 20), 170, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentRight;
            label.tag = 100;
            label.text = [[attachments objectAtIndex:i] objectForKey:@"display_name"];
            [cell addSubview:label];
            [label release];
        }
        
        if ([attachments count] == 0) {
            cell.detailTextLabel.text = @"No Attachments";
        }
        
    }


    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 && [[[list objectAtIndex:indexPath.section] objectForKey:@"attachments"] count] > 0) {
        return 24 +([[[list objectAtIndex:indexPath.section] objectForKey:@"attachments"] count] * 20);
    }
    return 44;
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

@end
