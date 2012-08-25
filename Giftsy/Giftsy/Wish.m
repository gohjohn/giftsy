//
//  Wish.m
//  Giftsy
//
//  Created by Tay Wenbin on 8/25/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Wish.h"
#import "Profile.h"

@interface Wish(){
  int _wishId;
  NSString *wishName;
  NSMutableArray *collaborators;
  NSMutableArray *collaboratorIds;
  NSString *wishOwner;
  NSString *whereToGet;
  NSString *price;
  UIImage *image;
}

@property (strong, nonatomic) NSString *wishName;
@property (strong, nonatomic) NSString *wishOwner;
@property (strong, nonatomic) NSString *whereToGet;
@property (strong, nonatomic) NSString *price;

@end

@implementation Wish

- (id)initWithId:(int)wishId owner:(Profile*)owner{
    self = [super init];
    if (self) {
        _wishId = wishId;
        wishOwner = owner;
        //TODO
    }
    return self;
}



-(id) init{
    self = [super init];
    if (self) {
        NSLog(@"Please use initWithId");
    }
    return self;
}

-(int) wishId{
    return _wishId;
}
-(Profile *) wishOwner{
    return wishOwner;
}
-(NSString *) wishName{
    return wishName;
}
-(id) wishImage{
    return nil; //TODO
}
-(NSArray *) collaborators{
    if(collaborators)return collaborators;
    else{
        //TODO
        return nil;
    }
}
-(NSString *) whereToGet{
    return whereToGet;
}
-(NSString *) price{
    return price;
}

@end
