//
//  Status.h
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 24..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSDate * updateDate;

@end
