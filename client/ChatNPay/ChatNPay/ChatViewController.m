//
//  ChatViewController.m
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#import "ChatViewController.h"
#import "TextTableViewCell.h"
#import "ReceiptTableViewCell.h"
#import "Constants.h"
#import "ParamList.h"
#import "ReceiptView.h"
#import <AFNetworking/AFHTTPSessionManager.h>

#import "NewReminderTableViewController.h"


@interface ChatViewController ()
{
    NSMutableArray *sphBubbledata;
    BOOL isfromMe;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"OBJECT:%@", [self.contactsObject valueForKey:@"nickName"]);
    
    contactsVirtualAddress = [self.contactsObject valueForKey:@"virtualPaymentAddress"];
    contactsUsername = [self.contactsObject valueForKey:@"nickName"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"usernickname"])
        userUsername = [defaults valueForKey:@"usernickname"];
    if ([defaults valueForKey:@"uservirtualaddress"])
        userVirtualAddress = [defaults valueForKey:@"uservirtualaddress"];

    
    self.navigationItem.title = contactsUsername;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Remind Me"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(createReminder)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ChatBg"]]];
    
    
    
    NSLog(@"Contacts Virtual Address : %@", contactsVirtualAddress);
    isfromMe=YES;
    sphBubbledata =[[NSMutableArray alloc]init];
    
    self.chattable.backgroundColor = [UIColor clearColor];
    
   // [self SetupDummyMessages];
    
    [self loadFromPlist];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.chattable addGestureRecognizer:tap];
    self.chattable.backgroundColor =[UIColor clearColor];
    
    
    self.messageField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.messageField.layer.cornerRadius = 4.0;
    self.messageField.layer.borderWidth= 1.0f;
    
    UILabel *poundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    poundLabel.font = [UIFont systemFontOfSize:14.0];
    poundLabel.textColor = [UIColor lightGrayColor];
    poundLabel.textAlignment = NSTextAlignmentRight;
    poundLabel.text = @"₹";
    [self.messageField setLeftView:poundLabel];
    [self.messageField setLeftViewMode:UITextFieldViewModeAlways];
    [self.messageField.leftView setHidden:YES];
    
    messageType = 1;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTapOnView:)];
    [self.messageTypeImageView addGestureRecognizer:singleFingerTap];
    
    if (sphBubbledata.count>2) {
    [self scrollTableview];
    }
    
    [self connectWebSocket];
    
    
    

    

}

-(void)createReminder {
    
    NSLog(@"Create Reminder");
    NewReminderTableViewController *newReminderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewReminderId"];
    newReminderVC.virtualAddress = contactsVirtualAddress;
    
    [self presentViewController:newReminderVC animated:YES completion:nil];
    //[self.navigationController pushViewController:newReminderVC animated:YES];
    
}




