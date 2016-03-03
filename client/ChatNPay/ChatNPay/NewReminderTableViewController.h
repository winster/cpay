//
//  NewReminderTableViewController.h
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewReminderTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextview;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;

@property (weak, nonatomic) IBOutlet UITableViewCell *reminderCell;

@property (nonatomic, strong) NSString *virtualAddress;
@end
