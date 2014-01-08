//
//  AppDelegate.m
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ウィンドウ初期化
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //BLE初期設定
    [self initializeBLE];

    //マウスの検索
    [self searchDevices];
    
    //端末間通信確立
//    bluetoothController = [[BluetoothController alloc]init];
//    [bluetoothController setDelegate:self];
//    [bluetoothController connectSession];
    
    //メイン画面生成
    editerView = [[EditerView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    [editerView setDelegate:self];
    [self.window addSubview:editerView];
    [self.window bringSubviewToFront:editerView];
    
    return YES;
}


#pragma mark -Bluetooth端末間通信関連

//他端末からのデータ受信ハンドラ
-(void)receiveData:(NSData *)data
{
    NSArray *dataSet = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *key = [dataSet objectAtIndex:0];
    
    if([key isEqualToString:@"createCircle"]){
        [editerView addCircle:[dataSet objectAtIndex:1]];
    }else if([key isEqualToString:@"deleteCircle"]){
        [editerView deleteCircle:[dataSet objectAtIndex:1]];
    }else if([key isEqualToString:@"moveCircle"]){
        CGPoint pt = CGPointMake([[dataSet objectAtIndex:2] intValue], [[dataSet objectAtIndex:3] intValue]);
        [editerView moveCircle:[dataSet objectAtIndex:1] setPoint:pt];
    }else if([key isEqualToString:@"createEdge"]){
        [editerView createEdge:[dataSet objectAtIndex:1] secondCircle:[dataSet objectAtIndex:2]];
    }
}

//他端末へのデータ送信ハンドラ
-(void)sendData:(NSData *)data
{
    [bluetoothController sendData:data];
}

//他端末とのコネクション確立後
-(void)connectedSession
{
    editerView = [[EditerView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    [editerView setDelegate:self];
    [self.window addSubview:editerView];
    [self.window bringSubviewToFront:editerView];
}


#pragma mark -BLE関連

//BLEの初期化
- (void)initializeBLE
{
    centralManagerSerialGCDQueue = dispatch_queue_create("GSEP.centralmanager", DISPATCH_QUEUE_SERIAL);
    centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:centralManagerSerialGCDQueue];
    peripherals = [NSMutableSet set];   //ペリフェラルを保持するためのセット
}

//BLEデバイスの探索
-(void)searchDevices
{
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    if(centralManager.state == CBCentralManagerStatePoweredOn){
        NSLog(@"----------PowerOn----------");
        [centralManager scanForPeripheralsWithServices:nil options:options];
    }
}

//ペリフェラルの検索結果
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSLog(@"Tag:%@",localName); //検出されたタグ名を表示
    
    //検出されたタグが指定のマウスなら接続
    if([localName length] && [localName rangeOfString:@"BSMBB09DS"].location != NSNotFound){
        NSLog(@"%@と接続",localName);
        //Scanを停止
        [centralManager stopScan];
        //CBPeripheralのインスタンスを保持
        [peripherals addObject:peripheral];
        
        [centralManager connectPeripheral:peripheral options:nil];
    }
    
}

//ペリフェラルが保持するサービスの検索
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"接続完了");
    NSLog(@"サービス検索");
    peripheral.delegate = self;
    // TODO: ここに利用するサービスを記述する
    [peripheral discoverServices:nil];
}

//サービスが保持するキャラクタリスティックの検索
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"キャラクタリスティック検索");
    for(CBService *service in peripheral.services){
        NSLog(@"%@",service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//Notificationの受信要求
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"Notificationセット");
    for(CBService *service in peripheral.services){
        for(CBCharacteristic *characteristic in service.characteristics){
            NSLog(@"%@",characteristic.UUID);
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

//データの取得
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%@",characteristic.UUID);
    UInt8 batteryLevel;
    [characteristic.value getBytes:&batteryLevel length:3];
    NSLog(@"%d",batteryLevel);
}

//BLEManagerの状態変化ハンドラ
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state == CBCentralManagerStatePoweredOn){
        NSLog(@"----------PowerOn----------");
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        [centralManager scanForPeripheralsWithServices:nil options:options];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
