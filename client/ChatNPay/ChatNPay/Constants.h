//
//  Constants.h
//  ChatNPay
//
//  Created by venkat on 24/02/16.
//  Copyright © 2016 venkat. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#define BASE_URL    @"http://104.155.232.54"

#define TOP_MARGIN 20.0f

#define BLUE_TEXT_HIGHLIGHT_COLOR [UIColor colorWithRed:0.270588 green:0.545098 blue:1.000000 alpha:1]
#define GRAY_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1]
#define LIGHT_GRAY_TEXT_BUBBLE_COLOR [UIColor whiteColor]
#define GREEN_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.439216 green:0.854902 blue:0.223529 alpha:1]
#define LIGHT_GREEN_TEXT_BUBBLE_COLOR [UIColor colorWithHue:130.0f / 360.0f saturation:0.68f brightness:0.80f alpha:1.0f]

#define TITLEBAR_BG_COLOR   [UIColor colorWithRed:70/255.0f green:140/255.0f blue:140/255.0f alpha:1.0]


#define SOmeContent     @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. "


#define kTextByme          @"textByme"
#define kTextByOther       @"textbyother"
#define kImagebyme         @"ImageByme"
#define kImagebyOther      @"ImageByother"
#define kReceiptByMe       @"receiptByMe"
#define kReceiptByOther    @"receiptByOther"


#define ktypeImage         @"Image"
#define ktypeText          @"Text"


#define kSending            @"Sending"
#define kSent               @"Sent"
#define kFailed             @"Failed"



#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#endif /* Constants_h */
