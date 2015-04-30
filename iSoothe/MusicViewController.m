//
//  MusicViewController.m
//  Pumped
//
//  Created by Costas Simiharv on 12/8/14.
//  Copyright (c) 2014 cvrahimis. All rights reserved.
//

#import "MusicViewController.h"
#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height

@implementation MusicViewController

@synthesize playButton, rewind, fastforward, volume, currentPosition, background, musicPlayer, startTime, endTime, showMusic;
@synthesize containerView, musicTableView, pickedSongs, savedSongs, managedObjectContext;

-(id)init{
    if(self = [super init])
    {
        currentTime = [self Time];
        [self initBackground];
        
        startTime = [NSDate date];
        
        musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        
        playButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameWidth * .4)];
        playButton.center = CGPointMake(frameWidth / 2, frameHeight * .9);
        [playButton setImage: [UIImage imageNamed: @"play.png"] forState: UIControlStateNormal];
        playButton.enabled = NO;
        [playButton addTarget: self action:@selector(playPause:) forControlEvents: UIControlEventTouchDown];
        [self.view addSubview: playButton];
        
        fastforward = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameWidth * .4)];
        fastforward.center = CGPointMake(frameWidth * .8, frameHeight * .9);
        [fastforward setImage: [UIImage imageNamed: @"fastforward.png"] forState: UIControlStateNormal];
        fastforward.enabled = NO;
        [fastforward addTarget: self action:@selector(nextSong:) forControlEvents: UIControlEventTouchDown];
        [self.view addSubview: fastforward];
        
        rewind = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .4, frameWidth * .4)];
        rewind.center = CGPointMake(frameWidth * .2, frameHeight * .9);
        [rewind setImage: [UIImage imageNamed: @"rewind.png"] forState: UIControlStateNormal];
        rewind.enabled = NO;
        [rewind addTarget: self action:@selector(previousSong:) forControlEvents: UIControlEventTouchDown];
        [self.view addSubview: rewind];
        
        volume = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .7, 30)];
        volume.center = CGPointMake(frameWidth / 2, frameHeight * .75);
        volume.backgroundColor = [UIColor clearColor];
        volume.minimumValue = 0.0f;
        volume.maximumValue = 1.0f;
        volume.continuous = YES;
        volume.value = 0.5f;
        [volume addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: volume];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .9, frameHeight * .5)];
        containerView.center = CGPointMake(frameWidth / 2, frameHeight * .4);
        
        musicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .9, frameHeight * .5)];
        musicTableView.dataSource = self;
        [containerView addSubview: musicTableView];
        [self.view addSubview:containerView];
        
        pickedSongs = [[NSArray alloc] init];
        savedSongs = [[NSMutableArray alloc] init];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"Done"
                                                 style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(done)];
        
        UIImage *addBkg = [UIImage imageNamed:@"doubleMusicNote.png"];
        addBkg = [self imageWithImage:addBkg scaledToSize: CGSizeMake(addBkg.size.width / 20, addBkg.size.height / 20)];
        showMusic = [[UIBarButtonItem alloc] initWithImage:addBkg style:UIBarButtonItemStylePlain target:self action:@selector(showMediaPicker:)];
                     //initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMediaPicker:)];
        
        //UIImage *addBkg = [UIImage imageNamed:@"doubleMusicNote.png"];
        //addBkg = [self imageWithImage:addBkg scaledToSize: CGSizeMake(frameWidth * .01, frameHeight * .03)];
        //addBkg = [addBkg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //[showMusic setBackgroundImage:addBkg forState:UIControlStateNormal barMetrics:0];
        self.navigationItem.rightBarButtonItem = showMusic;
        
        AppDelegate* appDelegate = [AppDelegate sharedAppdelegate];
        managedObjectContext = appDelegate.managedObjectContext;
        
        NSFetchRequest * allSongs = [[NSFetchRequest alloc] init];
        [allSongs setEntity:[NSEntityDescription entityForName:@"Music" inManagedObjectContext:managedObjectContext]];
        [allSongs setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:allSongs error:&error];
        if ([results count] > 0) {
        
            for(int i = 0; i < [results count]; i++)
            {
                Music *music = results[i];
                /*MPMediaPropertyPredicate *durationPredicate = nil;
                if (![[music valueForKey:@"artist"] isEqualToString:@""])
                    durationPredicate = [MPMediaPropertyPredicate predicateWithValue:[music valueForKey:@"duration"]
                                                                       forProperty:MPMediaItemPropertyPlaybackDuration
                                                                    comparisonType:MPMediaPredicateComparisonContains];
                */
            
                MPMediaPropertyPredicate *titlePredicate =
                [MPMediaPropertyPredicate predicateWithValue:[music valueForKey:@"title"]
                                                 forProperty:MPMediaItemPropertyTitle
                                              comparisonType:MPMediaPredicateComparisonEqualTo];
                
                MPMediaQuery *songsQuery = [[MPMediaQuery alloc] init];
                //if (![[music valueForKey:@"artist"] isEqualToString:@""])
                    //[songsQuery addFilterPredicate:durationPredicate];
                [songsQuery addFilterPredicate:titlePredicate];
            
                NSArray *songs = [songsQuery items];
                for(MPMediaItem *song in songs)
                {
                    if ([song.itemPlaybackDuration intValue] == [[music valueForKey:@"duration"] intValue] && ((!song.itemArtist && [[music valueForKey:@"artist"] isEqualToString:@"(null)"]) || [song.itemArtist isEqualToString:[music valueForKey:@"artist"]]))
                    {
                        [savedSongs insertObject:song atIndex:[savedSongs count]];
                    }
                }
            }
        
            MPMediaItemCollection *mediaCollection = [[MPMediaItemCollection alloc] initWithItems:[NSArray arrayWithArray:savedSongs]];
            [musicPlayer setQueueWithItemCollection:mediaCollection];
        }
        musicTableView.delegate = self;
        musicTableView.dataSource = self;
        [self.musicTableView reloadData];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [volume setValue:[musicPlayer volume]];
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        
        [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
    } else {
        
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    [self registerMediaPlayerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Music";
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        [musicPlayer stop];
    }
}

