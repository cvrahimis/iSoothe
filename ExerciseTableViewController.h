//
//  ExerciseTableViewController.h
//  iCope
//
//  Created by Costas Simiharv on 1/25/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseTableViewCell.h"
#import "AppDelegate.h"
#import "ExerciseViewController.h"

@interface ExerciseTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray *fetchedObjects;
    NSDate *startTime;
    NSDate *endTime;
}

@property (strong, nonatomic) NSArray *fetchedObjects;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

@end
