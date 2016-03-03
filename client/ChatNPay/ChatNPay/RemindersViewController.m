//
//  RemindersViewController.m
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "RemindersViewController.h"
#import "ReminderTableViewCell.h"
#import "Constants.h"

@interface RemindersViewController ()

@end

@implementation RemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:TITLEBAR_BG_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


    
    NSString *documentsDirectoryPath = [self getDocsDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath,@"reminder.plist"];
    NSLog(@"Path:%@", documentsDirectoryPath);
    
    NSMutableDictionary *tempDict =[[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    self.remindersArray = [tempDict allValues];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString *documentsDirectoryPath = [self getDocsDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath,@"reminder.plist"];
    NSLog(@"Path:%@", documentsDirectoryPath);
    
    NSMutableDictionary *tempDict =[[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    self.remindersArray = [tempDict allValues];
    
    //reload the data in the table view
    [_tableView reloadData];
    
}



-(NSString *)getDocsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //  return self.billObjectInfos.count;
    return [self.remindersArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ReminderTableViewCell *cell = (ReminderTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ReminderIdentifier"];
    if (cell == nil)
    {
        cell = [[ReminderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReminderIdentifier"];
    }
    
    
    
    NSMutableDictionary *reminderObject = [self.remindersArray objectAtIndex:indexPath.row];
    NSLog(@"Object:%@", reminderObject);
    
    
    
    cell.titleLabel.text = [reminderObject valueForKey:@"title"];
    cell.descriptionLabel.text = [reminderObject valueForKey:@"description"];
    cell.amountLabel.text = [reminderObject valueForKey:@"amount"];
    cell.remindOnLabel.text = [reminderObject valueForKey:@"remind"];

    
    
    return cell;
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
