//
//  NewReminderTableViewController.m
//  ChatNPay
//
//  Created by venkat on 29/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "NewReminderTableViewController.h"
#import "RemindObject.h"

@interface NewReminderTableViewController ()

@end

@implementation NewReminderTableViewController

@synthesize virtualAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString *formatedDate = [dateFormatter stringFromDate:[NSDate date]];
    self.remindLabel.text =formatedDate;
    
    [self.DatePicker setHidden:YES];
    
    
    NSString *documentsDirectoryPath = [self getDocsDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath,@"reminder.plist"];
    NSLog(@"Path:%@", documentsDirectoryPath);
    
    NSMutableDictionary *tempDict =[[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    if (tempDict != nil) {
        
        NSMutableDictionary *dict = [tempDict objectForKey:virtualAddress];
        self.titleTextField.text = [dict objectForKey:@"title"];
        self.descriptionTextview.text = [dict objectForKey:@"description"];
        self.amountTextField.text = [dict objectForKey:@"amount"];
        self.remindLabel.text = [dict objectForKey:@"remind"];

    }
    
    self.descriptionTextview.layer.borderWidth = 1.0;
    self.descriptionTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.descriptionTextview.layer.cornerRadius = 4.0;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnSaveButtonClicked:(id)sender {
    
    NSString *title = self.titleTextField.text;
    NSString *description = self.descriptionTextview.text;
    NSString *amount = self.amountTextField.text;
    NSString *remind = self.remindLabel.text;
    
    
    NSMutableDictionary *remindObject = [[NSMutableDictionary alloc] init];
    [remindObject setValue:title forKey:@"title"];
    [remindObject setValue:description forKey:@"description"];
    [remindObject setValue:amount forKey:@"amount"];
    [remindObject setValue:remind forKey:@"remind"];
    [remindObject setValue:self.virtualAddress forKey:@"virtualaddress"];

    [self saveReminder :remindObject];
    
    [self scheduleNotification:remind :title :description :amount :virtualAddress];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)OnCancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(void)scheduleNotification :(NSString *)remindTime :(NSString *)remindTitle :(NSString *)remindDesc :(NSString *)amount :(NSString *)virtualaddress{
    
    [self removeNotification:remindTitle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:remindTime];
    NSLog(@"DateFromStr = %@   Remind time : %@", dateFromString, remindTime);
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dateFromString;
    localNotification.alertBody = remindTitle;
    [localNotification setCategory:@"custom_category_id"];
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setValue:amount forKey:@"amount"];
    [userDict setValue:virtualaddress forKey:@"virtualAddress"];
    [userDict setValue:remindTitle forKey:@"notificationKey"];
    
   // NSDictionary *userInfo = [NSDictionary dictionaryWithObject:remindTitle forKey:@"notificationKey"];
    localNotification.userInfo = userDict;

    localNotification.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)removeNotification :(NSString *)notificationName{
    
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        //NSLog(@"in NewBill Cancel notificationname:%@   userinfo:%@", notificationName, [userInfo objectForKey:@"notificationKey"]);
        
        if ([notificationName isEqualToString:[userInfo objectForKey:@"notificationKey"]]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
}


-(NSString *)getDocsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

-(void)saveReminder :(NSMutableDictionary *)remindObject{
    
    NSString *fileName = @"reminder.plist";
    
    
    NSString *documentsDirectoryPath = [self getDocsDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath,fileName];
    NSLog(@"Path:%@", documentsDirectoryPath);
    
    NSMutableDictionary *tempDict =[[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    if (tempDict == nil) {
        tempDict = [[NSMutableDictionary alloc] init];
    }
    [tempDict setObject:remindObject forKey:self.virtualAddress];

    [tempDict writeToFile:path atomically:NO];
}

- (IBAction)OnDatePickerValueChanged:(id)sender {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.DatePicker.date];
    self.remindLabel.text =formatedDate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"IndexPath : %@", [tableView cellForRowAtIndexPath:indexPath]);
    
  if([tableView cellForRowAtIndexPath:indexPath] == self.reminderCell){
        //NSLog(@"Due date cell clicked");
        if ([self.DatePicker isHidden])
            [self.DatePicker setHidden:NO];
        else
            [self.DatePicker setHidden:YES];
        
    }
}

@end
