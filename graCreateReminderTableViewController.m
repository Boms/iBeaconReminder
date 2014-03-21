//
//  graCreateReminderTableViewController.m
//  beaconReminderDemo
//
//  Created by li lin on 3/21/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graCreateReminderTableViewController.h"

@interface graCreateReminderTableViewController ()
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *locationField;
@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) NSString *selectedBeaconName;
@property (nonatomic, strong) CLBeacon *selectedBeacon;
@property (nonatomic, strong) UIPickerView* beaconSlider;
@property (nonatomic) NSInteger currentRowCount;
@end

@implementation graCreateReminderTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Cancel)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexSpace, saveBtn, flexSpace, cancelBtn, flexSpace];
    self.navigationController.toolbarHidden = NO;
    self.currentRowCount = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.currentRowCount;
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.titleField becomeFirstResponder];
    [self.beaconSlider selectRow:0 inComponent:0 animated:YES];
    iBeaconUser *user = [iBeaconUser sharedInstance];
    NSDictionary *each = [user.namesOfBeacon objectAtIndex:0];
    NSData *archieved = [each objectForKey:@"beacon"];
    CLBeacon *thisBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:archieved];
    self.selectedBeacon =thisBeacon;
    NSString *beaconName = [each objectForKey:@"name"];
    self.selectedBeaconName = beaconName;

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

-(void) Save
{
    if (self.titleField.text && ![self.titleField.text isEqualToString:@""]) {
        iBeaconUser *user = [iBeaconUser sharedInstance];
        [user AddRemindersWith:self.selectedBeacon with:self.titleField.text friends:@""];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)Cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    iBeaconUser *user = [iBeaconUser sharedInstance];
    if (pickerView == self.beaconSlider) {
        NSDictionary *each = [user.namesOfBeacon objectAtIndex:row];
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
    if (textField == self.titleField) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.locationField) {
        NSArray *insertIndexPaths = @[[NSIndexPath indexPathForRow:2 inSection:0]];
        self.currentRowCount = 3;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        return YES;
    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    if (indexPath.row == 0) {

        CGRect cellBounds = cell.bounds;
        CGFloat textFieldBorder = 10.f;
        // Don't align the field exactly in the vertical middle, as the text
        // is not actually in the middle of the field.
        CGRect aRect = CGRectMake(textFieldBorder, 9.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
        UITextField *titleField = [[UITextField alloc] initWithFrame:aRect];
        titleField.enablesReturnKeyAutomatically = YES;
        titleField.placeholder = @"比如中午交个外卖";
        titleField.tintColor = [UIColor redColor];
        titleField.returnKeyType = UIReturnKeyDone;
        [titleField setDelegate:self];
//        titleField.borderStyle = UITextBorderStyleRoundedRect;
        self.titleField = titleField;
        [cell.contentView addSubview:titleField];
    }
    if (indexPath.row == 1) {
        CGRect cellBounds = cell.bounds;
        CGFloat textFieldBorder = 10.f;
        CGRect aRect = CGRectMake(textFieldBorder, 9.f, CGRectGetWidth(cellBounds)-(2*textFieldBorder), 31.f );
        UITextField *titleField = [[UITextField alloc] initWithFrame:aRect];
        titleField.enablesReturnKeyAutomatically = YES;
        titleField.placeholder = @"位置";
        titleField.tintColor = [UIColor redColor];
        titleField.returnKeyType = UIReturnKeyDone;
        [titleField setDelegate:self];
        self.locationField = titleField;
        [cell.contentView addSubview:titleField];

        cell.textLabel.text = self.selectedBeaconName;

    }
    if (indexPath.row ==2 ) {
        cell.textLabel.text = @"slide here";
    }
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
