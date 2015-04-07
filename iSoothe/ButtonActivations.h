//
//  ButtonActivations.h
//  iSoothe
//
//  Created by Costas Simiharv on 4/7/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ButtonActivations : NSManagedObject

@property (nonatomic, retain) NSNumber * buttonId;
@property (nonatomic, retain) NSNumber * patientId;
@property (nonatomic, retain) NSNumber * therapistId;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSManagedObject *patient;
@property (nonatomic, retain) NSManagedObject *therapist;

@end
