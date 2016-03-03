//
//  UserProfileTableViewController.h
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *virtualAddress;

@end
