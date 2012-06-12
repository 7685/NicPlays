//
//  ViewController.h
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"

@class Page1, Page2iPhone, Reachability;

@interface ViewController : UIViewController <NSStreamDelegate>{
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btnClock;
    NSTimer *timer;
    Page2iPhone *p2;
    Page1 *p1;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    int pageClicked;
    NSURLConnection *theConnection;
    NSTimer *timeoutTimer;
    Reachability *hostReach;
}

-(IBAction)goPage1:(id)sender;
-(IBAction)page2:(id)sender;
-(IBAction)setting:(UIButton *)sender;
-(void) checkNetworkCommunication :(NSString *)url :(int)port;
- (void)makeConnection:(NSString*)hostName :(int)port;
-(void) timeoutDone;
- (void) updateReachabilityStatus: (Reachability*) curReach;
@end