- (void)handleTapOnView:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"handleTapOnView");
    //Do stuff here...
    NSLog(@"Coming here");
    
    if (messageType == 0) {
        
        self.messageFieldConstraint.constant = 80.0;
        [self.messageTypeImageView setImage:[UIImage imageNamed:@"TypePay"]];
        self.messageField.keyboardType = UIKeyboardTypeDefault;
        [self.messageField.leftView setHidden:YES];
        
        [self.sendChatBtn setHidden:NO];
        [self.pushButton setHidden:YES];
        [self.pullButton setHidden:YES];
        
        messageType = 1;
        
      //  self.pushBtnConstraint.constant = 10.0;
        
    } else {
        
        self.messageFieldConstraint.constant = 150.0;
        [self.messageTypeImageView setImage:[UIImage imageNamed:@"TypeMessage"]];
        self.messageField.keyboardType = UIKeyboardTypeNumberPad;
        [self.messageField.leftView setHidden:NO];


        
        [self.sendChatBtn setHidden:YES];
        [self.pushButton setHidden:NO];
        [self.pullButton setHidden:NO];
        
        messageType = 0;
    //    self.pushBtnConstraint.constant = 10.0;

       // self.pushBtnConstraint.constant = -60;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return sphBubbledata.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParamList *feed_data=[[ParamList alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kReceiptByMe]||[feed_data.chat_media_type isEqualToString:kReceiptByOther])
        return 260+20;
    
    CGSize labelSize =[feed_data.chat_message boundingRectWithSize:CGSizeMake(226.0f, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                           context:nil].size;
    return labelSize.height + 30 + TOP_MARGIN+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *L_CellIdentifier = @"SPHTextBubbleCell";
    static NSString *Receipt_CellIdentifier = @"ReceiptCellIdentifier";

    
    ParamList *feed_data = [[ParamList alloc] init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kReceiptByMe]||[feed_data.chat_media_type isEqualToString:kReceiptByOther])
    {
        ReceiptTableViewCell *cell = (ReceiptTableViewCell *) [tableView dequeueReusableCellWithIdentifier:Receipt_CellIdentifier];
        if (cell == nil)
        {
            cell = [[ReceiptTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Receipt_CellIdentifier];

            
        }
        
        cell.bubbletype=([feed_data.chat_media_type isEqualToString:kReceiptByMe])?@"LEFT":@"RIGHT";
        cell.timestampLabel.text = feed_data.chat_date_time;

        cell.AvatarImageView.image=([feed_data.chat_media_type isEqualToString:kReceiptByMe])?[UIImage imageNamed:@"user"]:[UIImage imageNamed:@"user"];
        
          ReceiptView *receiptView = (ReceiptView *)cell.receiptView;
        
        if ([feed_data.chat_send_status isEqualToString:@"Initiated"])
            receiptView.statusLabel.textColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
        else if ([feed_data.chat_send_status containsString:@"Authorized"])
            receiptView.statusLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
        else if ([feed_data.chat_send_status containsString:@"Debited"])
            receiptView.statusLabel.textColor = [UIColor colorWithRed:153/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
        else if ([feed_data.chat_send_status containsString:@"Credited"])
            receiptView.statusLabel.textColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
        else if ([feed_data.chat_send_status containsString:@"Completed"])
            receiptView.statusLabel.textColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
        
        
      
        receiptView.amountLabel.text = feed_data.chat_message;
        receiptView.refIdLabel.text = feed_data.chat_messageID;
        receiptView.statusLabel.text = feed_data.chat_send_status;
        receiptView.dateLabel.text = feed_data.chat_date_time;
        
        return cell;
        
        
       
        
        
    } else {
        TextTableViewCell *cell = (TextTableViewCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil)
        {
            cell = [[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        cell.bubbletype=([feed_data.chat_media_type isEqualToString:kTextByme])?@"LEFT":@"RIGHT";
        cell.textLabel.text = feed_data.chat_message;
        cell.textLabel.tag=indexPath.row;
        cell.timestampLabel.text = feed_data.chat_date_time;
        // cell.CustomDelegate=self;
        cell.AvatarImageView.image=([feed_data.chat_media_type isEqualToString:kTextByme])?[UIImage imageNamed:@"user"]:[UIImage imageNamed:@"user"];
        return cell;
    
    }
}






/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark               KEYBOARD UPDOWN EVENT
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    

    
    
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    
    self.bottomConstraint.constant = 170;

  /*  CGRect tableviewframe=self.chattable.frame;
    tableviewframe.size.height-=210+80;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-265-80, self.view.frame.size.width, 80);
        self.bottomConstraint.constant = 200;
        self.chattable.frame=tableviewframe;
    }];
    */
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  /*  CGRect tableviewframe=self.chattable.frame;
    tableviewframe.size.height+=210;
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-50,  self.view.frame.size.width, 80);
        self.chattable.frame=tableviewframe;  }];*/
    
    
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.25];
    }
    self.bottomConstraint.constant = 0;

    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}






/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark       SEND MESSAGE PRESSED
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)sendMessageNow:(id)sender

{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    
    if ([self.messageField.text length]>0) {
        
        NSString *randomStr = [self genRandStringLength:7];

            NSString *rowNum=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
            [self adddMediaBubbledata:kTextByme mediaPath:self.messageField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:randomStr];
           // [self performSelector:@selector(messageSent:) withObject:rowNum afterDelay:5];
            
        
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:userVirtualAddress forKey:@"from"];
        
            [dict setObject:contactsVirtualAddress forKey:@"to"];
            [dict setObject:self.messageField.text forKey:@"text"];
            [dict setObject:randomStr forKey:@"txnid"];

        
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@"%@",myString);
        
       // NSLog(@"Dict:%@", [dict description]);

        [webSocket send:myString];

        [self saveTransaction:self.contactsObject.virtualPaymentAddress message:self.messageField.text messageType:kTextByme txnId:randomStr messageStatus:kSending];
        
        self.messageField.text=@"";
        [self.chattable reloadData];
        [self scrollTableview];
    }
}

