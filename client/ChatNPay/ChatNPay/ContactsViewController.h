//
//  ContactsViewController.h
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSArray *imagesArray;

@end
