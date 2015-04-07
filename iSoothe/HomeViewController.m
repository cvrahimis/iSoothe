//
//  HomeViewController.m
//  SwipeFunctionality
//
//  Created by Costas Simiharv on 12/31/14.
//  Copyright (c) 2014 cvrahimis. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize bec;
@synthesize greetingLbl;
@synthesize ratingBtn;
/*@synthesize musicBtn;
 @synthesize readingBtn;
 @synthesize drawingBtn;
 @synthesize journalBtn;
 @synthesize excerciseBtn;*/
@synthesize contentImgView;

-(id) init{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if(self = [super init])
    {
        
        contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        [self initBackground];
        [self.view addSubview:contentImgView];
        
        greetingLbl = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frameWidth, frameHeight * .2)];
        greetingLbl.center = CGPointMake(frameWidth * .5, frameHeight * .15);
        greetingLbl.text = [self Greeting];
        greetingLbl.textAlignment = NSTextAlignmentCenter;
        greetingLbl.numberOfLines = 2;
        greetingLbl.font = [UIFont fontWithName: @"Courier-BoldOblique" size: 40];
        greetingLbl.textColor = [UIColor whiteColor];
        [self.view addSubview: greetingLbl];
        
        NSArray *colors = @[[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1],
                            [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1],
                            [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1],
                            [UIColor colorWithRed:.820 green:0.0 blue:1.0 alpha:1],
                            [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1],
                            ];
        NSArray *titles = @[@"Music", @"Reading", @"Drawing", @"Journal", @"Exercise"];
        
        for (int i = 0; i < 5; i++)
        {
            activityBtns[i] = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            [activityBtns[i] setFrame:CGRectMake(0, 0, frameWidth * .7, frameHeight * .06)];
            [activityBtns[i] setCenter:CGPointMake(frameWidth / 2, (frameHeight * .4) + ((frameHeight * .09) * (i + 1)))];
            activityBtns[i].backgroundColor = [colors objectAtIndex:i];
            activityBtns[i].layer.cornerRadius = 10;
            activityBtns[i].clipsToBounds = YES;
            activityBtns[i].tag = i;
            [activityBtns[i] setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
            [activityBtns[i].titleLabel setFont:[UIFont systemFontOfSize: 20]];
            [activityBtns[i] setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [activityBtns[i] addTarget:self action:@selector(activityPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: activityBtns[i]];
        }
        
        /*ratingBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [ratingBtn setFrame:CGRectMake(0, 0, frameWidth * .5, frameHeight * .06)];
        [ratingBtn setCenter:CGPointMake(frameWidth / 2, frameHeight * .95)];
        ratingBtn.backgroundColor = [UIColor yellowColor];
        ratingBtn.layer.cornerRadius = 10;
        ratingBtn.clipsToBounds = YES;
        ratingBtn.tag = 5;
        [ratingBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [ratingBtn.titleLabel setFont:[UIFont systemFontOfSize: 20]];
        [ratingBtn setTitle:@"Exit To Rating" forState:UIControlStateNormal];
        [ratingBtn addTarget:self action:@selector(ratingScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: ratingBtn];*/
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%s",__PRETTY_FUNCTION__);
    }
    return self;
}

-(void) initBackground {
    if (currentTime < 12) contentImgView.image = [UIImage imageNamed:@"morning.jpg"];
    else if (currentTime > 12 && currentTime < 18) contentImgView.image = [UIImage imageNamed:@"afternoon.jpg"];
    else contentImgView.image = [UIImage imageNamed:@"evening.jpg"];
}

// Method so strings only have to be created once.
-(void) initStrings {
    if ([bec isPatientAndTherapistOnDevice]) {
        Patient *patient = [bec getPatientOnDevice];
        name = [@" " stringByAppendingString:[patient valueForKey:@"patientFirstName"]];
    }
    else
        name = @"";
    
    morningGreeting = [[NSString stringWithFormat:@"Good Morning"] stringByAppendingString:name];
    afternoonGreeting = [[NSString stringWithFormat:@"Good Afternoon"] stringByAppendingString:name];
    eveningGreeting = [[NSString stringWithFormat:@"Good Evening"] stringByAppendingString:name];
}

-(void) initButtons {
    
    /*readingBtn.layer.cornerRadius = 10;
     drawingBtn.layer.cornerRadius = 10;
     journalBtn.layer.cornerRadius = 10;
     excerciseBtn.layer.cornerRadius = 10;
     
     readingBtn.clipsToBounds = YES;
     drawingBtn.clipsToBounds = YES;
     journalBtn.clipsToBounds = YES;
     excerciseBtn.clipsToBounds = YES;*/
}

// Method returns todays current hour.
-(long) Time {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *timeOfDayInHoursString = [dateFormatter stringFromDate:date];
    long timeOfDayInHours = [timeOfDayInHoursString integerValue];
    return timeOfDayInHours;
}

-(NSString *) Greeting {
    if (currentTime < 12) return morningGreeting;
    else if (currentTime > 12 && currentTime < 18) return afternoonGreeting;
    else return eveningGreeting;
}

// Returns greeting message based on time of day.
-(NSString *) Greeting:(int)timeOfDayInHours {
    if (timeOfDayInHours < 12) return morningGreeting;
    else if (timeOfDayInHours > 12 && timeOfDayInHours < 18) return afternoonGreeting;
    else return eveningGreeting;
}

- (void)viewDidLoad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    bec = [[BackEndComunicator alloc] initWithManagedObjectContext:appDelegate.managedObjectContext];
    
    currentTime = [self Time];
    //[self initBackground];
    [self initStrings];
    //[self initLabels];
    //[self initButtons];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) ratingScreen{
    RatingViewController *rateVC = [[RatingViewController alloc] init];
    rateVC.exit = YES;
    [self presentViewController:rateVC
                       animated:YES
                     completion:nil];
}

-(void)activityPress:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    switch (((UIButton*)sender).tag) {
        case 0:
        {
            NSLog(@"%s ================== Music Button Pressed", __PRETTY_FUNCTION__);
            MusicViewController *musicVC = [[MusicViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:musicVC];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
            break;
        }
        case 1:
        {
            NSLog(@"%s ================== Reading Button Pressed", __PRETTY_FUNCTION__);
            ReadingViewController *readingVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"readingViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readingVC];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
            
            break;
        }
        case 2:
        {
            NSLog(@"%s ================== Drawing Button Pressed", __PRETTY_FUNCTION__);
            DrawingViewController *draw = [[DrawingViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:draw];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
            //[self.navigationController presentViewController:draw animated:YES completion:nil];
            break;
        }
        case 3:
        {
            NSLog(@"%s ================== Journal Button Pressed", __PRETTY_FUNCTION__);
            //JournalViewController *journal = [mainStoryboard instantiateViewControllerWithIdentifier:@"journalViewController"];
            JournalViewController *journal = [[JournalViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:journal];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
            break;
        }
        case 4:
        {
            NSLog(@"%s ================== Exercise Button Pressed", __PRETTY_FUNCTION__);
            ExerciseTableViewController *exerciseTVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"exerciseTableViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:exerciseTVC];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
            break;
        }
        case 5:
        {
            NSLog(@"%s ================== Rating Button Pressed", __PRETTY_FUNCTION__);
            RatingViewController *ratingVC = [[RatingViewController alloc] init];
            [self.navigationController pushViewController:ratingVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //[background bringSubviewToFront:musicBtn];
}




@end
