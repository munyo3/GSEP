//
//  BluetoothController.m
//  GSEP
//
//  Created by n_ito on 2013/07/11.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import "BluetoothController.h"

@implementation BluetoothController
@synthesize receiveData, delegate;

-(void)connectSession{
    // ピアピッカーを作成
    GKPeerPickerController* picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    // 接続タイプはBluetoothのみ
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    // ピアピッカーを表示
    [picker show];
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    // セッションを保管
    currentSession = session;
    // デリゲートのセット
    session.delegate = self;
    // データ受信時のハンドラを設定
    [session setDataReceiveHandler:self withContext:nil];
    
    // ピアピッカーを閉じる
    picker.delegate = nil;
    [picker dismiss];
    [self.delegate connectedSession];
}

-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
    
    [self.delegate receiveData:data];
    
}

-(void)sendData:(NSData*)data{
    NSError *error = nil;
    // 接続中のすべてのピアにデータを送信
    [currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)disconnectSession{
    if (currentSession)
    {
        // PtoP接続を切断する
        [currentSession disconnectFromAllPeers];
        currentSession = nil;
    }
}

@end
