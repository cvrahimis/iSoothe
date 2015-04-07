//
//  RatingViewController.h
//  iCope
//
//  Created by Brown on 2/12/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "UIView+Toast.h"
#import "BackEndComunicator.h"
#import "Activities.h"

@interface RatingViewController : UIViewController<UINavigationControllerDelegate, UIAlertViewDelegate>{
    long currentTime;
    UIButton *emotionBtns[9];
    UIImageView *background;
    UIButton *doneBtn;
    UIButton *selectedBtn;
    UILabel *topLbl;
    UILabel *bottomLbl;
    UIButton *okBtn;
    UIButton *happyBtn;
    UIImageView *thermometer;
    UIView *mesurmentView;
    CGPoint pos;
    BOOL moodPressed;
    BOOL swiped;
    NSString* mood;
    BOOL exit;
    NSString *activity;
    NSDate *time;
    NSString *duration;
    BackEndComunicator *bec;
    int urge;
    double section;
}

@property (nonatomic) BOOL exit;
@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UILabel *topLbl;
@property (strong, nonatomic) UILabel *bottonLbl;
@property (strong, nonatomic) UIButton *okBtn;
@property (strong, nonatomic) UIButton *happyBtn;
@property (strong, nonatomic) UIImageView *thermometer;
@property (strong, nonatomic) UIView *mesurmentView;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) BackEndComunicator *bec;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) NSString *activity;


@end
