//
//  Journal.h
//  iSoothe
//
//  Created by Costas Simiharv on 4/7/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Journal : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * entry;
@property (nonatomic, retain) NSString * title;

@end
