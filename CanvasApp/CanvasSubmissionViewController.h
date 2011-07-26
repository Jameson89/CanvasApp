//
//  CanvasSubmissionViewController.h
//  CanvasApp
//
//  Created by Klint Holmes on 7/11/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CanvasSubmissionViewController : UIViewController {
    IBOutlet UIView *locked;
    IBOutlet UIImageView *lock;
    IBOutlet UILabel *unauth;
    
    IBOutlet UITableView *listView;
    NSMutableArray *list;
}

@property (nonatomic, retain) UIView *locked;
@property (nonatomic, retain) UIImageView *lock;
@property (nonatomic, retain) UILabel *unauth;
@property (nonatomic, retain) UITableView *listView;

- (NSDate *)parseGMTDate:(NSString *)dateString;

@end
