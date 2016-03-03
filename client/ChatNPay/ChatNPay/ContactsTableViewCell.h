//
//  ContactsTableViewCell.h
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
