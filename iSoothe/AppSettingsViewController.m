//
//  AppSettingsViewController.m
//  iSoothe
//
//  Created by Brown on 4/30/15. Merge. 
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//


#import "AppSettingsViewController.h"
@import CoreBluetooth;
@import QuartzCore;

#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height

#define BLE_VSN_GATT_SERVICE_UUID        @"fffffff0-00f7-4000-b000-000000000000"
#define BLE_KEYPRESS_DETECTION_UUID      @"fffffff2-00f7-4000-b000-000000000000"
#define BLE_KEYPRESS_FALLDETECT_ACK      @"fffffff3-00f7-4000-b000-000000000000"
#define BLE_FALL_KEYPRESS_DETECTION_UUID @"fffffff4-00f7-4000-b000-000000000000"
//V.ALRT 70:CB:33
@interface AppSettingsViewController ()

@end

@implementation AppSettingsViewController

@synthesize background, doneBtn, connectBtn, connectLabel, bluetoothLabel, connectedString, loadingImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentTime = [self Time];
    [self initBackground];
    [self initColors];
    [self initButtons];
    [self initStrings];
    [self initLabels];
    [self initLoadIcon: 0];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Done"
                                             style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(done)];
    //self.navigationItem.title = @"Settings";
    self.navigationController.navigationBar.translucent = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initBackground {
    if (currentTime < 12) background.image = [UIImage imageNamed:@"morning.jpg"];
    else if (currentTime > 12 && currentTime < 18) background.image = [UIImage imageNamed:@"afternoon.jpg"];
    else background.image = [UIImage imageNamed:@"evening.jpg"];
    background.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

-(void) initStrings {
    
}

-(void) initColors {
    greenColor = [UIColor colorWithRed:.75 green:1 blue:.75 alpha:.5];
    redColor = [UIColor colorWithRed:1 green:.5 blue:.5 alpha:.5];
}

-(void) initLabels {
    // Log label
    
    connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frameWidth * .9, frameHeight * .2)];
    connectLabel.center = CGPointMake(frameWidth/2, frameHeight*.7);
    connectLabel.text = @"";
    connectLabel.font = [UIFont fontWithName: @"ChalkboardSE-Regular" size: 20];
    //connectLabel.backgroundColor = [UIColor whiteColor];
    connectLabel.numberOfLines = 0;
    //connectLabel.adjustsFontSizeToFitWidth = YES;
    connectLabel.textColor = [UIColor whiteColor];
    connectLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:connectLabel];
    
    bluetoothLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frameWidth/2, frameHeight * .05)];
    bluetoothLabel.center = CGPointMake(frameWidth/2, frameHeight*.05);
    bluetoothLabel.text = @"Bluetooth Button";
    bluetoothLabel.font = [UIFont fontWithName: @"ChalkboardSE-Regular" size: 30];
    bluetoothLabel.textColor = [UIColor whiteColor];
    bluetoothLabel.adjustsFontSizeToFitWidth = YES;
    bluetoothLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bluetoothLabel];
    
}

