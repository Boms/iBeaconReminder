//
//  updateNameViewController.m
//  beaconDemo
//
//  Created by li lin on 3/3/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "updateNameViewController.h"
#import "colorForMarker.h"

@interface updateNameViewController ()
@property (nonatomic,strong) UITextField *name;
@end

@implementation updateNameViewController

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
    [user setNameForBeacon:self.myBeacon with:self.name.text];
    [user saveAllData];
    if (self.nameChanged) {
        self.nameChanged(self.myBeacon);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    title.placeholder = @"title  will be here";
    title.delegate = self;
    title.allowsEditingTextAttributes = NO;
    title.returnKeyType = UIReturnKeyDone;
    title.tintColor = [colorForMarker markerColor];
    self.name = title;
    
    iBeaconUser *user = [iBeaconUser sharedInstance];
    NSString *name = [user findNameByBeacon:self.myBeacon];
    if (name) {
        title.text = name;
    }
    [self.view addSubview:title];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(okButton)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, saveBtn, flexSpace, cancelBtn, flexSpace];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.name becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.name && ![self.name.text isEqualToString:@""]) {
        [self.name resignFirstResponder];
        [self okButton];
        return YES;
    }
    return NO;


}

@end
