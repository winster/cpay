//
//  UserProfileTableViewController.m
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import "Constants.h"

@interface UserProfileTableViewController ()

@end

@implementation UserProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:TITLEBAR_BG_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];



    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self populateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnSaveButtonClicked:(id)sender {
    
    NSString *nicknameVal = [self.nickName text];
    NSString *phonenumberVal = [self.phoneNumber text];
    NSString *virtualaddressVal = [self.virtualAddress text];
    
    if ([nicknameVal isEqualToString:@""] || [phonenumberVal isEqualToString:@""]
        || [virtualaddressVal isEqualToString:@""]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ChatNPay" message:@"All fields Mandatory" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nicknameVal forKey:@"usernickname"];
        [defaults setObject:phonenumberVal forKey:@"userphonenumber"];
        [defaults setObject:virtualaddressVal forKey:@"uservirtualaddress"];

        [defaults synchronize];
        
     //   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ChatNPay" message:@"Profile Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      //  [alertView show];
        
        
        
    }
    
    [self.virtualAddress resignFirstResponder];
    
}

-(void)populateData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults valueForKey:@"usernickname"])
        self.nickName.text = [defaults valueForKey:@"usernickname"];
    if ([defaults valueForKey:@"userphonenumber"])
        self.phoneNumber.text = [defaults valueForKey:@"userphonenumber"];
    if ([defaults valueForKey:@"uservirtualaddress"])
        self.virtualAddress.text = [defaults valueForKey:@"uservirtualaddress"];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    
}

@end
