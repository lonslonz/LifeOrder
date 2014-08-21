//
//  CreateToDoViewController.m
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 21..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import "CreateToDoViewController.h"

@interface CreateToDoViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray* pickerData;
@end

@implementation CreateToDoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerData = @[@"", @"Complete Order", @"Waiting", @"Done"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"text return");
    return YES;
}

- (IBAction)done:(id)sender {
    NSLog(@"push done");
}
- (IBAction)cancel:(id)sender {
    NSLog(@"push cancel");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setPassedStr:(NSString *)passedStr
{
    NSLog(@"passedStr by Segue:%@", passedStr);
    _passedStr = passedStr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - picker
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Selected Workflow : %d, %@", row, self.pickerData[row]);
}
#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"exit prepareForSegue : %@", self.textTyped.text);
    
}

@end