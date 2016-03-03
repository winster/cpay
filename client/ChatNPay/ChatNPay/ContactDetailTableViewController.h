//
//  ContactDetailTableViewController.h
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsObject.h"

@interface ContactDetailTableViewController : UITableViewController <UITextFieldDelegate> {
    
    ContactsObject *contactsObject;

}

@property (strong, nonatomic) ContactsObject *contactsObject;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *favouriteAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *aadharNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *virtualAddressTextField;

@end
