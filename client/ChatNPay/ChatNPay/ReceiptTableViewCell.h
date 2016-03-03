//
//  ReceiptTableViewCell.h
//  ChatNPay
//
//  Created by venkat on 27/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (nonatomic, strong) UIView *receiptView;
@property(nonatomic, retain) UILabel *timestampLabel;


@property (nonatomic,strong) NSString *bubbletype;
@property (nonatomic,strong) UIImageView *AvatarImageView;



@end
