//
//  ChatGroupsCell.m
//  ChatNPay
//
//  Created by venkat on 27/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ChatGroupsCell.h"

@implementation ChatGroupsCell


- (void)awakeFromNib {
    // Initialization code
    
    
    CALayer * l = [self.userImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:self.userImage.frame.size.width/2.0];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
