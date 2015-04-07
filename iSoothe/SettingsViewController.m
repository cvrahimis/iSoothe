//
//  SettingsViewController.m
//  DrawPad
//
//  Created by Ray Wenderlich on 9/3/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "SettingsViewController.h"
#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height


@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize brushControl;
@synthesize opacityControl;
@synthesize brushPreview;
@synthesize opacityPreview;
@synthesize brushValueLabel;
@synthesize opacityValueLabel;
@synthesize brush;
@synthesize opacity;
@synthesize delegate;
@synthesize redControl;
@synthesize greenControl;
@synthesize blueControl;
@synthesize redLabel;
@synthesize greenLabel;
@synthesize blueLabel;
@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize brushLbl;
@synthesize opacityLbl;

-(id) init{
    if(self = [super init])
    {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"  style:UIBarButtonItemStylePlain target: self action: @selector(closeSettings:)];
        
        brushPreview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .4, frameWidth * .4)];
        brushPreview.center = CGPointMake(frameWidth / 2, frameHeight * .35);
        brushPreview.backgroundColor = [UIColor clearColor];
        [self.view addSubview: brushPreview];
        
        opacityPreview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .4, frameWidth * .4)];
        opacityPreview.center = CGPointMake(frameWidth / 2, frameHeight * .6);
        opacityPreview.backgroundColor = [UIColor clearColor];
        [self.view addSubview: opacityPreview];
        
        brushControl = [[UISlider alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .5, frameHeight * .08)];
        brushControl.center = CGPointMake(frameWidth * .55, frameHeight * .2);
        brushControl.backgroundColor = [UIColor clearColor];
        brushControl.minimumValue = 1.0f;
        brushControl.maximumValue = 100.0f;
        brushControl.value = 10.0f;
        brushControl.userInteractionEnabled = YES;
        [brushControl addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        brushControl.continuous = YES;
        [self.view addSubview:brushControl];
        
        opacityControl = [[UISlider alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .5, frameHeight * .08)];
        opacityControl.center = CGPointMake(frameWidth *.55, frameHeight * .48);
        opacityControl.backgroundColor = [UIColor clearColor];
        opacityControl.minimumValue = 0.0f;
        opacityControl.maximumValue = 1.0f;
        opacityControl.value = 1.0f;
        opacityControl.userInteractionEnabled = YES;
        [opacityControl addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        opacityControl.continuous = YES;
        [self.view addSubview:opacityControl];
        
        redControl = [[UISlider alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .5, frameHeight * .08)];
        redControl.center = CGPointMake(frameWidth * .35, frameHeight * .78);
        redControl.backgroundColor = [UIColor clearColor];
        redControl.minimumValue = 0.0f;
        redControl.maximumValue = 255.0f;
        redControl.value = 1.0f;
        redControl.userInteractionEnabled = YES;
        [redControl addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        redControl.continuous = YES;
        [self.view addSubview:redControl];
        
        greenControl = [[UISlider alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .5, frameHeight * .08)];
        greenControl.center = CGPointMake(frameWidth * .35, frameHeight * .85);
        greenControl.backgroundColor = [UIColor clearColor];
        greenControl.minimumValue = 0.0f;
        greenControl.maximumValue = 255.0f;
        greenControl.value = 1.0f;
        greenControl.userInteractionEnabled = YES;
        [greenControl addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        greenControl.continuous = YES;
        [self.view addSubview:greenControl];
        
        blueControl = [[UISlider alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .5, frameHeight * .08)];
        blueControl.center = CGPointMake(frameWidth * .35, frameHeight * .92);
        blueControl.backgroundColor = [UIColor clearColor];
        blueControl.minimumValue = 0.0f;
        blueControl.maximumValue = 255.0f;
        blueControl.value = 1.0f;
        blueControl.userInteractionEnabled = YES;
        [blueControl addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        blueControl.continuous = YES;
        [self.view addSubview:blueControl];
        
        brushValueLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        brushValueLabel.center = CGPointMake(frameWidth * .9, frameHeight * .2);
        //brushValueLabel.text = @"Title: ";
        brushValueLabel.textAlignment = NSTextAlignmentCenter;
        brushValueLabel.font = [UIFont fontWithName: @"Helvetica" size: 20];
        brushValueLabel.textColor = [UIColor blackColor];
        [self.view addSubview: brushValueLabel];
        
        opacityValueLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        opacityValueLabel.center = CGPointMake(frameWidth * .9, frameHeight * .48);
        //opacityValueLabel.text = @"Title: ";
        opacityValueLabel.textAlignment = NSTextAlignmentCenter;
        opacityValueLabel.font = [UIFont fontWithName: @"Helvetica" size: 20];
        opacityValueLabel.textColor = [UIColor blackColor];
        [self.view addSubview: opacityValueLabel];
        
        redLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        redLabel.center = CGPointMake(frameWidth * .75, frameHeight * .78);
        redLabel.textColor = [UIColor redColor];
        redLabel.textAlignment = NSTextAlignmentRight;
        redLabel.font = [UIFont fontWithName: @"Helvetica" size: 20];
        [self.view addSubview: redLabel];
        
        greenLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        greenLabel.center = CGPointMake(frameWidth * .75, frameHeight * .85);
        greenLabel.textColor = [UIColor greenColor];
        greenLabel.textAlignment = NSTextAlignmentRight;
        greenLabel.font = [UIFont fontWithName: @"Helvetica" size: 20];
        [self.view addSubview: greenLabel];
        
        blueLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        blueLabel.center = CGPointMake(frameWidth * .75, frameHeight * .92);
        blueLabel.textColor = [UIColor blueColor];
        blueLabel.textAlignment = NSTextAlignmentRight;
        blueLabel.font = [UIFont fontWithName: @"Helvetica" size: 20];
        [self.view addSubview: blueLabel];
        
        brushLbl = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        brushLbl.center = CGPointMake(frameWidth * .25, frameHeight * .2);
        brushLbl.text = @"Brush:";
        brushLbl.textAlignment = NSTextAlignmentLeft;
        brushLbl.font = [UIFont fontWithName: @"Helvetica" size: 20];
        brushLbl.textColor = [UIColor blackColor];
        [self.view addSubview: brushLbl];
        
        opacityLbl = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameHeight * .5)];
        opacityLbl.center = CGPointMake(frameWidth * .25, frameHeight * .48);
        opacityLbl.text = @"Opacity:";
        opacityLbl.textAlignment = NSTextAlignmentLeft;
        opacityLbl.font = [UIFont fontWithName: @"Helvetica" size: 20];
        opacityLbl.textColor = [UIColor blackColor];
        [self.view addSubview: opacityLbl];
        
       
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBrushControl:nil];
    [self setOpacityControl:nil];
    [self setBrushPreview:nil];
    [self setOpacityPreview:nil];
    [self setBrushValueLabel:nil];
    [self setOpacityValueLabel:nil];
    [self setRedControl:nil];
    [self setGreenControl:nil];
    [self setBlueControl:nil];
    [self setRedLabel:nil];
    [self setGreenLabel:nil];
    [self setBlueLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = @"Settings";
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // ensure the values displayed are the current values
            
    int redIntValue = self.red * 255.0;
    self.redControl.value = redIntValue;
    [self sliderChanged:self.redControl];
    
    int greenIntValue = self.green * 255.0;
    self.greenControl.value = greenIntValue;
    [self sliderChanged:self.greenControl];
    
    int blueIntValue = self.blue * 255.0;
    self.blueControl.value = blueIntValue;
    [self sliderChanged:self.blueControl];
        
    self.brushControl.value = self.brush;
    [self sliderChanged:self.brushControl];
    
    self.opacityControl.value = self.opacity;
    [self sliderChanged:self.opacityControl];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeSettings:(id)sender {
    [self.delegate closeSettings:self];
}

- (void)sliderChanged:(id)sender {
    
    UISlider * changedSlider = (UISlider*)sender;
    
    if(changedSlider == self.brushControl) {
        
        self.brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
        
    } else if(changedSlider == self.opacityControl) {
        
        self.opacity = self.opacityControl.value;
        self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
        
    } else if(changedSlider == self.redControl) {
        
        self.red = self.redControl.value/255.0;
        self.redLabel.text = [NSString stringWithFormat:@"Red: %d", (int)self.redControl.value];
        
    } else if(changedSlider == self.greenControl){
        
        self.green = self.greenControl.value/255.0;
        self.greenLabel.text = [NSString stringWithFormat:@"Green: %d", (int)self.greenControl.value];
    } else if (changedSlider == self.blueControl){
        
        self.blue = self.blueControl.value/255.0;
        self.blueLabel.text = [NSString stringWithFormat:@"Blue: %d", (int)self.blueControl.value];
        
    }
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), brushPreview.frame.size.width / 2, brushPreview.frame.size.height / 2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), brushPreview.frame.size.width / 2, brushPreview.frame.size.height / 2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),opacityPreview.frame.size.width / 2, opacityPreview.frame.size.height / 2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),opacityPreview.frame.size.width / 2, opacityPreview.frame.size.height / 2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

@end
