//
//  SettingViewController.h
//  NicPlays
//
//  Created by Vipul Patel on 14/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *txt1;
    IBOutlet UITextField *txt2;
    UIView *contentView;
    UITextField *_passwordTextField;
}

-(IBAction) updateUrl:(id)sender;

@end
