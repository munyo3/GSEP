//
//  AppDelegate.h
//  GraphStructureEditer
//
//  Created by n_ito on 2013/07/18.
//  Copyright (c) 2013年 n_ito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothController.h"
#import "EditerView.h"
#import "Circle.h"


//BLEFramework
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BluetoothControllerDelegate, EditerViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>{
    
    EditerView *editerView;
    BluetoothController *bluetoothController;
    
    //BLE関連
    CBCentralManager *centralManager;
    dispatch_queue_t centralManagerSerialGCDQueue;
    NSMutableSet *peripherals;
}

@property (strong, nonatomic) UIWindow *window;

-(void)initializeBLE;
-(void)searchDevices;

@end
