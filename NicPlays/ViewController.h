//
//  ViewController.h
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
@interface ViewController : UIViewController{
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btnClock;
    NSTimer *timer;
}

-(IBAction)goPage1:(id)sender;
-(IBAction)page2:(id)sender;
-(IBAction)setting:(UIButton *)sender;
@end
