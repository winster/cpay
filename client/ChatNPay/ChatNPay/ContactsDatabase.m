//
//  ContactsDatabase.m
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ContactsDatabase.h"

@implementation ContactsDatabase

@synthesize databasePath;


static ContactsDatabase *_database;

+ (ContactsDatabase *)database {
    
    if (_database == nil) {
        _database = [[ContactsDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSLog(@"Path:%@", docsDir);
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent:@"contacts.db"]];
        
        //NSLog(@"DB Path:%@", databasePath);
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        //the file will not be there when we load the application for the first time
        //so this will create the database table
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
            {
                char *errMsg;
                NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS CONTACTS_DATA (";
                sql_stmt = [sql_stmt stringByAppendingString:@"uniqueId INTEGER PRIMARY KEY AUTOINCREMENT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"userid TEXT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"nickname TEXT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"favamount TEXT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"phonenumber TEXT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"aadharnumber TEXT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"virtualpaymentaddress TEXT)"];
                
                
                if (sqlite3_exec(_database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    //NSLog(@"Failed to create table");
                }
                else
                {
                    //NSLog(@"Password table created successfully");
                }
                
                sqlite3_close(_database);
                
            } else {
                //NSLog(@"Failed to open/create database");
            }
        }
        
    }
    return self;
}

- (BOOL) saveContactsData : (ContactsObject *)contactsObject {
    
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        if (contactsObject.uniqueId > 0) {
            //NSLog(@"Exitsing data, Update Please");
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE CONTACTS_DATA set userid = '%@', nickname = '%@', favamount = '%@', phonenumber = '%@',aadharnumber = '%@', virtualpaymentaddress = '%@' WHERE uniqueId = ?",
                                   contactsObject.userId,
                                   contactsObject.nickName,
                                   contactsObject.favAmount,
                                   contactsObject.phoneNumber,
                                   contactsObject.aadharNumber,
                                   contactsObject.virtualPaymentAddress];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(_database, update_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, contactsObject.uniqueId);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            
            //NSLog(@"New data, Insert Please");
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CONTACTS_DATA (userid, nickname, favamount, phonenumber, aadharnumber, virtualpaymentaddress) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",contactsObject.userId,
                                   contactsObject.nickName,
                                   contactsObject.favAmount,
                                   contactsObject.phoneNumber,
                                   contactsObject.aadharNumber,
                                   contactsObject.virtualPaymentAddress];
            
            //NSLog(@"Stmt:%@", insertSQL);
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_database);
        
    }
    
    return success;
    
    
}

//get a list of all our employees
- (NSMutableArray *) getContactObjectInfos
{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        NSString *query = @"SELECT uniqueid, userid, nickname, favamount, phonenumber, aadharnumber, virtualpaymentaddress FROM contacts_data";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int uniqueId = sqlite3_column_int(statement, 0);
                char *useridChars = (char *) sqlite3_column_text(statement, 1);
                char *nicknameChars = (char *) sqlite3_column_text(statement, 2);
                char *favamountChars = (char *) sqlite3_column_text(statement, 3);
                char *phonenumberChars = (char *) sqlite3_column_text(statement, 4);
                char *aadharnumberChars = (char *) sqlite3_column_text(statement, 5);
                char *virtualpaymentaddressChars = (char *) sqlite3_column_text(statement, 6);
                
                NSString *userid = [[NSString alloc] initWithUTF8String:useridChars];
                NSString *nickname = [[NSString alloc] initWithUTF8String:nicknameChars];
                NSString *favamount = [[NSString alloc] initWithUTF8String:favamountChars];
                NSString *phonenumber = [[NSString alloc] initWithUTF8String:phonenumberChars];
                NSString *aadharnumber = [[NSString alloc] initWithUTF8String:aadharnumberChars];
                NSString *virtualpaymentaddress = [[NSString alloc] initWithUTF8String:virtualpaymentaddressChars];
                
                
                ContactsObject *info = [[ContactsObject alloc] initWithUniqueId:uniqueId userId:userid nickName:nickname favAmount:favamount phoneNumber:phonenumber aadharNumber:aadharnumber virtualPaymentAddress:virtualpaymentaddress];
                [retval addObject:info];
            }
            sqlite3_finalize(statement);
        }
    }
    
    return retval;
}

- (BOOL) deleteContactsData : (ContactsObject *)contactsObject
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        if (contactsObject.uniqueId > 0) {
            //NSLog(@"Exitsing data, Delete Please");
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from CONTACTS_DATA WHERE uniqueId = ?"];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(_database, delete_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, contactsObject.uniqueId);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            //NSLog(@"New data, Nothing to delete");
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_database);
        
    }
    
    return success;
    
}


@end
