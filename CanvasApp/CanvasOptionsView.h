//
//  CanvasOptionsView.h
//  CanvasApp
//
//  Created by Klint Holmes on 6/16/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasAppAppDelegate.h"

@interface CanvasOptionsView : UIViewController {
    CanvasAppAppDelegate *delegate;
    IBOutlet UITableView *listView;
    NSMutableArray *list;
    NSString *course;
}

@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSString *course;

@end
