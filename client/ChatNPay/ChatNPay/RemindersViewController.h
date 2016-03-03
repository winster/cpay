//
//  RemindersViewController.h
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *remindersArray;

@end
