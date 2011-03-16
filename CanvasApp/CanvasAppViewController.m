//
//  CanvasAppViewController.m
//  CanvasApp
//
//  Created by Klint Holmes on 3/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CanvasAppViewController.h"
#import "MyRequest.h"
#import "JSON.h"


@implementation CanvasAppViewController

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

}
//*/
- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"username"] && ![defaults objectForKey:@"password"]) {
        CTLoginViewController *login = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        [self presentModalViewController:login animated:YES];
        [login release];
    } else {
        data = [[NSMutableData alloc] init];
        MyRequest *request = [[MyRequest alloc] initWithBuffer:data];
        [request setDelegate:self];
        [request startRequest:[NSURL URLWithString:@"https://canvas.instructure.com/api/v1/courses.json"]];
        [request release];
    }
}

- (void)viewDidLoad {

}

// HTTPRequest Delegate
- (void)connectionSuccessful:(BOOL)success {
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[data release];
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
    }
    
    NSLog(@"%@", results);
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
