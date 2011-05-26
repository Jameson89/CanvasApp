//
//  CanvasAppViewController.m
//  CanvasApp
//
//  Created by Klint Holmes on 3/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CanvasAppViewController.h"
#import "CustomCellBackground.h"
#import "MyRequest.h"
#import "JSON.h"


@implementation CanvasAppViewController
@synthesize courseList;

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

- (void)viewDidLoad {
    courses = [[NSMutableArray alloc] init];
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"username"] && ![defaults objectForKey:@"password"]) {
        CTLoginViewController *login = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        [self presentModalViewController:login animated:YES];
        [login release];
    } else {
        data = [[NSMutableData alloc] init];
        MyRequest *request = [[MyRequest alloc] init];
        [request setDelegate:self];
        //[request startRequest:[NSURL URLWithString:@"https://learn-wsu.uen.org/api/v1/courses.json"]];
        [request startRequest:[NSURL URLWithString:@"https://canvas.instructure.com/api/v1/courses.json"]];
        [request release];
    }
}


// HTTPRequest Delegate
- (void)connectionSuccessful:(BOOL)success request:(id)request{
    MyRequest *responce = (MyRequest *)request;
	NSString *jsonString = [[NSString alloc] initWithData:responce.buffer encoding:NSUTF8StringEncoding];
	//[data release];
	NSDictionary *results = [jsonString JSONValue];
    if ([results isKindOfClass:[NSDictionary class]]) {
        if ([results objectForKey:@"errors"]) {
            CTLoginViewController *login = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
            [self presentModalViewController:login animated:YES];
            [login release];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error:" 
                                                            message:@"User authorization required." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    } else {
        courses = [[jsonString JSONValue] copy];
        NSLog(@"%@", courses);
        [courseList reloadData];
    }
}



#pragma mark -
#pragma mark UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%d", [courses count]);
    return [courses count];
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
	
	// *cell = ( *)[tableView dequeueReusableCellWithIdentifier:TableID];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
	if (cell == nil) {
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil];
		//cell = [nib objectAtIndex:0];
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableID];
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:TableID] autorelease];
	}
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
    ((CustomCellBackground *)cell.backgroundView).firstCell = indexPath.row == 0;
    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == 0;
	
	cell.textLabel.text = [[courses objectAtIndex:section] objectForKey:@"course_code"];
    NSString *enrollment = [[NSString alloc] init];
    for (int i = 0; i < [[[courses objectAtIndex:section] objectForKey:@"enrollments"] count]; i++) {
        if (i == 0) {
            enrollment = [NSString stringWithFormat:@"%@", [[[[courses objectAtIndex:section] objectForKey:@"enrollments"] objectAtIndex:i] objectForKey:@"type"]]; 
        } else {
            enrollment = [NSString stringWithFormat:@"%@, %@", enrollment, [[[[courses objectAtIndex:section] objectForKey:@"enrollments"] objectAtIndex:i] objectForKey:@"type"]]; 
        }
    }
    cell.detailTextLabel.text = enrollment;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}


-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger courseId = [[[courses objectAtIndex:[indexPath section]] objectForKey:@"id"] integerValue];
    // Will be used to make request for assignments page
    NSLog(@"https://canvas.instructure.com/api/v1/courses/%d/assignments.json", courseId);
}

/*
 -(NSString *)tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section {
 return @"";	
 }*/


-(CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


- (IBAction)present:(id)sender {
    CTLoginViewController *loginView = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
    [self presentModalViewController:loginView animated:YES];
    [loginView release];
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

@end
