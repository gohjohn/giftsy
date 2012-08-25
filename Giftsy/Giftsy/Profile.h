//
//  Profile.h
//  Giftsy
//
//  Created by Tay Wenbin on 8/25/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

-(Profile*) initWithId:(int)userId;
-(int) userId;
-(NSString*) userName;
-(NSArray*) wishes;
-(NSArray*) friends;
-(NSArray*) collaborations;
-(NSString*) birthday;

@end
