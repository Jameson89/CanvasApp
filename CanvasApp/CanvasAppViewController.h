//
//  CanvasAppViewController.h
//  CanvasApp
//
//  Created by Klint Holmes on 3/14/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasAppViewController : UIViewController {
    IBOutlet UITableView *courseList;
    
    NSMutableData *data;
    NSMutableArray *courses;
}

@property (nonatomic, retain) UITableView *courseList;

- (IBAction)present:(id)sender;

@end
