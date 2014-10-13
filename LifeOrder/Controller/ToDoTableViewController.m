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
@property (nonatomic, weak) ToDo *currToDo;
@property (nonatomic, assign) BOOL reorderMode;
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
    self.reorderMode = NO;
}

- (void)setUpFetchResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TABLE_NAME];
    request.predicate = [NSPredicate predicateWithFormat:@"whichStatus.status != %@", STATUS_END];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order"
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

- (IBAction)reorder:(UIBarButtonItem *)sender {
    if(!self.reorderMode) {
        sender.title = @"Done";
        self.reorderMode = YES;
        [self.tableView setEditing:YES animated:YES];
    } else { // done
        sender.title = @"Reorder";
        self.reorderMode = NO;
        [self.tableView setEditing:NO animated:YES];
        
        //save all
        NSError *error;
        if(![self.dbContext save:&error]) {
            NSLog(@"error when saving : %@", [error localizedDescription]);
        }
    }
   
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
 //   NSString *stringToMove = [self.reorderingRows objectAtIndex:sourceIndexPath.row];
//    [self.reorderingRows removeObjectAtIndex:sourceIndexPath.row];
//    [self.reorderingRows insertObject:stringToMove atIndex:destinationIndexPath.row];
    NSLog(@"stringToMove:%d, destinaionIndexPath.row:%d", sourceIndexPath.row, destinationIndexPath.row);
    NSInteger fromIndex = sourceIndexPath.row;
    NSInteger toIndex = destinationIndexPath.row;
    
    NSInteger diff = toIndex - fromIndex;
    if(diff == 0) {
        return;
    }
    
    if(diff > 0) { // move down
        ToDo *fromToDo = [self findToDoByIndex:fromIndex];
        fromToDo.order = @(diff + [fromToDo.order intValue]);
        
        for(NSInteger i = fromIndex + 1; i <= toIndex; i++) {
            ToDo *current = [self findToDoByIndex:i];
            current.order = @([current.order intValue] - 1);
        }
    } else { // move up
        ToDo *fromToDo = [self findToDoByIndex:fromIndex];
        fromToDo.order = @(diff + [fromToDo.order intValue]);
        
        for(NSInteger i = toIndex; i < fromIndex; i++) {
            ToDo *current = [self findToDoByIndex:i];
            current.order = @([current.order intValue] + 1);
        }
    }
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
#pragma mark - fetched data management
- (void)resetOrder
{
    NSArray *objs = [self.fetchedResultsController fetchedObjects];
    NSInteger count = 1;
    for(ToDo *item in objs) {
        item.order = @(count);
        count++;
    }
}
- (ToDo *)findToDoByOrder:(NSInteger)order
{
    NSArray *objs = [self.fetchedResultsController fetchedObjects];
    for(ToDo *item in objs) {
        if([item.order isEqual:@(order)]) {
            return item;
        }
    }
    return nil;
}

- (ToDo *)findToDoByName:(NSString *)toDo
{
    NSArray *objs = [self.fetchedResultsController fetchedObjects];
    for(ToDo *item in objs) {
        if([item.toDo isEqualToString:toDo]) {
            return item;
        }
    }
    return nil;
}
- (ToDo *)findToDoByIndex:(NSInteger)index
{
    NSArray *objs = [self.fetchedResultsController fetchedObjects];
    return [objs objectAtIndex:index];
}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    
    ToDo *toDo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", toDo.toDo, toDo.order];
    cell.detailTextLabel.text = toDo.whichStatus.status;
    cell.showsReorderControl = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    NSLog(@"selected row when didSelected :%d", self.selectedIndexPath.row);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.currToDo = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerDidChangeContent:controller];
    
}

#pragma mark - Navigation

- (IBAction)addToDo:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[AddToDoTableViewController class]]) {
        
        AddToDoTableViewController *addToDoVc = (AddToDoTableViewController *)segue.sourceViewController;
        NSLog(@"Pop results. typed : %@, selected : %@", addToDoVc.toDoTextField.text, addToDoVc.statusStr);

        ToDo *tempToDo = (ToDo *)[[self.fetchedResultsController fetchedObjects] lastObject];
        [self insertOrUpdateToDo:addToDoVc.toDoTextField.text
                          status:addToDoVc.statusStr
                           order:[tempToDo.order integerValue]+ 1];
        
        NSLog(@"selected row when prepareForSegue :%d", self.selectedIndexPath.row);
 //       [self.tableView reloadData];
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
        
        self.currToDo = nil;
    }
    else if([segue.identifier isEqualToString:@"UpdateToDoSegue"]) {
        if([segue.destinationViewController isKindOfClass:[AddToDoTableViewController class]]) {
            AddToDoTableViewController *addToDoVc = (AddToDoTableViewController *)segue.destinationViewController;

         //   NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
 
            addToDoVc.toDoStr = self.currToDo.toDo;
            addToDoVc.statusStr = self.currToDo.whichStatus.status;
            

        }
    }
}

#pragma mark - Database
- (ToDo *)insertOrUpdateToDo:(NSString *)newToDoText status:(NSString *)newStatus order:(NSInteger)newOrder
{
//    NSFetchRequest *selectRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDo"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toDo = %@", self.currToDo.toDo];
//    selectRequest.predicate = predicate;
//    NSError *error;
//    NSArray *matches = [self.dbContext executeFetchRequest:selectRequest error:&error];

    ToDo *matches = [self findToDoByName:self.currToDo.toDo];
    ToDo *toDoObj = nil;
    if(matches) {
        // update
        toDoObj = matches;
        toDoObj.toDo = newToDoText;
        toDoObj.whichStatus.status = newStatus;
        NSLog(@"update new order : %@", toDoObj.order);
    } else {
        toDoObj = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo"
                                                  inManagedObjectContext:self.dbContext];
        toDoObj.toDo = newToDoText;
        toDoObj.updateDate = [NSDate date];
        toDoObj.group = nil;
        toDoObj.order = @(newOrder);
        toDoObj.whichStatus = [self createNewStatus:newStatus];
        NSLog(@"insert new order : %@", toDoObj.order);
    }
    NSError *error;
    if(![self.dbContext save:&error]) {
        NSLog(@"error when saving : %@", [error localizedDescription]);
    }
    
    return toDoObj;
}

- (Status *)createNewStatus:(NSString *)newStatus
{
    Status *statusObj = [NSEntityDescription insertNewObjectForEntityForName:@"Status"
                                                      inManagedObjectContext:self.dbContext];
    statusObj.status = newStatus;
    statusObj.group = nil;
    statusObj.order = 0;
    statusObj.updateDate = [NSDate date];
    return statusObj;
}
@end
