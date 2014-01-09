//
//  BluetoothController.h
//  GSEP
//
//  Created by n_ito on 2013/07/11.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol BluetoothControllerDelegate <NSObject>

@optional
-(void)connectedSession;
-(void)receiveData:(NSData*)data;

@end

@interface BluetoothController : NSObject<GKPeerPickerControllerDelegate, GKSessionDelegate>{
    
    NSData *receiveData;
    
    GKSession *currentSession;
    
}

@property id <BluetoothControllerDelegate> delegate;
@property (nonatomic, retain) NSData *receiveData;

-(void)connectSession;
-(void)sendData:(NSData*)data;
-(void)disconnectSession;

@end
