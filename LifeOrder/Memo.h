//
//  Memo.h
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 24..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Memo : NSManagedObject

@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSNumber * order;

@end
