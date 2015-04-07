//
//  Patient.h
//  iSoothe
//
//  Created by Costas Simiharv on 4/7/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ButtonActivations, Therapist;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * patientFirstName;
@property (nonatomic, retain) NSNumber * patientId;
@property (nonatomic, retain) NSString * patientLastName;
@property (nonatomic, retain) NSString * patientLogin;
@property (nonatomic, retain) NSString * patientPassword;
@property (nonatomic, retain) NSNumber * therapistId;
@property (nonatomic, retain) NSManagedObject *activity;
@property (nonatomic, retain) ButtonActivations *buttonActivations;
@property (nonatomic, retain) Therapist *therapist;

@end
