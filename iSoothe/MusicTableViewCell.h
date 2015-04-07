//
//  MusicTableViewCell.h
//  iCope
//
//  Created by Costas Simiharv on 4/1/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *albumCoverIV;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *artistLbl;

@end
