//
//  CTLoginViewController.h
//  ChiTester
//
//  Created by Klint Holmes on 5/16/10.
//  Copyright 2010 Klint Holmes. All rights reserved.
//

//#import <UIKit/UIKit.h>

@interface CTLoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITextField *username;
	UITextField *password;
	IBOutlet UIView *loadingView;
}

@property (nonatomic, retain) UIView *loadingView;

@end