- (IBAction)OnPushButtonClicked:(id)sender {
    
    payAmount = self.messageField.text;
    
    
    if ([self.messageField.text length] > 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ChatNPay" message:@"Enter MPIN" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [alertView show];
    }
    
    
 
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [alertView textFieldAtIndex:0].text);
    [self sendPushMessage];
}


-(void)sendPushMessage {
    
    
   

    
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSString *randomStr = [self genRandStringLength:7];
        NSString *rowNum=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
        [self adddMediaBubbledata:kReceiptByMe mediaPath:payAmount mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:randomStr];
        //  [self performSelector:@selector(messageSent:) withObject:rowNum afterDelay:5];
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:userVirtualAddress forKey:@"from"];
        [dict setObject:contactsVirtualAddress forKey:@"to"];
        [dict setObject:@"PAY" forKey:@"text"];
        [dict setObject:payAmount forKey:@"amount"];
        [dict setObject:randomStr forKey:@"txnid"];
        
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@"%@",myString);
        
        // NSLog(@"Dict:%@", [dict description]);
        
        [webSocket send:myString];
        
        
        //  [self connectCPay];
        
        [self saveTransaction:self.contactsObject.virtualPaymentAddress message:payAmount messageType:kReceiptByMe txnId:randomStr messageStatus:kSending];
        
        
        self.messageField.text=@"";
        [self.chattable reloadData];
        [self scrollTableview];
}




-(void)ReceiveMessageNow :(NSDictionary *)messageDict {
    
    NSString *messageStr = [messageDict objectForKey:@"text"];
    NSString *messageFrom = [messageDict objectForKey:@"from"];

    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    
    
    if([messageStr isEqualToString:@"PAY"]){
        
        
        if ([messageFrom isEqualToString:userVirtualAddress]) {
            
           // NSString *rowNum=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
            
            NSUInteger index;
            for (ParamList* dict in sphBubbledata) {
                
                if ([dict.chat_messageID isEqualToString:[messageDict objectForKey:@"txnid"]]) {
                    
                    index = [sphBubbledata indexOfObject:dict];
                    NSString *rowNum=[NSString stringWithFormat:@"%ld",index];
                    
                    [self sendStatusMessage:rowNum : [messageDict objectForKey:@"status"]];
                    [self saveTransaction:self.contactsObject.virtualPaymentAddress message:[messageDict objectForKey:@"amount"] messageType:kReceiptByMe txnId:[messageDict objectForKey:@"txnid"] messageStatus:[messageDict objectForKey:@"status"]];


                }
            }
            


            
        } else {
            
            if ([[messageDict objectForKey:@"status"] isEqualToString:@"Initiated"]) {
                
                [self adddMediaBubbledata:kReceiptByOther mediaPath:[messageDict objectForKey:@"amount"] mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:@"Initiated" msg_ID:[messageDict objectForKey:@"txnid"]];
                
                [self saveTransaction:self.contactsObject.virtualPaymentAddress message:[messageDict objectForKey:@"amount"] messageType:kReceiptByOther txnId:[messageDict objectForKey:@"txnid"] messageStatus:@"Initiated"];
                
            } else {
            
            
            
            NSUInteger index;
            for (ParamList* dict in sphBubbledata) {
                
                if ([dict.chat_messageID isEqualToString:[messageDict objectForKey:@"txnid"]]) {
                    
                    index = [sphBubbledata indexOfObject:dict];
                    NSString *rowNum=[NSString stringWithFormat:@"%ld",index];
 
                    
                    [self sendStatusMessage:rowNum : [messageDict objectForKey:@"status"]];
                    [self saveTransaction:self.contactsObject.virtualPaymentAddress message:[messageDict objectForKey:@"amount"] messageType:kReceiptByOther txnId:[messageDict objectForKey:@"txnid"] messageStatus:[messageDict objectForKey:@"status"]];
                    
                    
                }
            }
            
            }
            
            
        }
        
    } else {
        
      
        [self adddMediaBubbledata:kTextByOther mediaPath:[messageDict objectForKey:@"text"] mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:[messageDict objectForKey:@"txnid"]];
        
        [self saveTransaction:self.contactsObject.virtualPaymentAddress message:[messageDict objectForKey:@"text"] messageType:kTextByOther txnId:[messageDict objectForKey:@"txnid"] messageStatus:kSending];
        
        
    }
    
    
    [self.chattable reloadData];
    [self scrollTableview];

    
    
}


