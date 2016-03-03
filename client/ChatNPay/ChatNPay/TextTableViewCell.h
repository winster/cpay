//
//  TextTableViewCell.h
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextTableViewCell : UITableViewCell {
    
    UIImageView *messageBackgroundView;

}

@property(nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic,strong) NSString *bubbletype;
@property (nonatomic,strong) UIImageView *AvatarImageView;


- (void)showMenu;


@end


