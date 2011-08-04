//
//  CanvasAppAppDelegate.h
//  CanvasApp
//
//  Created by Klint Holmes on 5/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kal.h"
//@class CanvasAppViewController;
@class KalViewController;

@interface CanvasAppAppDelegate : NSObject <UIApplicationDelegate, UITableViewDelegate> {
    id source;
    KalViewController *calendar;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;//CanvasAppViewController *viewController;
@property (nonatomic, retain) id source;
@property (nonatomic, retain) KalViewController *calendar;

@end
