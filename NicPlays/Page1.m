//
//  Page1.m
//  NicPlays
//
//  Created by Vipul Patel on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Page1.h"
#import "WebCall.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"

@interface Page1 ()

@end

@implementation Page1

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
    NSArray *url = [[[NSUserDefaults standardUserDefaults] valueForKey:@"url1"] componentsSeparatedByString:@":"];
    m_NcdComponent = [[NCDComponent alloc] initWithDevice:self];
    m_NcdComponent.IPAddress = [url objectAtIndex:0]; //@"207.119.127.170";//@"192.168.1.77";
    m_NcdComponent.Port      = [[url objectAtIndex:1] intValue]; //8088;//2101;
    [m_NcdComponent OpenPort];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    [btnClock setTitle:[f stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    if (m_NcdComponent) {
        [m_NcdComponent OpenPort];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setDateTime) userInfo:nil repeats:YES];
}
-(void)setDateTime{
    if ( m_NcdComponent == nil || !m_NcdComponent.IsOpen ) {
        [m_NcdComponent OpenPort];
    }
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    [btnClock setTitle:[f stringFromDate:[NSDate date]] forState:UIControlStateNormal];
}
-(void) viewDidDisappear:(BOOL)animated{
    [m_NcdComponent ClosePort];
    [timer invalidate];
    timer = nil;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [m_NcdComponent ClosePort];
    [m_NcdComponent release], m_NcdComponent = nil;
    [super dealloc];
}

-(IBAction)buttonPressed:(UIButton *)sender{
    NSLog(@"buttonPressed");
    //lblStatus.text = [NSString stringWithFormat:@"buttonPressed of button %d",sender.tag];
    /*[sender setBackgroundColor:[UIColor grayColor]];
    sender.layer.opacity = 0.5;
    //timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(buttonContinuesPressed:) userInfo:sender repeats:YES];

    if(sender.tag > 8){
        int cmd = sender.tag + 107-8;
        WebCall *wc = [[WebCall alloc] init] ;
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,2",cmd] andUrl:[WebCall geturl1]];
        [wc release];
    }else{
        int cmd = sender.tag + 107;
        WebCall *wc = [[WebCall alloc] init] ;
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,1",cmd] andUrl:[WebCall geturl1]];
        [wc release];
    }
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    float secs = [[defs valueForKey:[NSString stringWithFormat:@"%d",sender.tag]] floatValue];
    if (secs > 0) {
        autoTimer = [NSTimer scheduledTimerWithTimeInterval:secs target:self selector:@selector(autoReleaseAction:) userInfo:sender repeats:NO];
    }*/
    if ( m_NcdComponent == nil || !m_NcdComponent.IsOpen ) {
        [m_NcdComponent OpenPort];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Re-connecting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
        [alert show];
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
        int secs = [[defs valueForKey:[NSString stringWithFormat:@"%d",sender.tag]] intValue];
        NSLog(@"secs :: %d", secs);
        if (secs > 0) {
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
        WebCall *wc = [[WebCall alloc] init] ;
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,2",cmd] andUrl:[WebCall geturl1]];
        [wc release];
    }else{
        int cmd = sender.tag + 99;
        WebCall *wc = [[WebCall alloc] init] ;
        wc.delegate = self;
        [wc startRelayOnUrl:[NSString stringWithFormat:@"%d,1",cmd] andUrl:[WebCall geturl1]];
        [wc release];
    }
    
    //[timer invalidate];
    //timer = nil;*/
    
    if ( m_NcdComponent == nil || !m_NcdComponent.IsOpen ) {
        [m_NcdComponent OpenPort];
        return ;
    }
    if (autoTimer[sender.tag]) {
        NSLog(@"%d tag timer release", sender.tag);
        [autoTimer[sender.tag] invalidate], autoTimer[sender.tag] = nil;
    }
    [sender setBackgroundColor:[UIColor clearColor]];
    sender.layer.opacity = 1;
    int bank = 1;
    int cmd = [sender tag] - 1;
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
		NSLog(@"elease called");
		[NSThread sleepForTimeInterval:0.3];
		
		//NCD_RelayStatus rtn = [m_NcdComponent.PROXR.RelayBanks GetStatusInBank:cmd bank:bank];
		//strLabel = ( rtn == OFF ? @"OFF" : @"ON" ) ;
        
		
	} @catch (NSException* err ) {
		NSLog(@"TurnOffClicked Error:%@", [err reason]);
	}

}

-(void) appImageDidLoad:(NSString *)command{
    NSLog(@"Response: %@", command);
}

-(void)buttonContinuesPressed:(NSTimer *)t{
    UIButton *b = (UIButton *)[t userInfo];
    NSLog(@"buttonContinuesPressed-%d", b.tag);
    lblStatus.text = [NSString stringWithFormat:@"buttonContinuesPressed on button %d",b.tag];
}


-(IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
}

-(void)onConnectStatusChangeEvent:(NSString*)connectionInfo {
	
	NSLog(@"connectStatusChange:%@", connectionInfo);
    if ( !m_NcdComponent.IsOpen ) {
        NSLog(@"connection closed");
    }
    else {
        NSLog(@"connection open");
    }
//	if ( !m_NcdComponent.IsOpen ) self.switchCtrl.on = FALSE ;
}
@end
