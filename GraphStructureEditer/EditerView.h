//
//  EditerView.h
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"
#import "Edge.h"

@protocol EditerViewDelegate <NSObject>

@required
-(void)sendData:(NSData*)data;

@end

@interface EditerView : UIView{
    
    NSMutableArray *edgeArray;
    NSMutableArray *circleArray;
    
    Circle *selectFirstCircle;
    Circle *selectSecondCircle;
    Circle *movingCircle;
    
}

@property id <EditerViewDelegate> delegate;

-(void)createCircle:(CGPoint)p;
-(void)selectCircle:(Circle*)circle;
-(void)deleteCircle:(Circle*)circle;
-(void)moveCircle:(Circle*)circle setPoint:(CGPoint)pt;
-(void)addCircle:(Circle*)circle;
-(void)createEdge:(Circle*)fCircle secondCircle:(Circle*)sCircle;
-(void)deleteEdge:(Circle*)circle;

@end
