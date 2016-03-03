//
//  ViewController.h
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *chatsArray;
@property (nonatomic, retain) NSMutableArray *contactsArray;

@property (nonatomic, retain) NSArray *imagesArray;




@end

