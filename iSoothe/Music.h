//
//  Music.h
//  iSoothe
//
//  Created by Costas Simiharv on 4/8/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Music : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * title;

@end
