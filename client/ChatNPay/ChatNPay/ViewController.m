//
//  ViewController.m
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ViewController.h"
#import "ChatGroupsCell.h"
#import "GroupChatObject.h"
#import "ChatViewController.h"
#import "ContactsDatabase.h"
#import "ContactsObject.h"
#import "Constants.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:TITLEBAR_BG_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.contactsArray = [ContactsDatabase database].getContactObjectInfos;
    
    self.imagesArray = @[@"Image2", @"Image8", @"Image3", @"Image4", @"Image5", @"Image6", @"Image7", @"Image8", @"Image9", @"Image10", @"Image11", @"Image12", @"Image13", @"Image14"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.contactsArray = [ContactsDatabase database].getContactObjectInfos;
    
    //reload the data in the table view
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //  return self.billObjectInfos.count;
    return [self.contactsArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatGroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupChatCell"];
    
    ContactsObject *contactObject = [self.contactsArray objectAtIndex:indexPath.row];
    NSLog(@"Object:%@", contactObject);
    
   // cell.userImage.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    
    cell.userNameLabel.text = contactObject.nickName;
    
    
    cell.descriptionLabel.text = @"Start/View chats and transactions";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    cell.dateLabel.text = dateString;
    
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ChatDetailSegue"])
    {
        //if you need to pass data to the next controller do it here
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"IndexPath:%@", indexPath);
        
        ContactsObject *contactsObject = [self.contactsArray objectAtIndex:indexPath.row];
        
        ChatViewController *chatVC = segue.destinationViewController;
        chatVC.contactsObject = contactsObject;
        
    }
}





@end
