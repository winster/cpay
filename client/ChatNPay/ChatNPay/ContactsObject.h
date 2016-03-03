//
//  ContactsObject.h
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsObject : NSObject {
    
    int _uniqueId;
    NSString *_userId;
    NSString *_nickName;
    NSString *_favAmount;
    NSString *_phoneNumber;
    NSString *_aadharNumber;
    NSString *_virtualPaymentAddress;

}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *favAmount;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *aadharNumber;
@property (nonatomic, copy) NSString *virtualPaymentAddress;

- (id)initWithUniqueId:(int)uniqueId userId:(NSString *)userId nickName:(NSString *)nickName
             favAmount:(NSString *)favAmount phoneNumber:(NSString *)phoneNumber aadharNumber:(NSString *)aadharNumber
 virtualPaymentAddress:(NSString *)virtualPaymentAddress;

@end
