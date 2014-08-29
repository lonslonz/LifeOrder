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
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
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
    
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"%@",homeDir);
}

- (NSManagedObjectContext *)getDbContextFromAppDelegate
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.dbContext;
}
#pragma mart - Order
- (IBAction)edit:(id)sender {
    [self.tableView setEditing:YES animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/*
make the change to each of the object’s displayOrder attribute. Here is the code you use to re-order the results:
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    NSMutableArray *things = [[fetchedResultsController fetchedObjects] mutableCopy];
    
    // Grab the item we're moving.
    NSManagedObject *thing = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
    
    // Remove the object we're moving from the array.
    [things removeObject:thing];
    // Now re-insert it at the destination.
    [things insertObject:thing atIndex:[destinationIndexPath row]];
    
    // All of the objects are now in their correct order. Update each
    // object's displayOrder field by iterating through the array.
    int i = 0;
    for (NSManagedObject *mo in things)
    {
        [mo setValue:[NSNumber numberWithInt:i++] forKey:@"displayOrder"];
    }
    
    [things release], things = nil;
    
    [managedObjectContext save:nil];
}*/
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
 //   NSString *stringToMove = [self.reorderingRows objectAtIndex:sourceIndexPath.row];
//    [self.reorderingRows removeObjectAtIndex:sourceIndexPath.row];
//    [self.reorderingRows insertObject:stringToMove atIndex:destinationIndexPath.row];
    NSLog(@"stringToMove:%d, destinaionIndexPath.row:%d", sourceIndexPath.row, destinationIndexPath.row);
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
    cell.showsReorderControl = YES;
    return cell;
    
    // Configure the cell...
    //cell.textLabel.text = self.defaultArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"UpdateToDoSegue" sender:cell];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
   // self.selectedIndexPath = indexPath;
 //   [self performSegueWithIdentifier:@"UpdateToDoSegue" sender:self];
    NSLog(@"tapped acc button");
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [self performSegueWithIdentifier:@"UpdateToDoSegue" sender:self];
////    [[self navigationController] pushViewController:<#(UIViewController *)#> animated:YES];
//}


#pragma mark - Navigation

- (IBAction)addToDo:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[AddToDoTableViewController class]]) {
        AddToDoTableViewController *addToDoVc = (AddToDoTableViewController *)segue.sourceViewController;
        NSLog(@"Pop results. typed : %@, selected : %@", addToDoVc.toDoTextField.text, addToDoVc.statusStr);
        [self insertToDo:addToDoVc.toDoTextField.text status:addToDoVc.statusStr];
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue");
    if([segue.identifier isEqualToString:@"AddToDoSegue"]) {
        
       // if([segue.destinationViewController isKindOfClass:[AddToDoTableViewController class]]) {
         if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        }
    }
    else if([segue.identifier isEqualToString:@"UpdateToDoSegue"]) {
        if([segue.destinationViewController isKindOfClass:[AddToDoTableViewController class]]) {
            AddToDoTableViewController *addToDoVc = (AddToDoTableViewController *)segue.destinationViewController;
            //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            addToDoVc.toDoStr = cell.textLabel.text;
            addToDoVc.statusStr = cell.detailTextLabel.text;
        }
    }
}

#pragma mark - Database
- (ToDo *)insertToDo:(NSString *)toDoText status:(NSString *)status
{
    NSFetchRequest *selectRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toDo = %@",toDoText];
    selectRequest.predicate = predicate;
    NSError *error;
    NSArray *matches = [self.dbContext executeFetchRequest:selectRequest error:&error];
    
    ToDo *toDoObj = nil;
    if(!matches || error || ([matches count] > 1)) {
    } else if([matches count] == 1) {
        // update
        toDoObj = [matches firstObject];
        toDoObj.toDo = toDoText;
        
    } else {
     
        toDoObj = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo"
                                                  inManagedObjectContext:self.dbContext];
        toDoObj.toDo = toDoText;
        toDoObj.updateDate = [NSDate date];
        toDoObj.group = nil;
        toDoObj.order = 0;
        toDoObj.whichStatus = [self insertStatus:status];
        
        
    }
    
    if(![self.dbContext save:&error]) {
        NSLog(@"error when saving : %@", [error localizedDescription]);
    }
    
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
