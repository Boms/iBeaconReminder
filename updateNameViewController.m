//
//  updateNameViewController.m
//  beaconDemo
//
//  Created by li lin on 3/3/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "updateNameViewController.h"

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
    title.placeholder = @"title  will be here";
    title.delegate = self;
    title.allowsEditingTextAttributes = NO;
    self.name = title;
    
    iBeaconUser *user = [iBeaconUser sharedInstance];
    NSString *name = [user findNameByBeacon:self.myBeacon];
    if (name) {
        title.text = name;
    }
    [self.view addSubview:title];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updateButton addTarget:self action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setTitle:@"Confirm" forState:UIControlStateNormal];
    updateButton.frame = CGRectMake(80, 200, 100, 50);
    [self.view addSubview:updateButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
