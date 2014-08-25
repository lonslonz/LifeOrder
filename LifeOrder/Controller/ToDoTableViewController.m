//
//  ToDoTableViewController.m
//  LifeOrder
//
//  Created by 1000653 on 2014. 8. 21..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "AddToDoTableViewController.h"
#import "ToDo.h"
#import "Status.h"
#import "AppDelegate.h"

@interface ToDoTableViewController ()
@property (nonatomic, strong) NSArray *defaultArray;
@property (nonatomic, weak) NSManagedObjectContext *dbContext;
@end

#define TABLE_NAME @"ToDo"
#define STATUS_END @"End"

@implementation ToDoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultArray = @[@"first", @"seconde", @"third"];
    self.dbContext = [self getDbContextFromAppDelegate];
    [self setUpFetchResultController];
    
   // self.title = @"My Title";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setUpFetchResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TABLE_NAME];
    request.predicate = [NSPredicate predicateWithFormat:@"whichStatus != %@", STATUS_END];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updateDate"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.dbContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (NSManagedObjectContext *)getDbContextFromAppDelegate
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.dbContext;
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    
    ToDo *toDo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = toDo.toDo;
    cell.detailTextLabel.text = toDo.whichStatus.status;
    
    return cell;
    
    // Configure the cell...
    //cell.textLabel.text = self.defaultArray[indexPath.row];
}




#pragma mark - Navigation

- (IBAction)addToDo:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[AddToDoTableViewController class]]) {
        AddToDoTableViewController *addToDoVc = (AddToDoTableViewController *)segue.sourceViewController;
        NSLog(@"Pop results. typed : %@, selected : %@", addToDoVc.toDoTyped.text, addToDoVc.statusSelected);
        [self insertToDo:addToDoVc.toDoTyped.text status:addToDoVc.statusSelected];
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"AddToDoSegue"]) {
        
       // if([segue.destinationViewController isKindOfClass:[AddToDoTableViewController class]]) {
         if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            //AddToDoTableViewController *addToDoVc = (AddToDoTableViewController *)segue.destinationViewController;
            

        }
    }
}

#pragma mark - Database
- (ToDo *)insertToDo:(NSString *)toDoText status:(NSString *)status
{
    ToDo *toDoObj = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo"
                                              inManagedObjectContext:self.dbContext];
    toDoObj.toDo = toDoText;
    toDoObj.updateDate = [NSDate date];
    toDoObj.group = nil;
    toDoObj.order = 0;
    toDoObj.whichStatus = [self insertStatus:status];
    return toDoObj;
}

- (Status *)insertStatus:(NSString *)status
{
    Status *statusObj = [NSEntityDescription insertNewObjectForEntityForName:@"Status"
                                                      inManagedObjectContext:self.dbContext];
    statusObj.status = status;
    statusObj.group = nil;
    statusObj.order = 0;
    statusObj.updateDate = [NSDate date];
    return statusObj;
}
@end
