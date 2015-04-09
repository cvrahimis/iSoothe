//
//  MusicViewController.h
//  Pumped
//
//  Created by Costas Simiharv on 12/8/14.
//  Copyright (c) 2014 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RatingViewController.h"
#import "MusicTableViewCell.h"
#import "MPMediaItem+Accessors.h"
#import "AppDelegate.h"
#import "Music.h"

@interface MusicViewController : UIViewController<MPMediaPickerControllerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIButton *playButton;
    UIButton *rewind;
    UIButton *fastforward;
    UIBarButtonItem *showMusic;
    UISlider *volume;
    UISlider *currentPosition;
    UIImageView *background;
    MPMusicPlayerController *musicPlayer;
    long currentTime;
    NSDate *startTime;
    NSDate *endTime;
    UIView *containerView;
    UITableView *musicTableView;
    NSArray *pickedSongs;
    NSMutableArray *savedSongs;
    NSManagedObjectContext *managedObjectContext;
}

@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIButton *rewind;
@property(nonatomic, strong) UIButton *fastforward;
@property(nonatomic, strong) UISlider *volume;
@property(nonatomic, strong) UIBarButtonItem *showMusic;
@property(nonatomic,strong) UISlider *currentPosition;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) NSNumber *duration;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UITableView *musicTableView;
@property (strong, nonatomic) NSArray *pickedSongs;
@property (strong, nonatomic) NSMutableArray *savedSongs;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)showMediaPicker:(id)sender;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (void) registerMediaPlayerNotifications;
@end
