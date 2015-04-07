//
//  ReadingViewController.h
//  BlueApp
//
//  Created by Costas Simiharv on 1/13/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Quotes.h"

@interface ReadingViewController : UIViewController
{
    int count;
    int lineCount;
    NSString *aQuote;
    long currentTime;
    Quotes *q;
    NSDate *startTime;
    NSDate *endTime;
    UIView *backTint;
}


@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) UILabel *quoteLbl;
@property (strong, nonatomic) NSArray *quotes;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) UILabel *authorLbl;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) UIView *backTint;

- (IBAction)nextBtnPress:(id)sender;

@end
