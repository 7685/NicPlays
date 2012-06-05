//
//  AppDelegate.h
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSStreamDelegate>{
	NSInputStream           *inputStream;
	NSOutputStream          *outputStream;
}

@property (nonatomic, retain) NSInputStream           *inputStream;
@property (nonatomic, retain) NSOutputStream          *outputStream;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
