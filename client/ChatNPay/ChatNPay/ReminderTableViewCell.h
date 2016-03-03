//
//  ReminderTableViewCell.h
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindOnLabel;

@end
