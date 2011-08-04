//
//  EventViewCell.h
//  Kal
//
//  Created by Klint Holmes on 5/12/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventViewCell : UITableViewCell {
	IBOutlet UILabel *time;
	IBOutlet UILabel *allDay;
	IBOutlet UILabel *AMPM;
	IBOutlet UILabel *eventName;
}

@property (nonatomic, retain) UILabel *time;
@property (nonatomic, retain) UILabel *allDay;
@property (nonatomic, retain) UILabel *AMPM;
@property (nonatomic, retain) UILabel *eventName;
//@property (nonatomic, retain) UIImageView *marker;

@end
