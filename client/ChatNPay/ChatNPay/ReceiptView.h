//
//  ReceiptView.h
//  ChatNPay
//
//  Created by venkat on 27/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptView : UIView {
    
    UILabel *_amountLabel;
}
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *refIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
