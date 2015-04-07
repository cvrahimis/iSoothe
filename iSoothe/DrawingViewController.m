//
//  DrawingViewController.m
//  BlueApp
//
//  Created by Costas Simiharv on 1/13/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "DrawingViewController.h"
#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height

@interface DrawingViewController ()

@end

@implementation DrawingViewController

@synthesize mainImage;
@synthesize tempDrawImage;
@synthesize colors;
@synthesize startTime;
@synthesize endTime;


-(id) init
{
    if(self = [super init])
    {
        red = 0.0/255.0;
        green = 0.0/255.0;
        blue = 0.0/255.0;
        brush = 10.0;
        opacity = 1.0;
        openSave = YES;
        
        startTime = [NSDate date];
        
        self.navigationItem.rightBarButtonItem = self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                                          initWithTitle:@"Save"
                                                                                          style:UIBarButtonItemStyleDone
                                                                                          target:self
                                                                                          action:@selector(save:)];
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"Done"
                                                 style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(done)];
        
        mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        mainImage.backgroundColor = [UIColor whiteColor];
        mainImage.tintColor = [UIColor clearColor];
        [self.view addSubview:mainImage];
        tempDrawImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        [self.view addSubview:tempDrawImage];
        
        //colors
        colors = @[[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1],
                   [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1],
                   [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1],
                   [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1],
                   [UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1],
                   [UIColor colorWithRed:102.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1],
                   [UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1],
                   [UIColor colorWithRed:160.0/255.0 green:82.0/255.0 blue:45.0/255.0 alpha:1],
                   [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0.0/255.0 alpha:1],
                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1]
                   ];
        
        CGFloat btnHeight = frameHeight * .1;
        CGFloat btnWidth = frameWidth / colors.count;
        
        // Color Buttons
        for (int i = 0; i < colors.count; i++)
        {
            colorBtns[i] = [UIButton buttonWithType: UIButtonTypeSystem];
            [colorBtns[i] setFrame:CGRectMake(i * btnWidth, frameHeight - btnHeight, btnWidth, btnHeight)];
            colorBtns[i].tintColor = [UIColor clearColor];
            colorBtns[i].backgroundColor = [colors objectAtIndex:i];
            colorBtns[i].tag = i;
            //colorBtns[i].layer.borderWidth = 0.5f;
            //colorBtns[i].layer.borderColor = [[UIColor blackColor] CGColor];
            [colorBtns[i] addTarget:self action:@selector(pencilPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: colorBtns[i]];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"Drawing";
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
    
    NSArray *topBtnTitles = @[@"Reset", @"Settings", @"Erase", @"Open"];
    NSArray *topActions = @[@"reset:", @"settings", @"pencilPressed:", @"openPicture"];
    CGFloat btnHeight = frameHeight * .05;
    CGFloat btnWidth = frameWidth / topBtnTitles.count;
    
    
    
    for(int i = 0;i < (sizeof topBtns) / (sizeof topBtns[0]); i++)
    {
        topBtns[i] = [UIButton buttonWithType: UIButtonTypeSystem];
        [topBtns[i] setFrame:CGRectMake(i * btnWidth, self.navigationController.navigationBar.frame.size.height + btnHeight, btnWidth, btnHeight)];
        topBtns[i].tintColor = [UIColor clearColor];
        topBtns[i].backgroundColor = [UIColor clearColor];
        topBtns[i].tag = i + colors.count;
        //topBtns[i].layer.borderWidth = 0.5f;
        //topBtns[i].layer.borderColor = [[UIColor blackColor] CGColor];
        [topBtns[i] setTitle:[topBtnTitles objectAtIndex:i]  forState:UIControlStateNormal];
        [topBtns[i] setTitleColor: [UIColor colorWithRed:36.0/255.0 green:107.0/255.0 blue:244.0/255.0 alpha:1] forState: UIControlStateNormal];
        [topBtns[i].titleLabel setFont:[UIFont systemFontOfSize: 16]];
        [topBtns[i] addTarget:self action:NSSelectorFromString([topActions objectAtIndex:i]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:topBtns[i]];
    }
}

-(void) done{
    
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
    rvc.activity = @"Drawing";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    //now present this navigation controller modally
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}


-(void)openPicture{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    openSave = YES;
    UIActionSheet *alertMenu = [[UIActionSheet alloc]
                                initWithTitle:@"Open picture by..."  //Alert Title
                                delegate:self
                                cancelButtonTitle:@"Cancel"                         //Cancel Title
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"Taking a Photo", @"Selecting From Gallary" , nil];
    
    [alertMenu showInView:mainImage];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%s imagePickerController", __PRETTY_FUNCTION__);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //CGSize sz = CGSizeMake(frameWidth, frameHeight);
    
    [mainImage setImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    
    return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pencilPressed:(id)sender {
    
    UIButton * PressedButton = (UIButton*)sender;
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 10:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 255.0/255.0;
            opacity = 1.0;
            break;
        default:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 255.0/255.0;
            opacity = 1.0;
            break;
    }
}

/*- (IBAction)eraserPressed:(id)sender {
 }*/

- (IBAction)reset:(id)sender {
    self.mainImage.image = nil;
}

//- (IBAction)settings:(id)sender {
//}

- (IBAction)save:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    openSave = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Camera Roll", @"Cancel", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if(openSave){
        NSLog(@"%s Opening",__PRETTY_FUNCTION__);
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        switch (buttonIndex)
        {
            case 0:
                NSLog(@"%s ActionSheet Select Camera",__PRETTY_FUNCTION__);
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self  presentViewController:picker animated:YES completion:NULL];
                break;
            case 1:
                NSLog(@"%s ActionSheet Select Gallery",__PRETTY_FUNCTION__);
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
                break;
        }
        
    }
    else
    {
        NSLog(@"%s Saving",__PRETTY_FUNCTION__);
        if(buttonIndex == 0) {
            
            UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
            UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"%s",__PRETTY_FUNCTION__);
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"%s",__PRETTY_FUNCTION__);
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (void)settings {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    //SettingsViewController *settingsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsVC];

    settingsVC.delegate = self;
    settingsVC.brush = brush;
    settingsVC.opacity = opacity;
    settingsVC.red = red;
    settingsVC.green = green;
    settingsVC.blue = blue;
    [self presentViewController:navigationController animated:YES completion:nil];
    //[self.navigationController pushViewController:settingsVC animated:YES];
    
}

#pragma mark - SettingsViewControllerDelegate methods

- (void)closeSettings:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    brush = ((SettingsViewController*)sender).brush;
    opacity = ((SettingsViewController*)sender).opacity;
    red = ((SettingsViewController*)sender).red;
    green = ((SettingsViewController*)sender).green;
    blue = ((SettingsViewController*)sender).blue;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
