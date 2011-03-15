//
//  CanvasAppAppDelegate.h
//  CanvasApp
//
//  Created by Klint Holmes on 3/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CanvasAppViewController;

@interface CanvasAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CanvasAppViewController *viewController;

@end
