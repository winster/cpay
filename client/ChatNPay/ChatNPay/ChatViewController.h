//
//  ChatViewController.h
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupChatObject.h"
#import "ContactsObject.h"
#import <SocketRocket/SRWebSocket.h>
#import <AFNetworking/AFHTTPSessionManager.h>


@interface ChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, SRWebSocketDelegate> {
    
    int messageType;
    SRWebSocket *webSocket;
    NSString *contactsVirtualAddress;
    NSString *contactsUsername;
    
    NSString *userUsername;
    NSString *userVirtualAddress;
    AFHTTPSessionManager *manager;
    NSString *payAmount;

}

@property (weak, nonatomic) IBOutlet UITableView *chattable;
@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIView *msgInPutView;
@property (weak, nonatomic) IBOutlet UIButton *sendChatBtn;

@property (strong, nonatomic) ContactsObject *contactsObject;


@property (weak, nonatomic) IBOutlet UIImageView *messageTypeImageView;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UIButton *pullButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageFieldConstraint;


- (IBAction)sendMessageNow:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
