//
//  RemindObject.h
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindObject : NSObject {
    
    NSString *_title;
    NSString *_description;
    NSString *_amount;
    NSString *_remind;
    NSString *_virtualaddress;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *remind;
@property (nonatomic, copy) NSString *virtualaddress;

@end
