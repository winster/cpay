//
//  ContactsViewController.m
//  ChatNPay
//
//  Created by venkat on 28/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsObject.h"
#import "ContactsTableViewCell.h"
#import "ContactDetailTableViewController.h"
#import "ContactsDatabase.h"
#import "Constants.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

  //  [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:TITLEBAR_BG_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.imagesArray = @[@"Image2", @"Image8", @"Image3", @"Image4", @"Image5", @"Image6", @"Image7", @"Image8", @"Image9", @"Image10", @"Image11", @"Image12", @"Image13", @"Image14"];

    
    
 /*   for (int i = 0; i < 10; i++) {
        ContactsObject *obj = [[ContactsObject alloc] init];
        obj.userId = [NSString stringWithFormat:@"Venkat %d", i];;
        obj.nickName = [NSString stringWithFormat:@"Nickname %d", i];
        obj.favAmount = @"100";
        obj.phoneNumber = @"9663677311";
        obj.aadharNumber = @"1234432112344321";
        obj.virtualPaymentAddress = [NSString stringWithFormat:@"Address : %d", i];
        [self.contactsArray addObject:obj];
        
    }*/
    NSLog(@"Database:%@", [ContactsDatabase database]);
    
    
    self.contactsArray = [ContactsDatabase database].getContactObjectInfos;

    NSLog(@"Array:%@", self.contactsArray);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.contactsArray = [ContactsDatabase database].getContactObjectInfos;
    
    //reload the data in the table view
    [_tableView reloadData];
    
}


/*
-(void)rigthButtonClicked:(UIBarButtonItem *)button
{
    
    NSLog(@"RigthButtonClicked");
    
    UIViewController *contactDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactDetailViewControllerId"];
    
    
    [self.navigationController pushViewController:contactDetailVC animated:YES];
}*/


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
    
    
    ContactsTableViewCell *cell = (ContactsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ContactsCellIdentifier"];
    if (cell == nil)
    {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ContactsCellIdentifier"];
    }
    
    
    
    ContactsObject *contactsObject = [self.contactsArray objectAtIndex:indexPath.row];
    NSLog(@"Object:%@", contactsObject);
    
    
   // cell.userImage.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];

    cell.userNameLabel.text = contactsObject.nickName;
    cell.descriptionLabel.text = contactsObject.phoneNumber;
    
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ContactDetailSegue"])
    {
        //if you need to pass data to the next controller do it here
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"IndexPath:%@", indexPath);
        
        ContactsObject *contactsObject = [self.contactsArray objectAtIndex:indexPath.row];
        
        ContactDetailTableViewController *contactsDetailVC = segue.destinationViewController;
        contactsDetailVC.contactsObject = contactsObject;
        
      ////  ChatViewController *chatVC = segue.destinationViewController;
      //  chatVC.chatObject = chatObject;
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
