//
//  CanvasCourseViewController.h
//  CanvasApp
//
//  Created by Klint Holmes on 6/3/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CanvasCourseViewController : UIViewController {
    IBOutlet UITableView *courseList;
    NSMutableArray *assignments;
    NSString *listTitle;
    NSString *course;
}

@property (nonatomic, retain) UITableView *courseList;
@property (nonatomic, retain) NSString *listTitle;
@property (nonatomic, retain) NSString *course;

@end
