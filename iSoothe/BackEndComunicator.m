//
//  BackEndComunicator.m
//  iCope
//
//  Created by Costas Simiharv on 3/4/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "BackEndComunicator.h"


@implementation BackEndComunicator

@synthesize _managedObjectContext;
@synthesize _responseData;
@synthesize result;
@synthesize loginCred;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if(self = [super init])
    {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

// Checks if we have an internet connection or not
- (BOOL)testInternetConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
    

}

-(Patient*) getPatientOnDevice
{
    if([self isPatientAndTherapistOnDevice]){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext: _managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        Patient *patient = [[_managedObjectContext executeFetchRequest:fetchRequest error: &error] objectAtIndex:0];
        return patient;
    }
    return nil;
}

-(Therapist*) getTherapistOnDevice
{
    if([self isPatientAndTherapistOnDevice]){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Therapist" inManagedObjectContext: _managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        Therapist *therapist = [[_managedObjectContext executeFetchRequest:fetchRequest error: &error] objectAtIndex:0];
        return therapist;
    }
    return nil;
}

-(NSString*)getLoginString{//Debug
    return loginCred;
}

-(void)checkTherapistID{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext: _managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *patients = [_managedObjectContext executeFetchRequest:fetchRequest error: &error];
    if(patients != nil)
    {
        Patient *patient = [patients objectAtIndex:0];
    
        NSString *post = [NSString stringWithFormat:@"Username=%@&Password=%@",patient.patientLogin,patient.patientPassword];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/iSoothe/iSootheMobile/Login.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:10];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        __block NSEntityDescription *entity = nil;
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                   NSArray *phpData = [result componentsSeparatedByString: @","];
                                   if([phpData count] == 8)
                                   {
                                       
                                       entity = [NSEntityDescription entityForName:@"Therapist" inManagedObjectContext: _managedObjectContext];
                                       [fetchRequest setEntity:entity];
                                       error = nil;
                                       NSArray *therapists = [_managedObjectContext executeFetchRequest:fetchRequest error: &error];
                                       if (therapists != nil) {
                                           Therapist *therapist = [therapists objectAtIndex:0];
                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                           f.numberStyle = NSNumberFormatterNoStyle;
                                           if (therapist.therapistId != [f numberFromString:[phpData objectAtIndex:1]]) {
                                               therapist.therapistId = [f numberFromString:[phpData objectAtIndex:1]];
                                               therapist.therapistFirstName = [phpData objectAtIndex:6];
                                               therapist.therapistLastName = [phpData objectAtIndex:7];
                                               patient.therapistId = [f numberFromString:[phpData objectAtIndex:1]];
                                               error = nil;
                                               [_managedObjectContext save:&error];
                                           }
                                       }
                                   }
                               }
         ];
    }
}

