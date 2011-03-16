//
//  MyRequest.h
//  Untitled
//
//  Created by Klint Holmes on 2/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPConnectionDelegate <NSObject>
@optional
- (void)connectionSuccessful:(BOOL)success;
@end


@interface MyRequest : NSObject {
	id <HTTPConnectionDelegate> delegate;
	NSMutableData *buffer;	
}

@property (retain) id delegate;

- (id)initWithBuffer:(NSMutableData *)data;
- (void)startRequest:(NSURL *)url;
- (void)connectionSuccessful:(BOOL)success;
- (NSString *)Base64Encode:(NSData *)data;

@end
