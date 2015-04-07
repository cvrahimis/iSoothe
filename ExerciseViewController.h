//
//  ExerciseViewController.h
//  iCope
//
//  Created by Costas Simiharv on 1/26/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercises.h"

/*
typedef NS_ENUM(NSInteger, BTPopUpStyle) {
    BTPopUpStyleDefault,
    BTPopUpStyleMinimalRoundedCorner
};

typedef NS_ENUM(NSInteger, BTPopUpAnimation) {
    BTPopUPAnimateWithFade,
    BTPopUPAnimateNone
};

typedef NS_ENUM(NSInteger, BTPopUpBorderStyle) {
    BTPopUpBorderStyleDefaultNone,
    BTPopUpBorderStyleLightContent,
    BTPopUpBorderStyleDarkContent
};
*/

@interface ExerciseViewController : UIViewController <UIScrollViewDelegate>{
    UIView *contentView;
    UIScrollView *scrollView;
    UIPageControl * pageControl;
    Exercises *exercises;
    UILabel *descriptions;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIView *contentView;
//@property (strong, nonatomic) BTPopUpStyle *popUpStyle;
//@property (strong, nonatomic) BTPopUpBorderStyle *popUpBorderStyle;
@property (strong, nonatomic) Exercises *exercises;
@property (strong, nonatomic) UILabel *descriptions;

-(id) initWithExercise:(Exercises*) ex;

@end