-(void) initButtons{
    doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, frameWidth * .3, frameHeight * .08)];
    doneBtn.center = CGPointMake(frameWidth - (frameWidth*.2), frameHeight * .85);
    doneBtn.backgroundColor = greenColor;
    doneBtn.layer.cornerRadius = 10;
    doneBtn.layer.borderWidth=1.0f;
    doneBtn.layer.borderColor=[[UIColor colorWithRed:.7 green:.9 blue:1 alpha:1] CGColor];
    doneBtn.tag = 0;
    doneBtn.showsTouchWhenHighlighted = YES;
    [doneBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize: 18]];
    [doneBtn setTitle: @"Done" forState: UIControlStateNormal];
    doneBtn.userInteractionEnabled = YES;
    [doneBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [self.view bringSubviewToFront:doneBtn];
    
    
    connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, frameWidth * .2, frameWidth * .1)];
    connectBtn.center = CGPointMake(frameWidth*.15, frameHeight*.15);
    connectBtn.backgroundColor = [UIColor colorWithRed:.75 green:1 blue:.75 alpha:.5];
    connectBtn.layer.cornerRadius = 10;
    connectBtn.layer.borderWidth=1.0f;
    connectBtn.layer.borderColor=[[UIColor colorWithRed:.7 green:.9 blue:1 alpha:1] CGColor];
    connectBtn.tag = 1;
    connectBtn.showsTouchWhenHighlighted = YES;
    [connectBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [connectBtn.titleLabel setFont:[UIFont systemFontOfSize: 18]];
    [connectBtn setTitle: @"Connect" forState: UIControlStateNormal];
    connectBtn.userInteractionEnabled = YES;
    [connectBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    [self.view bringSubviewToFront:connectBtn];
}

-(void) initLoadIcon:(int)value {
    if(value == 0) {
        loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth*.1, frameWidth*.1)];
        loadingImage.center = CGPointMake(frameWidth/2, frameHeight*.8);
        loadingImage.image = [UIImage imageNamed:@"loadingIcon"];
    }
    else if(value == 1) {
        [self.view addSubview:loadingImage];
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.delegate = self;
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
        fullRotation.duration = 2;
        fullRotation.repeatCount = INFINITY;
        [loadingImage.layer addAnimation:fullRotation forKey:@"360"];
        connectBtn.backgroundColor = redColor;
    }
    
    else {
        [self.loadingImage setHidden:YES];
        [UIView animateWithDuration:0.25 animations:^{
            connectBtn.backgroundColor = greenColor;
        } completion:NULL];
    }
    
}

-(long) Time {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *timeOfDayInHoursString = [dateFormatter stringFromDate:date];
    long timeOfDayInHours = [timeOfDayInHoursString integerValue];
    return timeOfDayInHours;
}

- (void)btnPress:(id)sender {
    switch (((UIButton*)sender).tag) {
        case 0:
        {
            [self initLoadIcon:2];
            NSLog(@"%s -Settings Pressed-", __PRETTY_FUNCTION__);
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            HomeViewController *hvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hvc];
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
        }
        case 1:
        {
            NSLog(@"%s -Connect Pressed-", __PRETTY_FUNCTION__);
            centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
            NSArray *services = @[[CBUUID UUIDWithString:BLE_VSN_GATT_SERVICE_UUID]]; // set gatt service
            [centralManager scanForPeripheralsWithServices:nil options:nil];
        }
            
        default:
            break;
    }
}

-(void) done{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    HomeViewController *hvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hvc];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

-(void) screenLog:(NSString *) nextLog {
    connectLabel.text = [@"- " stringByAppendingString:nextLog];
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connectedString = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    [self screenLog:self.connectedString];
    NSLog(@"%@", self.connectedString);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSString *log = [NSString stringWithFormat:@"BUTTON LOCATED: %@ RSSI: %@", localName, RSSI];
        [self screenLog: log];
        NSLog(@"BUTTON LOCATED: %@ RSSI: %@", localName, RSSI);
        [self.centralManager stopScan];
        self.VBUTTON = peripheral;
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
        [self initLoadIcon:2];
    }
}


// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        [self screenLog: @"Please Turn on Bluetooth On."];
        NSLog(@"Please Turn on Bluetooth On.");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        [self screenLog: @"Bluetooth is on. Waiting to connect."];
        NSLog(@"Bluetooth is on. Waiting to connect.    ");
        [self initLoadIcon: 1];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        [self screenLog: @"CoreBluetooth BLE state is unauthorized"];
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        [self screenLog: @"CoreBluetooth BLE state is unknown"];
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        [self screenLog: @"CoreBluetooth BLE hardware is unsupported on this platform"];
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSString *log = [NSString stringWithFormat:@"Discovered service: %@", service.UUID];
        [self screenLog: log];
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self screenLog: @"received characteristic value!"];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
