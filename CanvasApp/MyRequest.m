//
//  MyRequest.m
//  Untitled
//
//  Created by Klint Holmes on 2/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import "MyRequest.h"

@implementation MyRequest
@synthesize delegate;

- (id)init {
	if (self == [super init]) {
		buffer = [[NSMutableData alloc] init];
	}
	return self;
}

- (id)initWithBuffer:(NSMutableData *)data {
	if (self == [super init]) {
		buffer = data;//[data retain];
	}
	return self;
}

- (void)startRequest:(NSURL *)url {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults objectForKey:@"username"];
	NSString *password = [defaults objectForKey:@"password"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authString = [self Base64Encode:[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    authString = [NSString stringWithFormat: @"Basic %@", authString];
    [request setValue:authString forHTTPHeaderField:@"Authorization"];
    
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[connection start];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;	
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
	if([[self delegate] respondsToSelector:@selector(connectionSuccessful:)]) {
		[[self delegate] connectionSuccessful:success];
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
    
    /* http://en.wikipedia.org/wiki/Base64
     Text content   M           a           n
     ASCII          77          97          110
     8 Bit pattern  01001101    01100001    01101110
     
     6 Bit pattern  010011  010110  000101  101110
     Index          19      22      5       46
     Base64-encoded T       W       F       u
     */
    
    
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
