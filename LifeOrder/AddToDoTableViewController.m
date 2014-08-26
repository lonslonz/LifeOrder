//
//  AddToDoTableViewController.m
//  LifeOrder
//
//  Created by 이종민 on 2014. 8. 22..
//  Copyright (c) 2014년 moya. All rights reserved.
//

#import "AddToDoTableViewController.h"

@interface AddToDoTableViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSArray* pickerData;

@end

@implementation AddToDoTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerData = @[@"Begin", @"End", @"Complete Order", @"Waiting delivery", @"Delaying delivery",
                        @"Problem with product", @"Requesting refund", @"Wating refund",  @"Close",
                        @"very very very very very very very long char"];
    
    int index;
    if([self.statusStr length] > 0) {
        index = [self findPickerIndexFromStatusStr:self.statusStr];
    } else {
        index = 0;
        self.statusStr = self.pickerData[0];
    }
    self.toDoTextField.text = self.toDoStr;
    [self.statusPicker selectRow:index inComponent:0 animated:YES];
}

- (int)findPickerIndexFromStatusStr:(NSString *)statusStr
{
    for(int i = 0; i <= [self.pickerData count] - 1; i++) {
        if([self.pickerData[i] isEqualToString:statusStr]) {
            return i;
        }
    }
    return 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"text return");
    
    return YES;
}

- (IBAction)cancel:(id)sender {
    NSLog(@"push cancel");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)addStatus:(id)sender {
    
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
    NSLog(@"Selected Status : %d, %@", row, self.pickerData[row]);
    self.statusStr = self.pickerData[row];
    
}
#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(![self.toDoTextField.text length]) {
        [self alert:@"Please type To Do field."];
        return false;
    }
    return true;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"exit prepareForSegue. typed : %@, status : %@", self.toDoTextField.text, self.statusStr);
}

- (void)alert:(NSString *)message
{
   [[[UIAlertView alloc] initWithTitle:@"Add to do"
                              message : message
                             delegate : nil
                    cancelButtonTitle : nil
                     otherButtonTitles:@"OK", nil] show];
    
}
@end
