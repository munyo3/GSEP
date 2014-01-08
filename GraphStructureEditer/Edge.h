//
//  Edge.h
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Circle.h"

@interface Edge : NSObject{
    
    Circle *startCircle;
    Circle *endCircle;

}

-(id)initWithCircle:(Circle *)sc endCircle:(Circle *)ec;

@property(nonatomic,retain)Circle *startCircle;
@property(nonatomic,retain)Circle *endCircle;

@end
