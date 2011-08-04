//
//  CanvasOptionsView.m
//  CanvasApp
//
//  Created by Klint Holmes on 6/16/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CanvasOptionsView.h"
#import "CustomCellBackground.h"
#import "CanvasSubmissionViewController.h"
#import "MyRequest.h"
#import "JSON.h"


@implementation CanvasOptionsView
@synthesize listView, list, course;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Assignments";
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Reminders" style:UIBarButtonItemStyleBordered target:self action:@selector(showReminders)] autorelease];
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
    //list = [[NSMutableArray alloc] init];
    //[listView reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark -
#pragma mark UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [list count];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	static NSString *TableID = @"MyCell";
	
    // Will make custom table view cell for this item
	// *cell = ( *)[tableView dequeueReusableCellWithIdentifier:TableID];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
	if (cell == nil) {
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil];
		//cell = [nib objectAtIndex:0];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableID];
	}
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
    ((CustomCellBackground *)cell.backgroundView).firstCell = indexPath.row == 0;
    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == 0;
	
    cell.textLabel.text = [[list objectAtIndex:section] objectForKey:@"name"];
    if (![[[list objectAtIndex:section] objectForKey:@"due_at"] isKindOfClass:[NSNull class]]) {

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    NSString *formattedDate = [[[list objectAtIndex:section] objectForKey:@"due_at"] substringToIndex:[[[list objectAtIndex:section] objectForKey:@"due_at"] length] -3];
    formattedDate = [NSString stringWithFormat:@"%@00", formattedDate];
    NSDate *date = [df dateFromString:formattedDate];
    [df setDateFormat:@"'Due:' EEEE, MMM d '@' h:mm a"];
    cell.detailTextLabel.text = [df stringFromDate:date];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSInteger courseId = [[[courses objectAtIndex:[indexPath section]] objectForKey:@"id"] integerValue];
    // Will be used to make request for assignments page
    //NSLog(@"%@/api/v1/courses/%d/assignments.json", canvas_host, courseId);
    //CanvasCourseViewController *cc = [[CanvasCourseViewController alloc] initWithNibName:@"CanvasCourseViewController" bundle:nil];
    //[self.navigationController pushViewController:cc animated:YES];
    CanvasSubmissionViewController *sub = [[CanvasSubmissionViewController alloc] initWithNibName:@"CanvasSubmissionViewController" bundle:nil];
    NSInteger section = [indexPath section];
    MyRequest *request = [[MyRequest alloc] init];
    [request setDelegate:sub];
    [request startRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/courses/%@/assignments/%@/submissions.json", canvas_host, course, [[list objectAtIndex:section] objectForKey:@"id"]]]];
    [self.navigationController pushViewController:sub animated:YES];
}

/*
 -(NSString *)tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section {
 return @"";	
 }*/


-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;//88;
}

- (void)connectionSuccessful:(BOOL)success request:(id)request{
    MyRequest *responce = (MyRequest *)request;
	NSString *jsonString = [[NSString alloc] initWithData:responce.buffer encoding:NSUTF8StringEncoding];
	NSDictionary *results = [jsonString JSONValue];
    if ([results isKindOfClass:[NSDictionary class]]) {
        if ([results objectForKey:@"errors"]) {
            NSLog(@"error");
            /* CTLoginViewController *login = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
             [self presentModalViewController:login animated:YES];
             [login release];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error:" 
             message:@"User authorization required." 
             delegate:self 
             cancelButtonTitle:@"OK" 
             otherButtonTitles:nil, nil];
             [alert show];
             [alert release];*/
        }
    } else {
        list = [[jsonString JSONValue] copy];
        NSLog(@"%@", list);
        [listView reloadData];
    }
    
}

- (void)showReminders {
    NSLog(@"Called");
}
- (void)scheduleNotification {
	
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil) {
		for (NSDictionary *event in list) {
            UILocalNotification *notif = [[cls alloc] init];
            //notif.fireDate = [datePicker date];
            notif.timeZone = [NSTimeZone defaultTimeZone];
		
            notif.alertBody = @"Did you forget something?";
            notif.alertAction = @"Show Me";
            notif.soundName = UILocalNotificationDefaultSoundName;
		
            NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"Text"
                                                             forKey:kRemindMeNotificationDataKey];
            notif.userInfo = userDict;
		
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            [notif release];
        }
    }
}


@end
