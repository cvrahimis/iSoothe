//
//  OpenEntriesViewController.h
//  iCope
//
//  Created by Costas Simiharv on 1/18/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Journal.h"
#import "OpenEntriesViewControllerDelegate.h"



@interface OpenEntriesViewController : UITableViewController{
    NSArray *dates;
    NSArray *results;
    NSArray *numRowSection;
    //AppDelegate *appDelegate;
    NSManagedObjectContext *managedObjectContext;
    NSMutableDictionary *dateGroups;
    NSString *entry;
    NSString *title;

}
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSString *entry;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableDictionary *dateGroups;
@property (strong, nonatomic) id<OpenEntriesViewControllerDelegate> delegate;


@end
