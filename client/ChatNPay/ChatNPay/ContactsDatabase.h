//
//  ContactsDatabase.h
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ContactsObject.h"

@interface ContactsDatabase : NSObject {
    sqlite3 *_database;
    
}

@property (nonatomic, strong) NSString *databasePath;
+ (ContactsDatabase *)database;
- (BOOL) saveContactsData : (ContactsObject *)contactsObject;
- (BOOL) deleteContactsData : (ContactsObject *)contactsObject;
- (NSMutableArray *)getContactObjectInfos;



@end
