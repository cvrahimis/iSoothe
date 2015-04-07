//
//  Therapist.h
//  iSoothe
//
//  Created by Costas Simiharv on 4/7/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ButtonActivations;

@interface Therapist : NSManagedObject

@property (nonatomic, retain) NSString * therapistFirstName;
@property (nonatomic, retain) NSNumber * therapistId;
@property (nonatomic, retain) NSString * therapistLastName;
@property (nonatomic, retain) NSManagedObject *activity;
@property (nonatomic, retain) ButtonActivations *buttonActivations;
@property (nonatomic, retain) NSManagedObject *patient;

@end
