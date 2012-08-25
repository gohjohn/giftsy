//
//  ConnectionController.m
//  Giftsy
//
//  Created by Tay Wenbin on 8/25/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ConnectionController.h"
#import "Profile.h"
@interface ConnectionController(){
    
}


@end

@implementation ConnectionController



- (NSData*)postToServer:(NSString *)url content:(NSData*)content{
    
    if(!url || !content) return nil;
    //url = @"http://giftsy.co/giftapi/getprofile.php"
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    //[nsstring content dataUsingEncoding:NSUTF8StringEncoding]
    [request setHTTPBody:content];
    
    
    // generates an autoreleased NSURLConnection
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //for test
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"message: '\n%@'",returnString);
    
    
    return returnData;
}


- (Profile *)getProfile:(int)userid{
    NSString *param = [NSString stringWithFormat: @"fb_id=%d",userid];
    NSData *dataToSend = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *profileData = [self postToServer:@"http://giftsy.co/giftapi/getprofile.php" content:dataToSend];
    NSString *string = [[NSString alloc] initWithData:profileData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);
    return nil;
}

static ConnectionController *sharedInstance = nil;
+ (ConnectionController *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[ConnectionController alloc] init];
    });
    
    return sharedInstance;
}



- (id)init
{
    self = [super init];
    if (self) {
        if (sharedInstance!=nil)NSLog(@"Please use sharedInstance");
        
    }
    return self;
}




-(void)connection{
    
}


@end
