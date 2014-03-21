//
//  AddReminderOfBeacon.m
//  beaconDemo
//
//  Created by li lin on 3/4/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "AddReminderOfBeacon.h"

@interface AddReminderOfBeacon ()
@property (nonatomic,strong) UITextField *reminderTextField;
@property (nonatomic,strong) UITextField *friendsTextField;
@end

@implementation AddReminderOfBeacon

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)okButton
{
    iBeaconUser *user = [iBeaconUser sharedInstance];
    
    if (self.reminder) {
        [user removeReminderWith:self.myBeacon with:self.reminder];
    }
    [user AddRemindersWith:self.myBeacon with:self.reminderTextField.text friends:self.friendsTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancelButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Do any additional setup after loading the view from its nib.
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 250, 50)];
    title.borderStyle = UITextBorderStyleRoundedRect;
    title.placeholder = @"交个外卖?";
    title.delegate = self;
    title.allowsEditingTextAttributes = NO;
    title.returnKeyType = UIReturnKeyNext;
    self.reminderTextField = title;

    
    UITextField *friends = [[UITextField alloc] initWithFrame:CGRectMake(30, 170, 250, 50)];
    friends.borderStyle = UITextBorderStyleRoundedRect;
    friends.placeholder = @"和张三?";
    friends.delegate = self;
    friends.allowsEditingTextAttributes = NO;
    friends.returnKeyType = UIReturnKeyGo;
    self.friendsTextField = friends;
    
    NSString *reminder = self.reminder;
    if (reminder) {
        title.text = reminder;
    }
    if (self.reminderDict) {
        self.friendsTextField.text = [self.reminderDict objectForKey:@"friends"];
    }
    [self.view addSubview:title];
    [self.view addSubview:friends];

    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(okButton)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, saveBtn, flexSpace, cancelBtn, flexSpace];
    self.navigationController.toolbarHidden = NO;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.reminderTextField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.reminderTextField){
        [self.friendsTextField becomeFirstResponder];
    }
    if (textField == self.friendsTextField) {
        [self okButton];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
