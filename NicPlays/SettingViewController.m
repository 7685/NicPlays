//
//  SettingViewController.m
//  NicPlays
//
//  Created by Vipul Patel on 14/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "WebCall.h"
#define PASSWORD @"123456"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    txt1.text = [WebCall geturl1];
    txt2.text = [WebCall geturl2];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    for (int i =1; i<=16; i++) {
        NSString *v = [defs valueForKey:[NSString stringWithFormat:@"%d",i]];
        if (v) {
            UITextField *txt = (UITextField *) [self.view viewWithTag:i];
            txt.text = v;
        }
    }
    for (int i =101; i<=116; i++) {
        NSString *v = [defs valueForKey:[NSString stringWithFormat:@"%d",i]];
        if (v) {
            UITextField *txt = (UITextField *) [self.view viewWithTag:i];
            txt.text = v;
        }
    }
    
    contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    contentView.backgroundColor = [UIColor whiteColor];
    /*    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     actionButton.frame = CGRectMake(10, 200, 300, 44);
     [actionButton setTitle:@"Submit" forState:UIControlStateNormal];
     [actionButton addTarget:self action:@selector(checkPassword) forControlEvents:UIControlEventTouchUpInside];
     [contentView addSubview:actionButton];*/
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
	_passwordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_passwordTextField.secureTextEntry = YES;
	_passwordTextField.placeholder = @"enter password to unlock";
	_passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	_passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
	_passwordTextField.font = [UIFont boldSystemFontOfSize:15.0];
	_passwordTextField.minimumFontSize = 12;
	_passwordTextField.adjustsFontSizeToFitWidth = YES;
	_passwordTextField.backgroundColor = [UIColor clearColor];
	_passwordTextField.returnKeyType = UIReturnKeyDone;
	_passwordTextField.delegate = self;
	_passwordTextField.keyboardType = UIKeyboardTypeDefault;	
	_passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_passwordTextField.text = @"";

    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(10, 150, 300, 44);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(10, 200, 300, 44);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:_passwordTextField];
    [contentView addSubview:submitButton];
    [contentView addSubview:cancelButton];    
    
   [self.view addSubview:contentView];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (int i =1; i<=16; i++) {
        UITextField *txt = (UITextField *)[self.view viewWithTag:i];
        [txt resignFirstResponder];
    }
    
    for (int i =101; i<=116; i++) {
        UITextField *txt = (UITextField *)[self.view viewWithTag:i];
        [txt resignFirstResponder];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(self.view.frame.origin.y < 0){
            [UIView beginAnimations:@"anim" context:nil];
            self.view.frame = CGRectOffset(self.view.frame, 0, 150);
            [UIView commitAnimations];
        }    
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (textField.tag > 100) {
            if(self.view.frame.origin.y >= 0){
                 [UIView beginAnimations:@"anim" context:nil];
                self.view.frame = CGRectOffset(self.view.frame, 0, -150);
                [UIView commitAnimations];
            }
        }
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == _passwordTextField) {
        [self submitButtonClicked];
    }
    [textField resignFirstResponder];
    return true;
}

-(IBAction) updateUrl:(id)sender{
    if ([txt1.text isEqualToString:@""] || txt1.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing" message:@"Please enter url 1..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if ([txt2.text isEqualToString:@""] || txt2.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing" message:@"Please enter url 2..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    [WebCall seturl1:txt1.text];
    [WebCall seturl2:txt2.text];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    for (int i =1; i<=16; i++) {
        UITextField *txt = (UITextField *)[self.view viewWithTag:i];
        if ([txt.text isEqualToString:@""] || txt.text == nil) {
            
        }else {
            [defs setObject:txt.text forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    for (int i =101; i<=116; i++) {
        UITextField *txt = (UITextField *)[self.view viewWithTag:i];
        if ([txt.text isEqualToString:@""] || txt.text == nil) {
            
        }else {
            [defs setObject:txt.text forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    [defs synchronize];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)dealloc {
    [_passwordTextField release], _passwordTextField = nil;
    [contentView release], contentView = nil;
    [super dealloc];
}

#pragma Custom methods
- (void)submitButtonClicked {
    if ([_passwordTextField.text isEqualToString:PASSWORD]) {
        [_passwordTextField resignFirstResponder];
        [contentView removeFromSuperview];
    }
    else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
		[alert show];
    }
}

- (void)cancelButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

@end
