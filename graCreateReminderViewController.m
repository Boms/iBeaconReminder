//
//  graCreateReminderViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/20/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graCreateReminderViewController.h"

@interface graCreateReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *reminderString;
@property (weak, nonatomic) IBOutlet UIPickerView *beaconSlider;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
