//
//  SettingsViewController.h
//  DrawPad
//
//  Created by Ray Wenderlich on 9/3/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <NSObject>
- (void)closeSettings:(id)sender;
@end

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISlider *brushControl;
@property (strong, nonatomic) IBOutlet UISlider *opacityControl;
@property (strong, nonatomic) IBOutlet UIImageView *brushPreview;
@property (strong, nonatomic) IBOutlet UIImageView *opacityPreview;
@property (strong, nonatomic) IBOutlet UILabel *brushValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *opacityValueLabel;
@property (strong, nonatomic) id<SettingsViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISlider *redControl;
@property (strong, nonatomic) IBOutlet UISlider *greenControl;
@property (strong, nonatomic) IBOutlet UISlider *blueControl;
@property (strong, nonatomic) IBOutlet UILabel *redLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenLabel;
@property (strong, nonatomic) IBOutlet UILabel *blueLabel;
@property (strong, nonatomic) UILabel *brushLbl;
@property (strong, nonatomic) UILabel *opacityLbl;

@property CGFloat brush;
@property CGFloat opacity;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

- (IBAction)closeSettings:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
