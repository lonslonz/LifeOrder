//
//  AddToDoTableViewController.h
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 22..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToDoTableViewController : UITableViewController
@property (nonatomic, strong) NSString* passedStr;
@property (weak, nonatomic) IBOutlet UITextField *textTyped;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerStatus;
@end
