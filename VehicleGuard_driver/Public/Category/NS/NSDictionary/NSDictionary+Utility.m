//
//  NSDictionary+Utility.m
//  MyDemo
//
//  Created by LOLITA on 16/11/9.
//  Copyright © 2016年 LOLITA. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

-(id)objectForKeyNotNull:(id)key{
    
    id object = [self objectForKey:key];
    
    if (([object isKindOfClass:[NSNull class]] || object == nil || ( [object isKindOfClass:[NSString class]] &&([object isEqualToString:@"<null>"]||[object isEqualToString:@"(null)"])))) {
        return nil;
    }
    
    return object;
}

@end
