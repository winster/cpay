//
//  GroupChatObject.h
//  ChatNPay
//
//  Created by venkat on 27/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupChatObject : NSObject {
    
    int _uniqueId;
    NSString *_messageType;
    NSString *_messageText;
    NSString *_date;
    NSString *_amount;
    NSString *_txnId;
    NSString *_txnStatus;
   
    
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *messageType;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *txnId;
@property (nonatomic, copy) NSString *txnStatus;


@end
