//
//  DbCreator.h
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 23..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbCreator : NSObject
+ (NSManagedObjectContext *)createMainQueueManagedObjectContext;
@end
