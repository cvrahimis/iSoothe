//
//  HomeViewController.h
//  SwipeFunctionality
//
//  Created by Costas Simiharv on 12/31/14.
//  Copyright (c) 2014 cvrahimis. All rights reserved.
//

#import "Reachability.h"
#import <UIKit/UIKit.h>
#import "MusicViewController.h"
#import "DrawingViewController.h"
#import "JournalViewController.h"
#import "ExerciseTableViewController.h"
#import "ReadingViewController.h"
#import "RatingViewController.h"
#import "BackEndComunicator.h"

@interface HomeViewController : UIViewController{
    UILabel *home;
    UIImageView *contentImgView;
    UILabel *greetingLbl;
    NSString *name;
    NSString *morningGreeting;
    NSString *afternoonGreeting;
    NSString *eveningGreeting;
    UIButton *activityBtns[5];
    long currentTime;
    BackEndComunicator *bec;
    UIButton *ratingBtn;
}

@property (strong, nonatomic) BackEndComunicator *bec;
@property (strong, nonatomic) UILabel *greetingLbl;
@property (strong, nonatomic) UIImageView *contentImgView;
@property (strong, nonatomic) UIButton *ratingBtn;
/*@property (strong, nonatomic) UIButton *musicBtn;
 @property (strong, nonatomic) UIButton *readingBtn;
 @property (strong, nonatomic) UIButton *drawingBtn;
 @property (strong, nonatomic) UIButton *journalBtn;
 @property (strong, nonatomic) UIButton *excerciseBtn;*/

-(id) init;
-(void)activityPress:(id)sender;

@end
