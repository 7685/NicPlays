//
//  Page2iPhone.m
//  NicPlays
//
//  Created by Vipul Patel on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Page2iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "WebCall.h"
#import "SettingViewController.h"
#import "SHKActivityIndicator.h"

@interface Page2iPhone ()

@end

@implementation Page2iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(appDidBecomeActive:) name: @"kStartTCPConnection" object: nil];
    NSArray *url = [[[NSUserDefaults standardUserDefaults] valueForKey:@"url2"] componentsSeparatedByString:@":"];
    m_NcdComponent = [[NCDComponent alloc] initWithDevice:self];
    m_NcdComponent.IPAddress = [url objectAtIndex:0]; //@"207.119.127.170";//@"192.168.1.77";
    m_NcdComponent.Port      = [[url objectAtIndex:1] intValue]; //8088;//2101;
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Re-connecting...."];
    [m_NcdComponent OpenPort];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    [btnClock setTitle:[f stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    if (m_NcdComponent && !m_NcdComponent.IsOpen) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Re-connecting...."];
        [m_NcdComponent OpenPort];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setDateTime) userInfo:nil repeats:YES];
}
-(void)setDateTime{
    if ( m_NcdComponent && !m_NcdComponent.IsOpen ) {
        [m_NcdComponent OpenPort];
    }
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    [btnClock setTitle:[f stringFromDate:[NSDate date]] forState:UIControlStateNormal];
}

-(void) viewDidDisappear:(BOOL)animated{
    [m_NcdComponent.PROXR.RelayBanks TurnOffAllRelaysInBank:0];
    [NSThread sleepForTimeInterval:0.3];
    [m_NcdComponent ClosePort];
    [timer invalidate];
    timer = nil;
}

