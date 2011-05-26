//
//  CTLoginViewController.m
//  ChiTester
//
//  Created by Klint Holmes on 5/16/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#define kUsername @"username"
#define kPassword @"password"

#import "CTLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCellBackground.h"
#import "MyRequest.h"
#import "JSON.h"

@implementation CTLoginViewController
@synthesize loadingView;

#pragma mark -
#pragma mark UITableView Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 2;
//}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
	tableView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:.682 green:.733 blue:.71 alpha:1];
		return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	
	static NSString *RegID = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:RegID] autorelease];
		if (row == 0) {
			username = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, 290, 25)];
			[cell addSubview:username];
		} else {
			password = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 290, 25)];
			[cell addSubview:password];
		}

	}
    cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
    ((CustomCellBackground *)cell.backgroundView).firstCell = indexPath.row == 0;
    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == 1;
	if (row == 0) {
		
		username.backgroundColor = [UIColor clearColor];
		username.placeholder = @"Username";
		username.returnKeyType = UIReturnKeyGo;
		username.delegate = self;
		username.clearButtonMode = UITextFieldViewModeWhileEditing;
		username.autocorrectionType = UITextAutocorrectionTypeNo;
		username.autocapitalizationType = UITextAutocapitalizationTypeNone;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if (![[defaults objectForKey:kUsername] isEqualToString:@""] || [defaults objectForKey:kUsername] != nil) {
			username.text = [defaults objectForKey:kUsername];
		}
		
	} else {

		password.secureTextEntry = YES;
		password.backgroundColor = [UIColor clearColor];
		password.placeholder = @"Password";
		password.returnKeyType = UIReturnKeyGo;
		password.delegate = self;
		password.clearButtonMode = UITextFieldViewModeWhileEditing;
		password.autocorrectionType = UITextAutocorrectionTypeNo;
		[username becomeFirstResponder];
		
	}

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	if (row == 0) {
		[username becomeFirstResponder];
	} else {
		[password becomeFirstResponder];
	}
}

#pragma mark -
#pragma mark  UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField { 
	
	if (username.text && password.text && ![username.text isEqualToString:@""]  && ![password.text isEqualToString:@""]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:username.text forKey:kUsername];
        [defaults setObject:password.text forKey:kPassword];
        [self showLoading];
		MyRequest *request = [[MyRequest alloc] init];
        [request setDelegate:self];
        [request startRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/courses.json", canvas_host]]]; 
        [request release];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error:" 
                                                        message:@"Username / Password required." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
	return YES; 
}

- (void)connectionSuccessful:(BOOL)success request:(id)request {
    MyRequest *response = (MyRequest *)request;
	NSString *jsonString = [[NSString alloc] initWithData:response.buffer encoding:NSUTF8StringEncoding];
	//[data release];
	NSDictionary *results = [jsonString JSONValue];
    if ([results isKindOfClass:[NSDictionary class]]) {
        if ([results objectForKey:@"errors"]) {
            loadingView.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error:" 
                                                            message:@"User authorization required." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    } else {
        loadingView.hidden = YES;
        [self dismissModalViewControllerAnimated:YES];
        NSArray *array = [jsonString JSONValue];
        NSLog(@"%@", [[array objectAtIndex:0] objectForKey:@"name"]);
    }
}


#pragma mark -
- (void)showLoading {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	loadingView.hidden = NO;
	//[pool release];
}

#pragma mark -
- (void)viewDidLoad {
	//appDelegate = (ChiMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
	loadingView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[loadingView release];
    [super dealloc];
}


@end
