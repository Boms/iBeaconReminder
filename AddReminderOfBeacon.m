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

-(void)removeMySelf
{
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if (self.reminder) {
        [user removeReminderWith:self.myBeacon with:self.reminder];
    }
}

-(void)trashAction
{
    [self removeMySelf];
    [self cancelButtonAction];
}

-(void)okButtonAction
{
    iBeaconUser *user = [iBeaconUser sharedInstance];

    if (self.reminderTextField.text && ![self.reminderTextField.text isEqualToString:@""]) {
        [self removeMySelf];
        [user AddRemindersWith:self.myBeacon with:self.reminderTextField.text friends:self.friendsTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)cancelButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)inviteFriendsButtonAction
{
    [self.friendsTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Do any additional setup after loading the view from its nib.
    
    UILabel *marker = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 31)];
    marker.text = @"标题";
    marker.textColor = [UIColor grayColor];
    [self.view addSubview:marker];
    
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(70, 100, 220, 31)];
    title.borderStyle = UITextBorderStyleNone;
    title.placeholder = @"交个外卖?";
    title.delegate = self;
    title.allowsEditingTextAttributes = NO;
    title.returnKeyType = UIReturnKeyNext;
    title.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIToolbar *doneButtonbar = [[UIToolbar alloc] init];
    [doneButtonbar sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(okButtonAction)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *inviteFriendsButton = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriendsButtonAction)];

    [doneButtonbar setItems:@[flexSpace, inviteFriendsButton, doneButton, cancelButton]];
    title.inputAccessoryView = doneButtonbar;
    self.reminderTextField = title;

    UILabel *markerForFriend = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 50, 31)];
    markerForFriend.text = @"邀请";
    markerForFriend.textColor = [UIColor grayColor];
    [self.view addSubview:markerForFriend];
    
    UITextField *friends = [[UITextField alloc] initWithFrame:CGRectMake(70, 170, 220, 31)];
    friends.borderStyle = UITextBorderStyleLine;
    friends.placeholder = @"和张三?";
    friends.delegate = self;
    friends.allowsEditingTextAttributes = NO;

    friends.clearButtonMode = UITextFieldViewModeWhileEditing;
    friends.returnKeyType = UIReturnKeyDone;
    UIToolbar *inviteFriendsBar = [[UIToolbar alloc] init];
    [inviteFriendsBar sizeToFit];
    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(okButtonAction)];

    UIBarButtonItem *cancelButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    UIBarButtonItem *emptyButton = [[UIBarButtonItem alloc] initWithTitle:@"invite" style:UIBarButtonItemStyleBordered target:nil action:nil];

    [inviteFriendsBar setItems:@[flexSpace,  doneButton2, cancelButton2]];
    friends.inputAccessoryView = inviteFriendsBar;
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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashAction)];
    self.navigationController.toolbarHidden = YES;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *reminder = self.reminder;
    if (!reminder) {
        [self.reminderTextField becomeFirstResponder];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.reminderTextField){
        [self.friendsTextField becomeFirstResponder];
    }
    if (textField == self.friendsTextField) {
        if (self.reminderTextField.text && ![self.reminderTextField.text isEqualToString:@""]) {
            [textField resignFirstResponder];
        }else{
            [self.reminderTextField becomeFirstResponder];
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
