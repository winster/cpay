//
//  ContactDetailTableViewController.m
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ContactDetailTableViewController.h"
#import "ContactsDatabase.h"

@interface ContactDetailTableViewController ()

@end

@implementation ContactDetailTableViewController

@synthesize contactsObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    if (contactsObject) {
        
        [self.userNameTextField setText:contactsObject.userId];
        [self.nickNameTextField setText:contactsObject.nickName];
        [self.favouriteAmountTextField setText:contactsObject.favAmount];
        [self.phoneNumberTextField setText:contactsObject.phoneNumber];
        [self.aadharNumberTextField setText:contactsObject.aadharNumber];
        [self.virtualAddressTextField setText:contactsObject.virtualPaymentAddress];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnSaveButtonClicked:(id)sender {
    
    NSLog(@"Save Clicked");
    
    NSString *usernameVal = [self.userNameTextField text];
    NSString *nicknameVal = [self.nickNameTextField text];
    NSString *favamountVal = [self.favouriteAmountTextField text];
    NSString *phonenumberVal = [self.phoneNumberTextField text];
    NSString *aadharnumberVal = [self.aadharNumberTextField text];
    NSString *virtualaddressVal = [self.virtualAddressTextField text];
    
    //NSLog(@"BillName:%@  Amount:%@  Category:%@  Due Date:%@  Repeat:%@", billNameVal, amountVal, categoryVal, dueDateVal, repeatVal);
    
    
    if ([usernameVal isEqualToString:@""] || [nicknameVal isEqualToString:@""] ||
        [favamountVal isEqualToString:@""] || [phonenumberVal isEqualToString:@""] ||
        [aadharnumberVal isEqualToString:@""] || [virtualaddressVal isEqualToString:@""]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ChatNPay" message:@"All fields Mandatory" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else {
        
        if (contactsObject == NULL) {
            contactsObject = [[ContactsObject alloc] initWithUniqueId:0 userId:usernameVal nickName:nicknameVal favAmount:favamountVal phoneNumber:phonenumberVal aadharNumber:aadharnumberVal virtualPaymentAddress:virtualaddressVal];
            
        } else {
            contactsObject = [[ContactsObject alloc] initWithUniqueId:contactsObject.uniqueId userId:usernameVal nickName:nicknameVal favAmount:favamountVal phoneNumber:phonenumberVal aadharNumber:aadharnumberVal virtualPaymentAddress:virtualaddressVal];

            
        }
        
        [[ContactsDatabase database] saveContactsData:contactsObject];
        

        [self.navigationController popViewControllerAnimated:YES];
        
      
    }
    
    
    

    
    
}

@end
