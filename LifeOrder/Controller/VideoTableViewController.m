//
//  VideoTableViewController.m
//  LifeOrder
//
//  Created by 1000653 on 2014. 10. 8..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import "VideoTableViewController.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "SubRipParser.h"

@interface VideoTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UITableView *captionTableView;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) NSString *captionText;
@property(nonatomic, strong) NSArray *captionItems;
@property(nonatomic, assign, getter=isInit) bool init;
@property(nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property(nonatomic, strong) NSTimer *captionTimer;
@end

@implementation VideoTableViewController

/*
 Todo : 
 - click 시 jump 하기
 - 말하는 부분을 빨간 색으로 보여주기
 */
- (IBAction)clickScroll:(id)sender {
    
    [self mapCaption];
}
- (void)mapCaption {
    
    NSTimeInterval currentTime = self.videoPlayerViewController.moviePlayer.currentPlaybackTime;
    if(isnan(currentTime)) {
        return;
    }
    
    NSLog(@"%f", self.videoPlayerViewController.moviePlayer.currentPlaybackTime);
    NSInteger i;
    for(i = 0; i < [self.captionItems count]; i++) {
        SubRipItem *item = [self.captionItems objectAtIndex:i];
        if(currentTime <= item.endTime) {
            break;
        }
    }
    if(i > [self.captionItems count]) {
        return;
    }
    NSIndexPath *myPos = [NSIndexPath indexPathForRow:i inSection:0];
    
    
    [self.captionTableView scrollToRowAtIndexPath:myPos atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoPlayerViewController =
        [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"MnrJzXM7a6o"];
    [self.videoPlayerViewController presentInView:self.videoView];
    [self.videoPlayerViewController.moviePlayer play];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.captionText = [self readSrc:@"Steve" extentsion:@"srt"];
    id myRipParser = [[SubRipParser alloc] initWithSubRipContent:self.captionText];
    [myRipParser parseWithBlockSync:^(BOOL success, SubRipItems *items) {
        self.captionItems = [items items];
    }];
    self.init = NO;
    NSLog(@"self init : %i", self.init);
    
    self.captionTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                         target:self
                                                       selector:@selector(mapCaption)
                                                       userInfo:nil
                                                        repeats:YES];
}
- (void)awakeFromNib
{
   // self.init = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    NSLog(@"self init : %i", self.init);
    if(self.init == NO) {
        [self.captionTableView reloadData];
    }
    self.init = YES;
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
   // [self.videoView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)readSrc:(NSString *)fileName extentsion:(NSString *)extention
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:extention];
    
    NSError *error;
    NSString *strFileContent = [NSString stringWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {  //Handle error
        NSLog(@"error when reading");
    }
    
    NSLog(@"File content : %@ ", strFileContent);

    return strFileContent;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.captionItems count];
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    cell = [tableView dequeueReusableCellWithIdentifier:@"caption" forIndexPath:indexPath];
    
//    NSLog(@"%@", self.captionItems);
//    NSLog(@"%@", [[self.captionItems objectAtIndex:indexPath.row] text]);
//    
    SubRipItem *currItem = [self.captionItems objectAtIndex:indexPath.row];
    
    NSString *cellStr = [NSString stringWithFormat:@"(%i)%@ (%f) ~ (%f)",
                          [currItem subtitleNumber],
                          [currItem text],
                         [currItem startTime],
                         [currItem endTime]];
                         
    
    cell.textLabel.text = cellStr;
    //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping; // Pre-iOS6 use UILineBreakModeWordWrap
    cell.textLabel.numberOfLines = 0;  // 0 means no max.
    //cell.textLabel.text = [self.data objectAtIndex:indexPath.row];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select:%li", indexPath.row);
    SubRipItem *curr = [self.captionItems objectAtIndex:indexPath.row];
    
    [self.videoPlayerViewController.moviePlayer setCurrentPlaybackTime:curr.startTime];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
