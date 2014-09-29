//
//  AddToDoTableViewController.h
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 22..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToDoTableViewController : UITableViewController

@property (nonatomic, strong) NSString *toDoStr;
@property (strong, nonatomic) NSString *statusStr;

@property (weak, nonatomic) IBOutlet UITextField *toDoTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;

@end
