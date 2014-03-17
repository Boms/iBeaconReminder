//
//  AddReminderOfBeacon.m
//  beaconDemo
//
//  Created by li lin on 3/4/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "AddReminderOfBeacon.h"

@interface AddReminderOfBeacon ()
@property (nonatomic,strong) UITextField *name;
@property (nonatomic,strong) UITextField *friends;
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
    [user AddRemindersWith:self.myBeacon with:self.name.text friends:self.friends.text];
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
    title.placeholder = @"TODO list";
    title.delegate = self;
    title.allowsEditingTextAttributes = NO;
    self.name = title;

    
    UITextField *friends = [[UITextField alloc] initWithFrame:CGRectMake(30, 170, 250, 50)];
    friends.borderStyle = UITextBorderStyleRoundedRect;
    friends.placeholder = @"朋友";
    friends.delegate = self;
    friends.allowsEditingTextAttributes = NO;
    self.friends = friends;
    
    NSString *reminder = self.reminder;
    if (reminder) {
        title.text = reminder;
    }
    if (self.reminderDict) {
        self.friends.text = [self.reminderDict objectForKey:@"friends"];
    }
    [self.view addSubview:title];
    [self.view addSubview:friends];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updateButton addTarget:self action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setTitle:@"Confirm" forState:UIControlStateNormal];
    updateButton.frame = CGRectMake(80, 250, 100, 50);
    [self.view addSubview:updateButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(180, 250, 100, 50);
    [self.view addSubview:cancelButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
