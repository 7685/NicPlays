//
//  WebCall.m
//  NicPlays
//
//  Created by tushar on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebCall.h"

@implementation WebCall
@synthesize command,delegate,activeDownload,imageConnection;


+(void)seturl1:(NSString *)url{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:url forKey:@"url1"];
    [def synchronize];
}

+(NSString *)geturl1{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

    if ([def valueForKey:@"url1"]) {
        return [def valueForKey:@"url1"];
    }else {
        //return @"http://signalswitch.com:8088";
        return @"192.168.1.77:2101";
    }
}

+(void)seturl2:(NSString *)url{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:url forKey:@"url2"];
    [def synchronize];
}

+(NSString *)geturl2{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if ([def valueForKey:@"url2"]) {
        return [def valueForKey:@"url2"];
    }else {
        //return @"http://signalswitch.com:8088";
        return @"192.168.1.78:2101";
    }
}

-(void) startRelayOnUrl:(NSString *)cmd andUrl:(NSString *)url{
    self.activeDownload = [NSMutableData data];
    NSLog(@"%@",[NSString stringWithFormat:
                 @"%@/cgi-bin/runcommand.sh?354:cmd=254,%@",url, cmd]);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:
                               [NSString stringWithFormat:
													@"%@/cgi-bin/runcommand.sh?354:cmd=254,%@",url, cmd]]] delegate:self];
	//NSLog(@"Start download");
    self.imageConnection = conn;
    [conn release];
}
#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    activeDownload = nil;
    
    // Release the connection now that it's finished
    imageConnection = nil;
    [delegate appImageDidLoad:@"Error"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"Got download");
	
    // Set appIcon and clear temporary data/image
    //UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
	//TN Cache an image once it get download
	
   // NSLog(@"%@", [NSString stringWithUTF8String:[self.activeDownload bytes]]);
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:[NSString stringWithUTF8String:[self.activeDownload bytes]]];
}

- (void)dealloc
{
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

@end
