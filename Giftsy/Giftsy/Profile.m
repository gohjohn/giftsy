//
//  Profile.m
//  Giftsy
//
//  Created by Tay Wenbin on 8/25/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Profile.h"
#import "Wish.h"
@interface Profile(){
    int _userId;
    NSString *userName;
    NSMutableArray *wishes; //[Wish] **
    NSMutableArray *wishIds; //[int]
    NSMutableArray *friends; //[Profile] **
    NSMutableArray *friendIds; //[int]
    NSMutableArray *collaborations; //[Wish] **
    NSMutableArray *collaborationIds; //[wishid]
    NSString *birthday;
}
@end
@implementation Profile{
    
}

-(Profile*) initWithId:(int)userId{
    self = [super init];
    if (self) {
        _userId = userId;
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

-(int) userId{
    return _userId;
}
-(NSString*) userName{
    return userName;
}
-(NSArray*) wishes{
    if (wishes) return wishes;
    else{
        return nil; //TODO
    }
}
-(NSArray*) friends{
    if (friends) return friends;
    else{
        return nil;
        //TODO
    }
}
-(NSArray*) collaborations{
    if(collaborations) return collaborations;
    else{
        return nil;
        //TODO
    }
}


-(NSString*) birthday{
    return birthday;
}



@end
