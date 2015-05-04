//
//  AppSettingsViewController.h
//  iSoothe
//
//  Created by Brown on 4/30/15. Merge.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@import CoreBluetooth;
@import QuartzCore;

@interface AppSettingsViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    long currentTime;
    UIButton *doneBtn, *connectBtn;
    UILabel *connectLabel, *bluetoothLabel;
    CBCentralManager *centralManager;
    UIColor *redColor, *greenColor;
    NSString *connectedString;
    CABasicAnimation *fullRotation;
    UIImageView *loadingImage;
}
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIButton *connectBtn;
@property (strong, nonatomic) UILabel *connectLabel;
@property (strong, nonatomic) UILabel *bluetoothLabel;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) UIColor *redColor;
@property (strong, nonatomic) UIColor *greenColor;
@property (nonatomic, strong) CBPeripheral     *VBUTTON;
@property (strong, nonatomic) NSString *connectedString;
@property (strong, nonatomic) UIImageView *loadingImage;
@end
