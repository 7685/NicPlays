//
//  AppDelegate.m
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize inputStream, outputStream;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    if ([defs valueForKey:@"first_time"] == nil && ![[defs valueForKey:@"first_time"] isEqualToString:@"1"]) {
        for (int i =1; i<=16; i++) {
            NSString *v = [defs valueForKey:[NSString stringWithFormat:@"%d",i]];
            if (v == nil) {
                [defs setObject:@"10" forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        for (int i =101; i<=116; i++) {
            NSString *v = [defs valueForKey:[NSString stringWithFormat:@"%d",i]];
            if (v == nil) {
                [defs setObject:@"10" forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
        //[defs setValue:@"207.119.127.170:8088" forKey:@"url1"];
        [defs setValue:@"192.168.1.77:2101" forKey:@"url1"];
        [defs setValue:@"192.168.1.78:2101" forKey:@"url2"];
        [defs setValue:@"1" forKey:@"first_time"];
        [defs synchronize];
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
   // [self initNetworkCommunication:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) initNetworkCommunication :(NSString *)status{
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
    //    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"68.233.230.216", 51001, &readStream, &writeStream);
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"www.signalswitch.com", 8088, &readStream, &writeStream);
	inputStream = (NSInputStream *)readStream;
	outputStream = (NSOutputStream *)writeStream;
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
	[inputStream open]; 
	[outputStream open];
}

-(void) stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    static int issent = 0;
	switch (streamEvent) {
		case NSStreamEventOpenCompleted:
            NSLog(@"NSStreamEventOpenCompleted");
            
            
			break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"NSStreamEventHasSpaceAvailable");
            if (theStream == outputStream && issent <3) {
                
                if ([outputStream hasSpaceAvailable]) {
                    NSString *messageToSend=@"";
                    if (issent == 0) {
                        messageToSend = @"254";
                    }else if(issent == 1){
                     messageToSend = @"108";
                    }else{
                        messageToSend = @"1";
                    }
                    //messageToSend = @"254,108,1";
                    NSData *data = [[NSData alloc] initWithData:[messageToSend dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [outputStream write:[data bytes] maxLength:[data length]];
                    NSLog(@"DataWrote");
                    issent++;
                }else{

                }
            }
    
            break;
		case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
			if (theStream == inputStream) {
				uint8_t buffer[1024];
				int len;				
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        NSLog(@"From Server: %@", output);
					}else{

                    }
				}
            }
            break;
            
		case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
			break;
		case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [theStream release];
            CFReadStreamClose((CFReadStreamRef)inputStream);
            outputStream = nil;
            theStream = nil;
			break;
		default:
			NSLog(@"Unknown event");
	}
}
@end
