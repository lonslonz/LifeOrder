//
//  ToDo.h
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 24..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Status;

@interface ToDo : NSManagedObject

@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * toDo;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Status *whichStatus;

@end