- (BOOL) loginWithUserName:(NSString*) username andPassword:(NSString*) password{
    NSString *post = [NSString stringWithFormat:@"Username=%@&Password=%@",username,password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postData = [[NSString alloc] initWithData:post encoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //Request to run on simulator
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/iSoothe/iSootheMobile/Login.php"]]];
    //Request to run on device
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.13:8888/iCopeDBInserts/Login.php"]]];
    //new request
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.10:8888/iSoothe/iSootheMobile/Login.php"]]];
    //Request to run on iona server
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://isoothe.cs.iona.edu/login.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:5];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *serverData = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:nil];
    [_responseData appendData:serverData];
    result = [[NSString alloc] initWithData:serverData encoding:NSASCIIStringEncoding];
    //result = [[NSString alloc] initWithData:serverData encoding:NSUTF8StringEncoding];
    loginCred = result;
    NSArray *phpData = [result componentsSeparatedByString: @","];
    
    return [self insertPatientandTherapistToDevice:phpData withUsername:username andPassword:password];
}

-(BOOL) insertPatientandTherapistToDevice:(NSArray*) loginArray withUsername: (NSString*) uname andPassword: (NSString*) pass{
    // Append the new data to the instance variable you declared
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([loginArray count] == 8)
    {
        if(loginArray && [uname isEqualToString:[loginArray objectAtIndex:2]] && [pass isEqualToString:[loginArray objectAtIndex:3]])
        {
            Therapist *therapist = [NSEntityDescription insertNewObjectForEntityForName:@"Therapist" inManagedObjectContext:_managedObjectContext];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterNoStyle;
            therapist.therapistId = [f numberFromString:[loginArray objectAtIndex:1]];
            therapist.therapistFirstName = [loginArray objectAtIndex:6];
            therapist.therapistLastName = [loginArray objectAtIndex:7];
        
            Patient *patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:_managedObjectContext];
            patient.patientId = [f numberFromString:[loginArray objectAtIndex:0]];
            patient.therapistId = [f numberFromString:[loginArray objectAtIndex:1]];
            patient.patientLogin = [loginArray objectAtIndex:2];
            patient.patientPassword = [loginArray objectAtIndex:3];
            patient.patientFirstName = [loginArray objectAtIndex:4];
            patient.patientLastName = [loginArray objectAtIndex:5];
            patient.therapist = therapist;
            therapist.patient = patient;
            //[therapist addPatientObject: patient];
        
            NSError *error;
            if (![_managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

-(BOOL) isPatientAndTherapistOnDevice{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext: _managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *patient = [_managedObjectContext executeFetchRequest:fetchRequest error: &error];
    
    if ([patient count] > 0)
        return YES;
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    /*// Append the new data to the instance variable you declared
     NSLog(@"%s", __PRETTY_FUNCTION__);
     
     [_responseData appendData:data];
     result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
     NSArray *phpData = [result componentsSeparatedByString: @","];
     
     Therapist *therapist = [NSEntityDescription
     insertNewObjectForEntityForName:@"Therapist"
     inManagedObjectContext:_managedObjectContext];
     NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
     f.numberStyle = NSNumberFormatterNoStyle;
     therapist.therapistId = [f numberFromString:[phpData objectAtIndex:1]];
     therapist.therapistFirstName = [phpData objectAtIndex:6];
     therapist.therapistLastName = [phpData objectAtIndex:7];
     
     Patient *patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:_managedObjectContext];
     patient.patientId = [f numberFromString:[phpData objectAtIndex:0]];
     patient.therapistId = [f numberFromString:[phpData objectAtIndex:1]];
     patient.patientLogin = [phpData objectAtIndex:2];
     patient.patientPassword = [phpData objectAtIndex:3];
     patient.patientFirstName = [phpData objectAtIndex:4];
     patient.patientLastName = [phpData objectAtIndex:5];
     patient.therapist = therapist;
     [therapist addPatientObject: patient];
     
     NSError *error;
     if (![_managedObjectContext save:&error]) {
     NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
     }*/
}

-(void) sendActivities{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activities" inManagedObjectContext: _managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *acts = [_managedObjectContext executeFetchRequest:fetchRequest error: &error];
    
    if ([acts count] > 0)
    {
        NSString *xml = [self genXMLWithActivities:acts];
        NSString *post = [NSString stringWithFormat:@"activityXML=%@",xml];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //Request for simulator
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/iSoothe/iSootheMobile/AddActivity.php"]]];
        //Request for device
        //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.8:8888/iSoothe/iSootheMobile/AddActivity.php"]]];
        //Request for Iona server
        //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://isoothe.cs.iona.edu/AddActivity.php"]]];
        
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:5];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSData *serverData = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:nil];
        //[_responseData appendData:serverData];
        result = [[NSString alloc] initWithData:serverData encoding:NSASCIIStringEncoding];
        if ([result isEqualToString:@"yes"])
        {
            NSFetchRequest * activityFetch = [[NSFetchRequest alloc] init];
            entity = [NSEntityDescription entityForName:@"Activities" inManagedObjectContext: _managedObjectContext];
            [activityFetch setEntity:entity];
            //[activityFetch setIncludesPropertyValues:NO]; //only fetch the managedObjectID
            
            NSError *error = nil;
            NSArray *activities = [_managedObjectContext executeFetchRequest:activityFetch error:&error];
            
            //error handling goes here
            for (NSManagedObject *activity in activities) {
                [_managedObjectContext deleteObject:activity];
            }
            NSError *saveError = nil;
            [_managedObjectContext save:&saveError];
        }
        
    }
    
}

-(NSString*) genXMLWithActivities:(NSArray *) acts{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Activities *activity;
    NSMutableString *xml = [NSMutableString stringWithString:@"<?xml version='1.0' encoding='UTF-8'?><activities>"];
    for(int i = 0; i < [acts count]; i++)
    {
        activity = [acts objectAtIndex:i];
        
        [xml appendString:@"<activity>"];
        [xml appendString:@"<therapistId>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"therapistId"]]];
        [xml appendString:@"</therapistId>"];
        [xml appendString:@"<patientId>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"patientId"]]];
        [xml appendString:@"</patientId>"];
        [xml appendString:@"<time>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"time"]]];
        [xml appendString:@"</time>"];
        [xml appendString:@"<act>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"activity"]]];
        [xml appendString:@"</act>"];
        [xml appendString:@"<duration>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"duration"]]];
        [xml appendString:@"</duration>"];
        [xml appendString:@"<mood>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"mood"]]];
        [xml appendString:@"</mood>"];
        [xml appendString:@"<urge>"];
        [xml appendString:[NSString stringWithFormat: @"%@",[activity valueForKey: @"urge"]]];
        [xml appendString:@"</urge>"];
        [xml appendString:@"</activity>"];
    }
    [xml appendString:@"</activities>"];
    
    return xml;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%s", __PRETTY_FUNCTION__);
}




@end
