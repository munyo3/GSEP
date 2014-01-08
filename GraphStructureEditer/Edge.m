//
//  Edge.m
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import "Edge.h"

@implementation Edge
@synthesize startCircle,endCircle;

-(id)initWithCircle:(Circle *)sc endCircle:(Circle *)ec{
    
    self = [super init];
    if(self){
        self.startCircle = sc;
        self.endCircle = ec;
    }
    
    return self;
}

@end
