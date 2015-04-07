//
//  JournalViewController.h
//  BlueApp
//
//  Created by Costas Simiharv on 1/13/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"
#import "AppDelegate.h"
#import "OpenEntriesViewController.h"
#import "OpenEntriesViewControllerDelegate.h"
#import "RatingViewController.h"

@interface JournalViewController : UIViewController <OpenEntriesViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    NSString *title;
    NSString *entry;
    long currentTime;
    NSDate *startTime;
    NSDate *endTime;
    UIScrollView *scrollView;
    
}

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UITextField *titleTF;
@property (strong, nonatomic) UITextView *entryTV;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) UIScrollView *scrollView;


- (void)savePress:(id)sender;
//- (void)closeOpenEntries:(id)sender;
@end
