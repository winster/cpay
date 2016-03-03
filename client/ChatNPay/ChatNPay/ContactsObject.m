//
//  ContactsObject.m
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ContactsObject.h"

@implementation ContactsObject

@synthesize uniqueId = _uniqueId;
@synthesize userId = _userId;
@synthesize nickName = _nickName;
@synthesize favAmount = _favAmount;
@synthesize phoneNumber = _phoneNumber;
@synthesize aadharNumber = _aadharNumber;
@synthesize virtualPaymentAddress = _virtualPaymentAddress;




- (id)initWithUniqueId:(int)uniqueId userId:(NSString *)userId nickName:(NSString *)nickName
                  favAmount:(NSString *)favAmount phoneNumber:(NSString *)phoneNumber aadharNumber:(NSString *)aadharNumber
                  virtualPaymentAddress:(NSString *)virtualPaymentAddress{
    
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.userId = userId;
        self.nickName = nickName;
        self.favAmount = favAmount;
        self.phoneNumber = phoneNumber;
        self.aadharNumber = aadharNumber;
        self.virtualPaymentAddress = virtualPaymentAddress;
        
        
    }
    return self;
    
}

@end