-(void)saveTransaction : (NSString *)filename message:(NSString *)message messageType:(NSString *)msgType txnId:(NSString *)txnId messageStatus:(NSString *)status{
    
    
    NSMutableDictionary *dict = [self getPlistDict:filename];
    
    
    
    NSArray *values = [dict allValues];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"txnId == %@", txnId];

    NSArray *result = [values filteredArrayUsingPredicate:filter];
    
    if (result.count == 0) {
        
        NSLog(@"Plist filename : %@", filename);
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSMutableDictionary *groupChatObject = [[NSMutableDictionary alloc] init];
        [groupChatObject setValue:msgType forKey:@"messageType"];
        [groupChatObject setValue:message forKey:@"messageText"];
        [groupChatObject setValue:[formatter stringFromDate:date] forKey:@"date"];
        [groupChatObject setValue:txnId forKey:@"txnId"];
        [groupChatObject setValue:status forKey:@"txnStatus"];
        
        
        
        [self setPlist:filename chatObject:groupChatObject];

    } else {
        
        NSLog(@"Repeated :%@", result);
        
       
        
    }

    
    
    
    
    
    
    
}

-(NSString *)getDocsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}


-(NSMutableDictionary *)getPlistDict :(NSString *)strPlistName {
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", strPlistName];
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSData *mainBundleFile = [NSData dataWithContentsOfFile:sourcePath];
    
    NSString *documentsDirectoryPath = [self getDocsDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath,fileName];
    NSLog(@"Path:%@", documentsDirectoryPath);
    
    NSMutableDictionary *tempDict;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] createFileAtPath:path
                                                contents:mainBundleFile
                                              attributes:nil];
        
        
        tempDict = [[NSMutableDictionary alloc] init];
        
    } else {
        tempDict = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    
    return tempDict;
}



-(void)setPlist:(NSString *)strPlistName chatObject:(NSMutableDictionary *)chatObject{
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", strPlistName];
    
    
    NSString *documentsDirectoryPath = [self getDocsDirectory];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath,fileName];
    NSLog(@"Path:%@", documentsDirectoryPath);

    NSMutableDictionary *tempDict =[[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    if (tempDict == nil) {
        tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:chatObject forKey:[NSString stringWithFormat:@"0"]];
    } else
        [tempDict setObject:chatObject forKey:[NSString stringWithFormat:@"%ld", tempDict.count]];
    [tempDict writeToFile:path atomically:NO];
  
    
    
    
   
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)messageSent:(NSString*)rownum
{
    int rowID=[rownum intValue];
    
    ParamList *feed_data=[[ParamList alloc]init];
    feed_data=[sphBubbledata objectAtIndex:rowID];
    
    [sphBubbledata  removeObjectAtIndex:rowID];
    feed_data.chat_send_status=kSent;
    [sphBubbledata insertObject:feed_data atIndex:rowID];
    
    // [self.chattable reloadData];
    
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.chattable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [UIView setAnimationsEnabled:animationsEnabled];
}


-(void)sendStatusMessage:(NSString*)rownum : (NSString *)status
{
    int rowID=[rownum intValue];
    
    ParamList *feed_data=[[ParamList alloc]init];
    feed_data=[sphBubbledata objectAtIndex:rowID];
    
    [sphBubbledata  removeObjectAtIndex:rowID];
    feed_data.chat_send_status=status;
    [sphBubbledata insertObject:feed_data atIndex:rowID];
    
    
    NSLog(@"...%@", sphBubbledata);
    
    // [self.chattable reloadData];
    
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.chattable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [UIView setAnimationsEnabled:animationsEnabled];
}




