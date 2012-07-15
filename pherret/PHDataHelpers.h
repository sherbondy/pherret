//
//  PHDataHelpers.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHDataHelpers : NSObject

+ (BOOL)participants:(NSArray *)participants containsUser:(NSString *)username;

@end
