//
//  AppDelegate.m
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsObject.h"
#import "ChatViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIMutableUserNotificationAction* declineAction = [[UIMutableUserNotificationAction alloc] init];
    [declineAction setIdentifier:@"decline_action_id"];
    [declineAction setTitle:@"Skip this Reminder"];
    [declineAction setActivationMode:UIUserNotificationActivationModeBackground];
    [declineAction setDestructive:YES];
    
    UIMutableUserNotificationAction* replyAction = [[UIMutableUserNotificationAction alloc] init];
    [replyAction setIdentifier:@"pay_action_id"];
    [replyAction setTitle:@"Open Chat Page"];
    [replyAction setActivationMode:UIUserNotificationActivationModeForeground];
    [replyAction setDestructive:NO];
    
    UIMutableUserNotificationCategory* declineReplyCategory = [[UIMutableUserNotificationCategory alloc] init];
    [declineReplyCategory setIdentifier:@"custom_category_id"];
    [declineReplyCategory setActions:@[replyAction, declineAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet* categories = [NSSet setWithArray:@[declineReplyCategory]];
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
   
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler
{
    if([notification.category isEqualToString:@"custom_category_id"])
    {
        if([identifier isEqualToString:@"decline_action_id"])
        {
            NSLog(@"Decline was pressed");
        }
        else if([identifier isEqualToString:@"pay_action_id"])
        {
            NSLog(@"Paynow was pressed");
            
        }
    }
    
    //	Important to call this when finished
    completionHandler();
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"Notification:%@", notification.userInfo);
    
    NSString *amount = [notification.userInfo objectForKey:@"amount"];
    NSString *virtualAddress = [notification.userInfo objectForKey:@"virtualAddress"];

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:amount message:virtualAddress delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
   // [alertView show];
    
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ViewController *vc = (ViewController *)appDelegate.window.rootViewController;
    ChatViewController *chatVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"ChatViewControllerId"];
    ContactsObject *contactObject = [[ContactsObject alloc] init];
    contactObject.virtualPaymentAddress = virtualAddress;
    contactObject.nickName = @"nickname";
    
    chatVC.contactsObject = contactObject;
    
    
    [vc presentViewController:chatVC animated:YES completion:nil];
    chatVC.messageField.text = amount;
    chatVC.messageField.keyboardType = UIKeyboardTypeNumberPad;
    [chatVC.pushButton setHidden:NO];
    [chatVC.sendChatBtn setHidden:YES];
    
    chatVC.messageFieldConstraint.constant = 150.0;
    [chatVC.messageTypeImageView setImage:[UIImage imageNamed:@"TypePay"]];
    chatVC.messageField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    
   

    
  //  UITabBarController *tabVC = self.window.rootViewController;

    //UINavigationController *navVC = [[tabVC viewControllers] objectAtIndex:0];

    
    //[navVC presentViewController:chatVC animated:YES completion:nil];
    
    //[vc.navigationController presentViewController:chatVC animated:YES completion:nil];


}

@end