-(void) done{
    if([musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to keep playing music?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    
    endTime = [NSDate date];
    NSTimeInterval timeDifference = [endTime timeIntervalSinceDate:startTime];
    NSInteger seconds = timeDifference;
    NSInteger hours = seconds / 3600;
    seconds = seconds - (hours * 3600);
    NSInteger minuets = seconds / 60;
    seconds = seconds - (minuets * 60);
    
    
    RatingViewController *rvc = [[RatingViewController alloc]init];
    rvc.duration = [[[[[[NSString stringWithFormat:@"%li", (long)hours] stringByAppendingString:@" hours "] stringByAppendingString:[NSString stringWithFormat:@"%li", (long)minuets]] stringByAppendingString:@" minuets " ] stringByAppendingString:[NSString stringWithFormat:@"%li", (long)seconds]] stringByAppendingString:@" seconds"];
    rvc.time = startTime;
    rvc.activity = @"Music";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    //now present this navigation controller modally
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}


/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }*/

- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}


- (void) handle_NowPlayingItemChanged: (id) notification //displays song info title atrtist album
{
   	/*MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"musicNote.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }*/
    
    //[albumCover setImage:artworkImage];
    
    /*NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString)
    {
        songTitle.text = [NSString stringWithFormat:@"Title: %@",titleString];
    }
    else
    {
        songTitle.text = @"Title: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString)
    {
        artist.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    }
    else
    {
        artist.text = @"Artist: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString)
    {
        album.text = [NSString stringWithFormat:@"Album: %@",albumString];
    }
    else
    {
        album.text = @"Album: Unknown album";
    }*/
    
}


- (void) handle_PlaybackStateChanged: (id) notification //Change the play button icon if paused stopped or played
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused)
    {
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    else if (playbackState == MPMusicPlaybackStatePlaying)
    {
        [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else if (playbackState == MPMusicPlaybackStateStopped)
    {
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
    }
    
}

- (void) handle_VolumeChanged: (id) notification //change the slider if volume changes
{
    [volume setValue:[musicPlayer volume]];
}

#pragma mark - Media Picker

- (IBAction)showMediaPicker:(id)sender //show music library
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    self.musicTableView.delegate = self;
    [self presentViewController:mediaPicker animated:YES completion:nil];
    mediaPicker = nil;
}

//Make a playlist of songs selected and come back to app
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection)
    {
        [savedSongs removeAllObjects];
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        pickedSongs = mediaItemCollection.items;
        savedSongs = [NSMutableArray arrayWithArray: pickedSongs];
        
        NSFetchRequest * allSongs = [[NSFetchRequest alloc] init];
        [allSongs setEntity:[NSEntityDescription entityForName:@"Music" inManagedObjectContext:managedObjectContext]];
        [allSongs setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * dbSongs = [managedObjectContext executeFetchRequest:allSongs error:&error];
        allSongs = nil;
        //error handling goes here
        for (NSManagedObject * song in dbSongs) {
            [managedObjectContext deleteObject:song];
        }
        error = nil;
        [managedObjectContext save:&error];
        for(int i = 0; i < [pickedSongs count]; i++)
        {
            MPMediaItem *item = pickedSongs[i];
            Music *music = [NSEntityDescription insertNewObjectForEntityForName: @"Music" inManagedObjectContext: managedObjectContext];
            NSString *title = [NSString stringWithFormat:@"%@", item.itemTitle];
            NSString *artist = [NSString stringWithFormat:@"%@", item.itemArtist];
            NSNumber *duration = item.itemPlaybackDuration;
            
            [music setValue:title forKey:@"title"];
            [music setValue:artist forKey:@"artist"];
            [music setValue:duration forKey:@"duration"];
            error = nil;
            if([managedObjectContext save: &error])
            {
                NSLog(@"Successsfully added song TITLE: %@ ARTIST: %@ DURATION: %@", title, artist, duration);
            }
            title = nil;
            artist = nil;
            duration = nil;
            music = nil;
            item = nil;
        }
        musicTableView.delegate = self;
        musicTableView.dataSource = self;
        [self.musicTableView reloadData];
        //[musicPlayer play];
    }
    
    [self dismissViewControllerAnimated: YES completion:nil];
    
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated: YES completion:nil];
}

