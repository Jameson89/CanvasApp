//
//  MyRequest.m
//  Untitled
//
//  Created by Klint Holmes on 2/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "MyRequest.h"
#import <QuartzCore/QuartzCore.h>
#define kAccessToken @"accesstoken"
//TOKENS
// Canvas Teacher
//#define kAccessToken @"fEOYiDUFOf8HxqSsVytrNCKHVVkZ9PxP3EVQxkWp4AETpgkpDc7xPyALxrcvAy9A"

// WSU API
//#define kAccessToken @"YvorTmtYXBr1VH9HgjVdVUrVIYqj3UfxCAv0qyhu76k4yb0Qcj5e6kj9nj8Ud5w7"

@implementation MyRequest
@synthesize delegate, buffer, loadingView;

- (id)init {
	if (self == [super init]) {
		buffer = [[NSMutableData alloc] init];
	}
	return self;
}

- (void)startRequest:(NSURL *)url {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"%@", [defaults objectForKey:kAccessToken]);
    //@"YvorTmtYXBr1VH9HgjVdVUrVIYqj3UfxCAv0qyhu76k4yb0Qcj5e6kj9nj8Ud5w7";
	NSString *accessToken = [defaults objectForKey:kAccessToken];
    NSLog(@"%@", accessToken);
    NSString *appendToken = [NSString stringWithFormat:@"%@?access_token=%@", [url description], accessToken];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appendToken]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                timeoutInterval:30.0];
    //[request setHTTPMethod:@"GET"];
    //NSString *authString = [[self Base64Encode:[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding]] copy];
    
    //authString = [NSString stringWithFormat: @"Basic %@", authString];
    //NSLog(@"%@", authString);
    //[request setValue:authString forHTTPHeaderField:@"Authorization"];
    
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[connection start];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    

    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ai.frame = CGRectMake(32, 10, 37, 37);
    [ai startAnimating];
    
    
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 100, 18)];
    ll.backgroundColor = [UIColor clearColor];
    ll.textColor = [UIColor whiteColor];
    ll.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    ll.textAlignment = UITextAlignmentCenter;
    ll.text = @"Loading...";


    
    loadingView = [[UIView alloc]  initWithFrame:CGRectMake(110, 90, 100, 90)];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.layer.cornerRadius = 10;
    loadingView.alpha = .8;
    
    [loadingView addSubview:ll];
    [loadingView addSubview:ai];
    [[[self delegate] view] addSubview:loadingView];
    
    [ll release];
    [ai release];	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//[buffer release];
	[self connectionSuccessful:YES];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:" message:@"Unable to estabish a connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self connectionSuccessful:NO];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionSuccessful:(BOOL)success {
    [loadingView removeFromSuperview];
    [loadingView release];
	if([[self delegate] respondsToSelector:@selector(connectionSuccessful:request:)]) {
		[[self delegate] connectionSuccessful:success request:self];
	}
}


-(NSString *)Base64Encode:(NSData *)data {
    //Point to start of the data and set buffer sizes
    int inLength = [data length];
    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp;
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
        
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;                  
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;                          
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer); 
    return pictemp;
}

@end
