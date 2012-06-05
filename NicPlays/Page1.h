//
//  Page1.h
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebCall.h"
#import "Page2iPhone.h"
#import "NCDComponent.h"

@interface Page1 : UIViewController<IconDownloaderDelegate, NCD_TCPdelegate>{
    NSTimer *timer;
    IBOutlet UILabel *lblStatus;
    NSMutableArray *arrayOfCommand;
    IBOutlet UIButton *btnClock;
    NSTimer *autoTimer[17];
    NCDComponent* m_NcdComponent;
}
-(IBAction)buttonPressed:(UIButton *)sender;
-(IBAction)buttonRelease:(UIButton *)sender;
-(IBAction)setting:(id)sender;
-(IBAction)page2:(id)sender;
-(IBAction)goBack:(id)sender;
@end
