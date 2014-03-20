//
//  graCreateReminderViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/20/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graCreateReminderViewController.h"
#import "iBeaconUser.h"
@interface graCreateReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *reminderString;
@property (weak, nonatomic) IBOutlet UIPickerView *beaconSlider;
@property (strong, nonatomic) CLBeacon *selectedBeacon;

@end

@implementation graCreateReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.beaconSlider setDelegate:self];
    [self.beaconSlider setDataSource:self];
    [self.reminderString setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.beaconSlider selectRow:0 inComponent:0 animated:YES];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.beaconSlider) {
        return 1;
    }
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if(pickerView == self.beaconSlider){
        return [user.namesOfBeacon count];
    }
    return 0;
}
- (IBAction)OKButton:(id)sender {
    if (self.reminderString.text && ![self.reminderString.text isEqualToString:@""]) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        [user AddRemindersWith:self.selectedBeacon with:self.reminderString.text friends:@""];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)CancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if (pickerView == self.beaconSlider) {
        NSDictionary *each = [user.namesOfBeacon objectAtIndex:row];
        NSData *archieved = [each objectForKey:@"beacon"];
        CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
        NSString *beaconName = [each objectForKey:@"name"];
        title = beaconName;
    }
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    iBeaconUser *user = [iBeaconUser sharedInstance];

    if (pickerView == self.beaconSlider) {
        NSDictionary *each = [user.namesOfBeacon objectAtIndex:row];
        NSData *archieved = [each objectForKey:@"beacon"];
        CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
        self.selectedBeacon =thisBeacon;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.reminderString) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

@end
