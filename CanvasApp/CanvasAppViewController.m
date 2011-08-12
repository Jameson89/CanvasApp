//
//  CanvasAppViewController.m
//  CanvasApp
//
//  Created by Klint Holmes on 5/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CanvasAppViewController.h"
#import "CanvasAppAppDelegate.h"
#import "CanvasCourseViewController.h"
#import "CustomCellBackground.h"
#import "LPViewController.h"
#import "MyRequest.h"
#import "JSON.h"


@implementation CanvasAppViewController
@synthesize courseList;

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    self.title = @"Canvas";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:.251 green:.384 blue:.455 alpha:1];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(present:)] autorelease];
    courses = [[NSMutableArray alloc] init];
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"accesstoken"]/*![defaults objectForKey:@"username"]*//* && ![defaults objectForKey:@"password"]*/) {
        CTLoginViewController *login = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        [self presentModalViewController:login animated:YES];
        [login release];
    } else {
        MyRequest *request = [[MyRequest alloc] init];
        [request setDelegate:self];
        [request startRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/courses.json", canvas_host]]]; 
        [request release];
    }
}


// HTTPRequest Delegate
- (void)connectionSuccessful:(BOOL)success request:(id)request{
    MyRequest *responce = (MyRequest *)request;
	NSString *jsonString = [[NSString alloc] initWithData:responce.buffer encoding:NSUTF8StringEncoding];
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
       NSLog(@"%@", [jsonString JSONValue]);
        [courseList reloadData];
    }
}



#pragma mark -
#pragma mark UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    NSString *course = [[courses objectAtIndex:[indexPath section]] objectForKey:@"id"]; 
    CanvasAppAppDelegate *delegate = (CanvasAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.courseID = course;
    CanvasCourseViewController *cc = [[CanvasCourseViewController alloc] initWithNibName:@"CanvasCourseViewController" bundle:nil];
    MyRequest *request = [[MyRequest alloc] init];
    [request setDelegate:cc];
    [request startRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/courses/%@/assignments.json", canvas_host, course]]]; 
    [request release];
    [cc setCourse:course];
    [cc setListTitle:[[courses objectAtIndex:[indexPath section]] objectForKey:@"course_code"]];
    [self.navigationController pushViewController:cc animated:YES];
    //LPViewController *lp = [[LPViewController alloc] initWithNibName:@"LPViewController" bundle:nil];
    //[self.navigationController pushViewController:lp animated:YES];
}

/*
 -(NSString *)tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section {
 return @"";	
 }*/


-(CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (IBAction)present:(id)sender {
    CTLoginViewController *loginView = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
    [self presentModalViewController:loginView animated:YES];
    [loginView release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
