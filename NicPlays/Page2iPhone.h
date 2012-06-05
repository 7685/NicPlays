//
//  Page2iPhone.h
//  NicPlays
//
//  Created by Vipul Patel on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebCall.h"
#import "NCDComponent.h"

@interface Page2iPhone : UIViewController<IconDownloaderDelegate, NCD_TCPdelegate>{
    NSTimer *timer;
    IBOutlet UILabel *lblStatus;
    IBOutlet UIButton *btnClock;
    NSTimer *autoTimer[17];
    NCDComponent* m_NcdComponent;
}
-(IBAction)buttonPressed:(UIButton *)sender;
-(IBAction)buttonRelease:(UIButton *)sender;
-(IBAction)goBack:(id)sender;
-(IBAction)button11:(UIButton *)sender;
-(IBAction)button11Release:(UIButton *)sender;
@end
