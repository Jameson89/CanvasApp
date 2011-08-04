//
//  EventViewCell.m
//  Kal
//
//  Created by Klint Holmes on 5/12/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

#import "EventViewCell.h"


@implementation EventViewCell
@synthesize time;
@synthesize AMPM;
@synthesize eventName;
@synthesize allDay;
//@synthesize marker;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[time release];
	[allDay release];
	[AMPM release];
	[eventName release];
	//[marker release];
    [super dealloc];
}


@end