- (IBAction)OnPullButtonClicked:(id)sender {
    
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)scrollTableview
{
    
    NSInteger item = [self.chattable numberOfRowsInSection:0] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.chattable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    
    ParamList *feed_data=[[ParamList alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    [sphBubbledata addObject:feed_data];
}

-(void)adddReceiptBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    
    ParamList *feed_data=[[ParamList alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    [sphBubbledata addObject:feed_data];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  GENERATE RANDOM ID to SAVE IN LOCAL
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString *) genRandStringLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark       SETUP DUMMY MESSAGE / REPLACE THEM IN LIVE
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)SetupDummyMessages
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    
    //  msg_ID  Any Random ID
    
    //  mediaPath  : Your Message  or  Path of the Image
   
     [self adddReceiptBubbledata:kReceiptByMe mediaPath:@"lets meet" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:@"" msg_ID:@""];
    
    [self adddReceiptBubbledata:kReceiptByOther mediaPath:@"lets meet" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:@"" msg_ID:@""];

    
    [self adddMediaBubbledata:kTextByme mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    
    //[self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];
    
    [self adddMediaBubbledata:kTextByOther mediaPath:@"Hello! How are you?" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kTextByme mediaPath:@"I'm doing Great!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kImagebyOther mediaPath:@"Yeah its cool!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kTextByme mediaPath:@"Supports Image too." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kTextByOther mediaPath:@"Yup. I like the tail part of it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:@"ABFCXYZ"];
    
   

    
    [self adddMediaBubbledata:kImagebyOther mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    
    [self adddMediaBubbledata:kTextByme mediaPath:@"lets meet some time for dinner! hope you will like it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddReceiptBubbledata:kReceiptByMe mediaPath:@"lets meet" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:@"" msg_ID:@""];

    
    
    [self.chattable reloadData];
}

-(void)loadFromPlist {
  
    
   // NSLog(@"...%@", self.contactsObject);
    
    
    NSString *filename = [self.contactsObject valueForKey:@"virtualPaymentAddress"];
    
    NSMutableDictionary *dict = [self getPlistDict:filename];
    
    
    for (int i = 0; i < dict.count; i++) {
        
        NSString *key = [NSString stringWithFormat:@"%d", i];
        NSMutableDictionary *chatObject = [dict objectForKey:key];
        [self adddMediaBubbledata:[chatObject valueForKey:@"messageType"] mediaPath:[chatObject valueForKey:@"messageText"] mtime:[chatObject valueForKey:@"date"] thumb:@"" downloadstatus:@"" sendingStatus:@"Completed" msg_ID:[chatObject valueForKey:@"txnId"]];

    }
    
    
    
    
    NSLog(@"Data:%@", sphBubbledata);
    
}

#pragma Cpay
-(void)connectCPay {
    
    manager = [AFHTTPSessionManager manager];
    
    
    NSString *registerUrl = [NSString stringWithFormat:@"%@/pay", BASE_URL];
    
    [manager POST:registerUrl parameters:nil
         progress:nil success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

}



#pragma mark - SRWebSocket delegate

- (void)connectWebSocket {
    NSLog(@"Init Connect WebSocket");
    webSocket.delegate = nil;
    webSocket = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"ws://104.155.232.54?user=%@", userVirtualAddress];
    NSLog(@"Url:%@", urlString);
    //@"ws://104.155.232.54?user=winster";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}


- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
    //[webSocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    NSLog(@"Error:%@", error);
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSLog(@"Message:%@", message);
    
    if ([message isKindOfClass:[NSString class]]) {
        
        NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *msgDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        
        
        
        if ([[msgDict allKeys] containsObject:@"text"]) {
            [self ReceiveMessageNow:msgDict];
        }
    }
    
    
    

    
}

- (IBAction)sendMessage:(id)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"from" forKey:@"venkat"];
    [dict setObject:@"to" forKey:@"winster"];
    [dict setObject:@"text" forKey:@"hello Winster"];

    
    [webSocket send:dict];
    self.messageField.text = nil;
}


@end
