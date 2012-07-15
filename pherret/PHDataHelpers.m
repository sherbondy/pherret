//
//  PHDataHelpers.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHDataHelpers.h"

@implementation PHDataHelpers

+ (BOOL)participants:(NSArray *)participants containsUser:(NSString *)username
{
    BOOL isMyHunt;
    
    for (NSDictionary *participant in participants){
        if ([[participant objectForKey:@"name"] isEqual:username]){
            isMyHunt = YES;
            break;
        }
    }
    
    return isMyHunt;
}

@end
