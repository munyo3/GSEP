//
//  EditerView.m
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import "EditerView.h"

@implementation EditerView

int num;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        num = 0;
        edgeArray = [NSMutableArray array];
        circleArray = [NSMutableArray array];
        selectFirstCircle = nil;
        selectSecondCircle = nil;
        movingCircle = nil;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();  //コンテキストを取得

    //線の描画
    for(Edge *edge in edgeArray){
        CGContextMoveToPoint(context, edge.startCircle.frame.origin.x+edge.startCircle.frame.size.width/2, edge.startCircle.frame.origin.y+edge.startCircle.frame.size.height/2);  //始点
        CGContextAddLineToPoint(context, edge.endCircle.frame.origin.x+edge.endCircle.frame.size.width/2, edge.endCircle.frame.origin.y+edge.endCircle.frame.size.height/2);  //終点
        CGContextStrokePath(context);  //描画
    }
    
    // 円を描画
    for(Circle *circle in circleArray){
        if(circle == selectFirstCircle) CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
        else CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextFillEllipseInRect(context, CGRectMake(circle.frame.origin.x, circle.frame.origin.y, circle.frame.size.width, circle.frame.size.height));  // 円を塗りつぶす
    }
    
}

-(void)createCircle:(CGPoint)p{
    int x = p.x;
    int y = p.y;
    
    Circle *circle = [[Circle alloc]initWithFrame:CGRectMake(x-25, y-25, 50, 50)];
    [circleArray addObject:circle];
    circle.num = num++;
    
    //データ送信
    NSArray *array = [NSArray arrayWithObjects:@"createCircle", circle, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [self.delegate sendData:data];
    
    [self setNeedsDisplay];
}

-(void)selectCircle:(Circle *)circle{
    
    if(selectFirstCircle == nil){
        selectFirstCircle = circle;
        [self setNeedsDisplay];
    }else{
        if(circle == selectFirstCircle){
            [self deleteCircle:circle];
            
            //データ送信
            NSArray *array = [NSArray arrayWithObjects:@"deleteCircle", circle, nil];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
            [self.delegate sendData:data];
            
            selectFirstCircle = nil;
        }else{
            selectSecondCircle = circle;
            [self createEdge:selectFirstCircle secondCircle:selectSecondCircle];
            
            //データ送信
            NSArray *array = [NSArray arrayWithObjects:@"createEdge", selectFirstCircle, selectSecondCircle, nil];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
            [self.delegate sendData:data];
        }
    }
    
}

-(void)deleteCircle:(Circle *)circle{
    [self deleteEdge:circle];
    
    Circle * delCircle;
    for(Circle *c in circleArray){
        if(circle.num == c.num) delCircle = c;
    }
    
    [circleArray removeObject:delCircle];
    
    [self setNeedsDisplay];
}

-(void)moveCircle:(Circle *)circle setPoint:(CGPoint)pt{
    
    Circle *selCircle;
    
    for(Circle *c in circleArray){
        if(circle.num == c.num) selCircle = c;
    }
    
    [selCircle setFrame:CGRectMake(pt.x-selCircle.frame.size.width/2, pt.y-selCircle.frame.size.height/2, selCircle.frame.size.width, selCircle.frame.size.height)];
    
    [self setNeedsDisplay];
}

-(void)addCircle:(Circle *)circle{
    [circleArray addObject:circle];
    num++;
    [self setNeedsDisplay];
}

-(void)createEdge:(Circle *)fCircle secondCircle:(Circle *)sCircle{
    
    Circle *f;
    Circle *s;
    
    for(Circle *c in circleArray){
        if(c.num == fCircle.num) f = c;
        if(c.num == sCircle.num) s = c;
    }
    
    [edgeArray addObject:[[Edge alloc]initWithCircle:f endCircle:s]];
    [self setNeedsDisplay];
}

-(void)deleteEdge:(Circle *)circle{
    NSMutableArray *deleteEdge = [NSMutableArray array];
    
    Circle *selCircle;
    
    for(Circle *c in circleArray){
        if(c.num == circle.num) selCircle = c;
    }
    
    for(Edge *edge in edgeArray){
        if(edge.startCircle.num == selCircle.num || edge.endCircle.num == selCircle.num) [deleteEdge addObject:edge];
    }
    
    for(Edge *edge in deleteEdge){
        [edgeArray removeObject:edge];
    }
}

// 画面に指を一本以上タッチしたときに実行されるメソッド
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int selectFlag = NO;
    Circle *selectedCircle;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    int px = touchPoint.x;
    int py = touchPoint.y;
    
    for(Circle *circle in circleArray){
        int cx = circle.frame.origin.x;
        int cy = circle.frame.origin.y;
        if((px >= cx && px <= cx+50) && (py >= cy && py <= cy+50)){
            selectedCircle = circle;
            selectFlag = YES;
        }
    }
    
    if(!selectFlag){
        if(selectFirstCircle == nil){
            
            [self createCircle:touchPoint];
          
        }else {
            selectFirstCircle = nil;
            [self setNeedsDisplay];
        }
    }
    else [self selectCircle:selectedCircle];
}

// 画面に触れている指が一本以上移動したときに実行されるメソッド
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    int px = touchPoint.x;
    int py = touchPoint.y;
    
    if(movingCircle == nil){
        for(Circle *circle in circleArray){
            int cx = circle.frame.origin.x;
            int cy = circle.frame.origin.y;
            if((px >= cx && px <= cx+50) && (py >= cy && py <= cy+50)){
                movingCircle = circle;
            }
        }
    }
    
    if(movingCircle != nil){
        [self moveCircle:movingCircle setPoint:touchPoint];
        
        //データ送信
        NSArray *array = [NSArray arrayWithObjects:@"moveCircle", movingCircle, [NSNumber numberWithInt:px], [NSNumber numberWithInt:py], nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [self.delegate sendData:data];
        
        [self setNeedsDisplay];
    }
}

// 指を一本以上画面から離したときに実行されるメソッド
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    movingCircle = nil;
}

@end
