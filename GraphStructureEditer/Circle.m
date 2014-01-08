//
//  Circle.m
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import "Circle.h"

@implementation Circle
@synthesize num,frame,color;

- (id)initWithFrame:(CGRect)fr
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = fr;
        self.color = [UIColor blackColor];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        frame.origin.x = [[aDecoder decodeObjectForKey:@"x"] intValue];
        frame.origin.y = [[aDecoder decodeObjectForKey:@"y"] intValue];
        frame.size.width = [[aDecoder decodeObjectForKey:@"width"] intValue];
        frame.size.height = [[aDecoder decodeObjectForKey:@"height"] intValue];
        num = [[aDecoder decodeObjectForKey:@"num"] intValue];
        color = [aDecoder decodeObjectForKey:@"color"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInt:self.frame.origin.x] forKey:@"x"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.frame.origin.y] forKey:@"y"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.frame.size.width] forKey:@"width"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.frame.size.height] forKey:@"height"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.num] forKey:@"num"];
    [aCoder encodeObject:color forKey:@"color"];
}

@end
