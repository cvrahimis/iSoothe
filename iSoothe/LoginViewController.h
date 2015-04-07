//
//  LoginViewController.h
//  iCope
//
//  Created by Costas Simiharv on 3/4/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "BackEndComunicator.h"
#import "AppDelegate.h"
#import "RatingViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate>{
    UIImageView *background;
    int currentTime;
    UITextField *usernameTF;
    UITextField *passwordTF;
    UIButton *loginBtn;
    UIButton *cancelBtn;
    UIScrollView *scrollView;
    UITextField *activeField;
    UILabel *connectionLbl;
    Reachability *internetReach;
    UILabel *appName;
}
@property (strong, nonatomic) Reachability *internetReach;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UITextField *usernameTF;
@property (strong, nonatomic) UITextField *passwordTF;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UILabel *connectionLbl;
@property (strong, nonatomic) UILabel *appName;

@end

