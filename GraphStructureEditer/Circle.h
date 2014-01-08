//
//  Circle.h
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject<NSCoding>{
    
    int num;
    CGRect frame;
    UIColor *color;
    
}

-(id)initWithFrame:(CGRect)fr;

@property(nonatomic,assign)int num;
@property(nonatomic,assign)CGRect frame;
@property(nonatomic,retain)UIColor *color;


@end
