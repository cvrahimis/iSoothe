//
//  ExerciseTableViewCell.h
//  iCope
//
//  Created by Costas Simiharv on 1/25/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *exerciseName;
@property (strong, nonatomic) IBOutlet UIImageView *exerciseImage;

@end
