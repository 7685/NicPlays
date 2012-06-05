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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        Page1 *p = [[Page1 alloc] initWithNibName:@"Page1" bundle:nil];
        [self presentModalViewController:p animated:NO];
    }else {
        Page1 *p = [[Page1 alloc] initWithNibName:@"Page1iPhone" bundle:nil];
        [self presentModalViewController:p animated:NO];
    }
   
}
-(IBAction)page2:(id)sender{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        Page2iPhone *p2 = [[Page2iPhone alloc] initWithNibName:@"Page2" bundle:nil];
        [self presentModalViewController:p2 animated:NO];
    }else {
        Page2iPhone *p2 = [[Page2iPhone alloc] initWithNibName:@"Page2iPhone" bundle:nil];
        [self presentModalViewController:p2 animated:NO];
    }
    
    
}
-(IBAction)setting:(UIButton *)sender{
    SettingViewController *st = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    [self presentModalViewController:st animated:NO];
    
    
}
-(IBAction)closeMe:(id)sender{
    exit(0);
    
}
@end
