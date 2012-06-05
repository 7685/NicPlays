//
//  WebCall.h
//  NicPlays
//
//  Created by tushar on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IconDownloaderDelegate;

@interface WebCall : NSObject{
    NSMutableData *activeDownload;
    NSString *command;
    NSURLConnection *imageConnection;
    id <IconDownloaderDelegate> delegate;
}

-(void) startRelayOnUrl:(NSString *)cmd andUrl:(NSString *)url;
+(void)seturl1:(NSString *)url;
+(NSString *)geturl1;

+(void)seturl2:(NSString *)url;
+(NSString *)geturl2;

@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;
@property (nonatomic, retain) NSString *command;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSString *)command;

@end