- (void)appDidBecomeActive:(NSNotification *)notify {
    [self dismissModalViewControllerAnimated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_NcdComponent ClosePort];
    [m_NcdComponent release], m_NcdComponent = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(IBAction)buttonPressed:(UIButton *)sender{
    NSLog(@"buttonPressed");
    //lblStatus.text = [NSString stringWithFormat:@"buttonPressed of button %d",sender.tag];
    /*[sender setBackgroundColor:[UIColor grayColor]];
    sender.layer.opacity = 0.5;
    //timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(buttonContinuesPressed:) userInfo:sender repeats:YES];
    if(sender.tag > 8){
        int cmd = sender.tag + 107-8;
        WebCall *wc = [[[WebCall alloc] init] autorelease];
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,2",cmd] andUrl:[WebCall geturl2]];
    }else{
        int cmd = sender.tag + 107;
        WebCall *wc = [[[WebCall alloc] init] autorelease];
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,1",cmd] andUrl:[WebCall geturl2]];
    }
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    if(sender.tag != 11)
    {
        float secs = [[defs valueForKey:[NSString stringWithFormat:@"%d",sender.tag+100]] floatValue];
        if (secs > 0) {
            autoTimer = [NSTimer scheduledTimerWithTimeInterval:secs target:self selector:@selector(autoReleaseAction:) userInfo:sender repeats:NO];
        }
    }*/
    
    if ( m_NcdComponent == nil || !m_NcdComponent.IsOpen ) {
        [m_NcdComponent OpenPort];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Re-connecting...."];
        return ;
    }
    
    [sender setBackgroundColor:[UIColor grayColor]];
    sender.layer.opacity = 0.5;
    
    int bank = 1;
    int cmd = [sender tag] - 1;
    
    if (cmd > 7) {
        bank = 2;
        cmd -= 8;
    }
    NSLog(@"pressed :: %d -- %d", cmd, bank);
    
	//NSString* strLabel = @"?" ;
	@try{
        //UIButton *btn = (UIButton*)sender;
        //[btn setTitle:@"ON" forState:UIControlStateNormal];
        [m_NcdComponent.PROXR.RelayBanks TurnOnRelayInBank:cmd bank:bank];
		[NSThread sleepForTimeInterval:0.3];
		
		//NCD_RelayStatus rtn = [m_NcdComponent.PROXR.RelayBanks GetStatusInBank:cmd bank:bank];
		//strLabel = ( rtn == OFF ? @"OFF" : @"ON" ) ;
        
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        int secs = [[defs valueForKey:[NSString stringWithFormat:@"%d",(sender.tag + 100)]] intValue];
        if (secs > 0 && sender.tag != 11) {
            autoTimer[sender.tag] = [NSTimer scheduledTimerWithTimeInterval:secs target:self selector:@selector(autoReleaseAction:) userInfo:sender repeats:NO];
        }
        
	} @catch (NSException* err ) {
		NSLog(@"TurnOnClicked Error:%@", [err reason]);
	}

}

-(void) autoReleaseAction:(NSTimer *)t{
    UIButton *b = [t userInfo];
    [self buttonRelease:b];
}

-(IBAction)buttonRelease:(UIButton *)sender{
    NSLog(@"buttonRelease");
    //lblStatus.text = [NSString stringWithFormat:@"buttonReleased of button %d",sender.tag];
    /*[sender setBackgroundColor:[UIColor clearColor]];
    sender.layer.opacity = 1;
    if(sender.tag > 8){
        int cmd = sender.tag + 99-8;
        WebCall *wc = [[[WebCall alloc] init] autorelease];
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,2",cmd] andUrl:[WebCall geturl2]];
    }else{
        int cmd = sender.tag + 99;
        WebCall *wc = [[[WebCall alloc] init] autorelease];
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,1",cmd] andUrl:[WebCall geturl2]];
    }
    
    //[timer invalidate];
    //timer = nil;*/
    
    if ( m_NcdComponent == nil || !m_NcdComponent.IsOpen ) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Re-connecting...."];
        [m_NcdComponent OpenPort];
        return ;
    }
    
    if (autoTimer[sender.tag]) {
        [autoTimer[sender.tag] invalidate], autoTimer[sender.tag] = nil;
    }
    
    [sender setBackgroundColor:[UIColor clearColor]];
    sender.layer.opacity = 1;
    
    int bank = 1;
    int cmd = [sender tag] -1;
    if (cmd > 7) {
        bank = 2;
        cmd -= 8;
    }
    NSLog(@"release :: %d -- %d", cmd, bank);
	
	//NSString* strLabel = @"?" ;
	@try{
        //UIButton *btn = (UIButton*)sender;
        //[btn setTitle:@"OFF" forState:UIControlStateNormal];
        
		[m_NcdComponent.PROXR.RelayBanks TurnOffRelayInBank:cmd bank:bank];
		
		[NSThread sleepForTimeInterval:0.3];
		
		//NCD_RelayStatus rtn = [m_NcdComponent.PROXR.RelayBanks GetStatusInBank:cmd bank:bank];
		//strLabel = ( rtn == OFF ? @"OFF" : @"ON" ) ;
        
		
	} @catch (NSException* err ) {
		NSLog(@"TurnOffClicked Error:%@", [err reason]);
	}
    
}
-(IBAction)button11:(UIButton *)sender{
    static BOOL a = true;
    if (a) {
        [self buttonPressed:sender];
        a = false;
    }else{
        [self buttonRelease:sender];
        //[sender setBackgroundColor:[UIColor grayColor]];
        //sender.layer.opacity = 0.5;
        a= true;
    }
}

-(IBAction)button11Release:(UIButton *)sender{

    
}

-(void) appImageDidLoad:(NSString *)command{
    NSLog(@"Response: %@", command);
}
-(void)buttonContinuesPressed:(NSTimer *)t{
    UIButton *b = (UIButton *)[t userInfo];
    NSLog(@"buttonContinuesPressed-%d", b.tag);
    lblStatus.text = [NSString stringWithFormat:@"buttonContinuesPressed on button %d",b.tag];
}
-(IBAction)setting:(id)sender{
    SettingViewController *st = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self presentModalViewController:st animated:NO];
}

-(IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
}

-(void)onConnectStatusChangeEvent:(NSString*)connectionInfo {
	
	NSLog(@"connectStatusChange:%@", connectionInfo);
    [[SHKActivityIndicator currentIndicator] hide];
    //	if ( !m_NcdComponent.IsOpen ) self.switchCtrl.on = FALSE ;
}
@end
