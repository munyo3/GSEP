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
#import "ESBLEHIDDescriptor.h"
#import "ESBLEHIDDescriptorParser.h"
#import "ESBLEHIDDataTree.h"
#import "ESBLEHIDMouseDevice.h"


//BLEFramework
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BluetoothControllerDelegate, EditerViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, ESBLEHIDMouseDeviceDelegate>{
    
    EditerView *editerView;
    BluetoothController *bluetoothController;
    
    //BLE関連
    CBCentralManager *centralManager;
    dispatch_queue_t centralManagerSerialGCDQueue;
    NSMutableSet *peripherals;
    CBPeripheral *mousePeripheral;
    CBCharacteristic *reportMapCharacteristic;
    CBCharacteristic *HIDControlPointCharacteristic;
    CBCharacteristic *reportReadCharacteristic;
    NSArray *reportMap;
    NSMutableArray *reportDevices;
    ESBLEHIDDataTree *dataTree;
    ESBLEHIDMouseDevice *mouseDevice;
    
}

@property (strong, nonatomic) UIWindow *window;

-(void)initializeBLE;
-(void)searchDevices;

@end
