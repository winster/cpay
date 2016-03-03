//
//  ReceiptTableViewCell.m
//  ChatNPay
//
//  Created by venkat on 27/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ReceiptTableViewCell.h"
#import "Constants.h"

@implementation ReceiptTableViewCell

@synthesize timestampLabel = _timestampLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = NSTextAlignmentCenter;
        _timestampLabel.backgroundColor = [UIColor clearColor];
        _timestampLabel.font = [UIFont systemFontOfSize:12.0f];
        _timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        _timestampLabel.frame = CGRectMake(0.0f, 0, self.bounds.size.width, 18);
        
        [self.contentView addSubview:_timestampLabel];

        self.receiptView = [[[NSBundle mainBundle] loadNibNamed:@"ReceiptView" owner:self options:nil] objectAtIndex:0];
        
        [self.contentView addSubview:self.receiptView];

        self.AvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,10+TOP_MARGIN, 50, 50)];
        
        [self.contentView addSubview:self.AvatarImageView];
        
        

        
        CALayer * l = [self.AvatarImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:self.AvatarImageView.frame.size.width/2.0];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.bubbletype isEqualToString:@"LEFT"])
    {
        self.AvatarImageView.frame=CGRectMake(5,10+TOP_MARGIN, 50, 50);
        self.receiptView.frame=CGRectMake(55,30, 240,  240);
    }else
    {
        self.AvatarImageView.frame=CGRectMake( self.frame.size.width-55,10+TOP_MARGIN, 50, 50);
        self.receiptView.frame=CGRectMake(self.frame.size.width-55 - 240,30, 240,  240);

    }
    
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 10); //start at this point
    CGContextAddLineToPoint(context, (self.bounds.size.width - 120) / 2, 10); //draw to this point
    
    CGContextMoveToPoint(context, self.bounds.size.width, 10); //start at this point
    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 120) / 2, 10); //draw to this point
    
    CGContextStrokePath(context);
    
}

@end
