//
//  CanvasCourseViewController.m
//  CanvasApp
//
//  Created by Klint Holmes on 6/3/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CanvasCourseViewController.h"
#import "CustomCellBackground.h"
#import "CanvasOptionsView.h"
#import "MyRequest.h"
#import "JSON.h"


@implementation CanvasCourseViewController
@synthesize courseList, listTitle, course;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Course View";
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
    assignments = [[NSMutableArray alloc] init];
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
    if ([assignments count] > 0)
        return 1;
    else
        return 0;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
	return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	//NSInteger section = [indexPath section];
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
    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == 3;
    
    switch (row) {
        case 0:
            cell.textLabel.text = @"Assignments";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [assignments count]];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case 1:
            cell.textLabel.text = @"Discussions";
            cell.detailTextLabel.text = @"Not Available";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            cell.textLabel.text = @"Grades";
            cell.detailTextLabel.text = @"Not Available";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 3:
            cell.textLabel.text = @"Syllabus";
            cell.detailTextLabel.text = @"Not Available";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    
    /*
    NSString *enrollment = [[NSString alloc] init];
    for (int i = 0; i < [[[courses objectAtIndex:section] objectForKey:@"enrollments"] count]; i++) {
        if (i == 0) {
            enrollment = [NSString stringWithFormat:@"%@", [[[[courses objectAtIndex:section] objectForKey:@"enrollments"] objectAtIndex:i] objectForKey:@"type"]]; 
        } else {
            enrollment = [NSString stringWithFormat:@"%@, %@", enrollment, [[[[courses objectAtIndex:section] objectForKey:@"enrollments"] objectAtIndex:i] objectForKey:@"type"]]; 
        }
    }*/
    //cell.detailTextLabel.text = enrollment;
    
    
	return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSInteger courseId = [[[assignments objectAtIndex:[indexPath section]] objectForKey:@"id"] integerValue];
    // Will be used to make request for assignments page
    //NSLog(@"%@/api/v1/courses/%d/assignments.json", canvas_host, courseId);
    //CanvasCourseViewController *cc = [[CanvasCourseViewController alloc] initWithNibName:@"CanvasCourseViewController" bundle:nil];
    //[self.navigationController pushViewController:cc animated:YES];
    if (indexPath.row == 0) {
        CanvasOptionsView *cov = [[CanvasOptionsView alloc] initWithNibName:@"CanvasOptionsView" bundle:nil];
        [cov setList:assignments];
        [cov setCourse:course];
        [self.navigationController pushViewController:cov animated:YES];
    }
}


-(NSString *)tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section {
    return listTitle;	
}


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
        assignments = [[jsonString JSONValue] copy];
        NSLog(@"%@", assignments);
        [courseList reloadData];
    }
}



@end
