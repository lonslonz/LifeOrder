//
//  AppDelegate.m
//  LifeOrder
//
//  Created by 1000653 on 2014. 8. 20..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import "AppDelegate.h"
#import "DbCreator.h"

@interface AppDelegate()



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.dbContext = [DbCreator createMainQueueManagedObjectContext];
    
    return YES;
}
// we do some stuff when our Photo database's context becomes available
// we kick off our foreground NSTimer so that we are fetching every once in a while in the foreground
// we post a notification to let others know the context is available


- (void)setDbContext:(NSManagedObjectContext *)dbContext
{
    _dbContext = dbContext;

    // let everyone who might be interested know this context is available
    // this happens very early in the running of our application
    // it would make NO SENSE to listen to this radio station in a View Controller that was segued to, for example
    // (but that's okay because a segued-to View Controller would presumably be "prepared" by being given a context to work in)
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [DbCreator saveContext:self.dbContext];
}

@end
