//
//  CanvasAppAppDelegate.h
//  CanvasApp
//
//  Created by Klint Holmes on 5/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class CanvasAppViewController;

@interface CanvasAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;//CanvasAppViewController *viewController;

@end
