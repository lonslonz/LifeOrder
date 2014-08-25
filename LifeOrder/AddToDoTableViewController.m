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
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;
@end

@implementation AddToDoTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerData = @[@"Begin", @"End", @"Complete Order", @"Waiting delivery", @"Delaying delivery",
                        @"Problem with product", @"Requesting refund", @"Wating refund",  @"Close",
                        @"very very very very very very very long char"];
    [self.statusPicker selectRow:0 inComponent:0 animated:YES];
    self.statusSelected = self.pickerData[0];
    
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
}


- (void)setPassedStr:(NSString *)passedStr
{
    NSLog(@"passedStr by Segue:%@", passedStr);
    _passedStr = passedStr;
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
    self.statusSelected = self.pickerData[row];
    
}
#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(![self.toDoTyped.text length]) {
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
    NSLog(@"exit prepareForSegue. typed : %@, status : %@", self.toDoTyped.text, self.statusSelected);
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
