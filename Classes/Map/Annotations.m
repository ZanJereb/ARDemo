//
//  Annotations.m
//  ARDemo
//
//  Created by Zan on 7/25/16.
//  Copyright © 2016 Zan. All rights reserved.
//

#import "Annotations.h"

@implementation Annotations

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (void)dealloc
{
    self.title = nil;
    self.subtitle = nil;
}
@end