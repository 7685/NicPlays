//
//  ViewController.m
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Page1.h"
#import "Page2iPhone.h"
#import "SHKActivityIndicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect r = btn1.frame;
    NSLog(@"%f %f %f %f", r.origin.x,r.origin.y ,r.size.width,r.size.height);
    r = btn2.frame;
    NSLog(@"%f %f %f %f", r.origin.x,r.origin.y ,r.size.width,r.size.height);
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    [btnClock setTitle:[f stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        p1 = [[Page1 alloc] initWithNibName:@"Page1" bundle:nil];
    }
    else {
        p1 = [[Page1 alloc] initWithNibName:@"Page1iPhone" bundle:nil];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        p2 = [[Page2iPhone alloc] initWithNibName:@"Page2" bundle:nil];
    }else {
        p2 = [[Page2iPhone alloc] initWithNibName:@"Page2iPhone" bundle:nil];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated{
    CGRect r = btn1.frame;
    NSLog(@"%f %f %f %f", r.origin.x,r.origin.y ,r.size.width,r.size.height);
    r = btn2.frame;
    NSLog(@"%f %f %f %f", r.origin.x,r.origin.y ,r.size.width,r.size.height);
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        //btn1.frame = CGRectMake(62, 50, 107, 168);
        //btn2.frame = CGRectMake(150, 50, 107, 168);
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setDateTime) userInfo:nil repeats:YES];
}
-(void)setDateTime{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    [btnClock setTitle:[f stringFromDate:[NSDate date]] forState:UIControlStateNormal];
}

-(void) viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(IBAction)goPage1:(id)sender{
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        Page1 *p = [[Page1 alloc] initWithNibName:@"Page1" bundle:nil];
        [self presentModalViewController:p animated:NO];
    }else {
        Page1 *p = [[Page1 alloc] initWithNibName:@"Page1iPhone" bundle:nil];
        [self presentModalViewController:p animated:NO];
    }*/
    pageClicked = 1;
    NSArray *url = [[[NSUserDefaults standardUserDefaults] valueForKey:@"url1"] componentsSeparatedByString:@":"];
    [self checkNetworkCommunication:[url objectAtIndex:0] :[[url objectAtIndex:1] intValue]];
   //[self presentModalViewController:p1 animated:NO];
}
-(IBAction)page2:(id)sender{
/*    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        Page2iPhone *p2 = [[Page2iPhone alloc] initWithNibName:@"Page2" bundle:nil];
        [self presentModalViewController:p2 animated:NO];
    }else {
        Page2iPhone *p2 = [[Page2iPhone alloc] initWithNibName:@"Page2iPhone" bundle:nil];
        [self presentModalViewController:p2 animated:NO];
    }*/
    pageClicked = 2;
    NSArray *url = [[[NSUserDefaults standardUserDefaults] valueForKey:@"url2"] componentsSeparatedByString:@":"];
    [self checkNetworkCommunication:[url objectAtIndex:0] :[[url objectAtIndex:1] intValue]];
    
    //[self presentModalViewController:p2 animated:NO];
    
}
-(IBAction)setting:(UIButton *)sender{
    SettingViewController *st = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    [self presentModalViewController:st animated:NO];
    
    
}
-(IBAction)closeMe:(id)sender{
    exit(0);
    
}

-(void) checkNetworkCommunication :(NSString *)url :(int)port{
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Connecting...."];
    //    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"68.233.230.216", 51001, &readStream, &writeStream);
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)url, port, &readStream, &writeStream);
	_inputStream = (NSInputStream *)readStream;
	_outputStream = (NSOutputStream *)writeStream;
	[_inputStream setDelegate:self];
	[_outputStream setDelegate:self];
	[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [inputStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
	[_inputStream open]; 
	[_outputStream open];
    if (timeoutTimer) {
        [timeoutTimer invalidate], timeoutTimer = nil;
    }
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(timeoutDone) userInfo:nil repeats:YES];
}

-(void)alertConnectionFail {
    [timeoutTimer invalidate], timeoutTimer = nil;
    [_inputStream close]; [_outputStream close];
    if (readStream) CFRelease(readStream);
    if (writeStream) CFRelease(writeStream);
    [[SHKActivityIndicator currentIndicator] hide];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
    NSLog(@"Can not connect to the host!");
}

-(void) timeoutDone {
    if (timeoutTimer) {
        [self alertConnectionFail];
    }
}

-(void) stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
		case NSStreamEventOpenCompleted: {
            [[SHKActivityIndicator currentIndicator] hide];
            [_inputStream close]; [_outputStream close];
            if (readStream) CFRelease(readStream);
            if (writeStream) CFRelease(writeStream);
            if (timeoutTimer) {
                [timeoutTimer invalidate], timeoutTimer = nil;
            }
            if (pageClicked == 1) {
                [self presentModalViewController:p1 animated:NO];
            }
            else {
                [self presentModalViewController:p2 animated:NO];
            }
            NSLog(@"NSStreamEventOpenCompleted");
			break;            
        }
		case NSStreamEventErrorOccurred: {
            [self alertConnectionFail];
			break;
        }
	}
}
@end

