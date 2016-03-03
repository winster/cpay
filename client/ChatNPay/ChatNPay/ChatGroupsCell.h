//
//  ChatGroupsCell.h
//  ChatNPay
//
//  Created by venkat on 27/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatGroupsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
