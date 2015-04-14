//
//  BackEndComunicator.h
//  iCope
//
//  Created by Costas Simiharv on 3/4/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Therapist.h"
#import "Patient.h"
#import "Activities.h"

@interface BackEndComunicator : NSObject<NSURLConnectionDelegate>
{
    NSMutableData * _responseData;
    NSManagedObjectContext * _managedObjectContext;
    NSString *result;
    Reachability *internetReachableFoo;
    NSString *loginCred;
}

@property (strong, nonatomic) NSMutableData *_responseData;
@property (strong, nonatomic) NSManagedObjectContext * _managedObjectContext;
@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSString *loginCred;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (BOOL) loginWithUserName:(NSString*) username andPassword:(NSString*) password;

-(BOOL) isPatientAndTherapistOnDevice;

-(Patient*) getPatientOnDevice;

-(Therapist*) getTherapistOnDevice;

-(void) sendActivities;

-(NSString*)getLoginString;

@end