#pragma mark - Controls
- (IBAction)volumeChanged:(id)sender
{
    [musicPlayer setVolume:[volume value]];
}

- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
    [self.musicTableView reloadData];
}

- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
        [musicPlayer pause];
    else
        [musicPlayer play];
    [self.musicTableView reloadData];
}

- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
    [self.musicTableView reloadData];
}

-(long) Time {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *timeOfDayInHoursString = [dateFormatter stringFromDate:date];
    long timeOfDayInHours = [timeOfDayInHoursString integerValue];
    return timeOfDayInHours;
}

-(void) initBackground {
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
    if (currentTime < 12) background.image = [UIImage imageNamed:@"morning.jpg"];
    else if (currentTime > 12 && currentTime < 18) background.image = [UIImage imageNamed:@"afternoon.jpg"];
    else background.image = [UIImage imageNamed:@"evening.jpg"];
    [self.view addSubview: background];
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    return img;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    /*NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
     [dateformate setDateFormat:@"dd/MM/YYYY"];
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     NSEntityDescription *entity = [NSEntityDescription
     entityForName:@"Journal" inManagedObjectContext:managedObjectContext];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@", [dates objectAtIndex:section]];
     [fetchRequest setEntity:entity];
     [fetchRequest setPredicate:predicate];
     NSError *error = nil;
     numRowSection = [managedObjectContext executeFetchRequest:fetchRequest error: &error];*/
    
    //NSMutableArray *temp = [dateGroups objectForKey:[dates objectAtIndex:section]];
    
    return [savedSongs count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    
    MPMediaItem *currentItem = [savedSongs objectAtIndex:indexPath.row];
    if(currentItem)
    {
        if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
        {
            MPMediaItem *nowPlaying = musicPlayer.nowPlayingItem;
            if (([currentItem.itemTitle isEqualToString:nowPlaying.itemTitle] && [currentItem.itemArtist isEqualToString:nowPlaying.itemArtist]) || ([currentItem.itemTitle isEqualToString:nowPlaying.itemTitle] && (!currentItem.itemArtist && !nowPlaying.itemArtist))) {
                cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
                cell.backgroundView.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
            }
        }
        else
        {
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        }
        
        MPMediaItemArtwork *artwork = currentItem.itemArtwork;
        if(!artwork)
            cell.imageView.image = [self imageWithImage:[UIImage imageNamed:@"musicalNotes.png"] scaledToSize:CGSizeMake (frameWidth * .2, frameWidth * .2)];
        else
            cell.imageView.image = [artwork imageWithSize:CGSizeMake (frameWidth * .2, frameWidth * .2)];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", currentItem.itemTitle];
        if (!currentItem.itemArtist)
            cell.detailTextLabel.text = @"";
        else
            cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", currentItem.itemArtist];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [musicPlayer pause];
    playButton.enabled = YES;
    rewind.enabled = YES;
    fastforward.enabled = YES;
    
    if([musicPlayer playbackState] == MPMusicPlaybackStatePaused || [musicPlayer playbackState] == MPMusicPlaybackStateStopped)
        musicPlayer.nowPlayingItem = [savedSongs objectAtIndex:0];
    
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    NSString *currentTitle = currentItem.itemTitle;
    NSString *currentArtist = currentItem.itemArtist;
    
    MPMediaItem *desiredItem = [savedSongs objectAtIndex:indexPath.row];
    NSString *desiredTitle = desiredItem.itemTitle;
    NSString *desiredArtist = desiredItem.itemArtist;
    
    [musicPlayer skipToBeginning];
    
    for(MPMediaItem *song in savedSongs)
    {
        currentTitle = song.itemTitle;
        currentArtist = song.itemArtist;
        if(([currentTitle isEqualToString:desiredTitle] && [currentArtist isEqualToString:desiredArtist]) || ([currentTitle isEqualToString:desiredTitle] && (!currentArtist && !desiredArtist)))
        {
            musicPlayer.nowPlayingItem = song;
            break;
        }
    }
    
    [musicPlayer play];
    
}


// Override to support conditional editing of the table view.
// Return NO if you do not want the specified item to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
}



// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 NSLog(@"%s",__PRETTY_FUNCTION__);
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 
 }
 }*/


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end
