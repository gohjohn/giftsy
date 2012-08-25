//
//  Wish.h
//  Giftsy
//
//  Created by Tay Wenbin on 8/25/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Profile;
@interface Wish : NSObject{
    
}


-(Wish*) initWithId:(int)wishId owner:(Profile*)owner;
-(int) wishId;
-(Profile *) wishOwner;
-(NSString *) wishName;
-(id) wishImage;//not doing yet
-(NSArray *) collaborators;
-(NSString *) whereToGet;
-(NSString *) price;
@end
