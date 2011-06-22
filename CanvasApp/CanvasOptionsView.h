//
//  CanvasOptionsView.h
//  CanvasApp
//
//  Created by Klint Holmes on 6/16/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CanvasOptionsView : UIViewController {
    IBOutlet UITableView *listView;
    NSMutableArray *list;
}

@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, retain) NSMutableArray *list;

@end
