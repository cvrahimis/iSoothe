//
//  JournalViewController.m
//  BlueApp
//
//  Created by Costas Simiharv on 1/13/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "JournalViewController.h"
#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height
@interface JournalViewController ()

@end

@implementation JournalViewController
@synthesize background;
@synthesize saveBtn;
@synthesize titleTF;
@synthesize entryTV;
@synthesize startTime;
@synthesize endTime;
@synthesize scrollView;

-(id) init{
    if(self = [super init])
    {
        currentTime = [self Time];
        startTime = [NSDate date];
        
        background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        [self initBackground];
        [self.view addSubview:background];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        singleTap.numberOfTapsRequired = 1;
        self.scrollView.userInteractionEnabled = YES;
        [self.scrollView addGestureRecognizer:singleTap];
        [self.view addSubview:scrollView];
        
        titleTF = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, frameWidth * .6, frameHeight *.08)];
        titleTF.placeholder = @"Title";
        titleTF.backgroundColor = [UIColor whiteColor];
        titleTF.layer.borderWidth = 0.5f;
        titleTF.layer.borderColor = [[UIColor blackColor] CGColor];
        titleTF.delegate = self;
        titleTF.center = CGPointMake(frameWidth / 2, frameHeight * .1);
        [scrollView addSubview:titleTF];
        
        entryTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .7, frameHeight * .4)];
        entryTV.center = CGPointMake(frameWidth / 2, frameHeight * .35);
        entryTV.selectedRange = NSMakeRange(0, 0);
        entryTV.layer.borderWidth = 0.5f;
        entryTV.layer.borderColor = [[UIColor blackColor] CGColor];
        entryTV.delegate = self;
        [scrollView addSubview:entryTV];
        
        saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frameWidth * .27, frameHeight * .07)];
        saveBtn.center = CGPointMake(frameWidth /2, frameHeight * .65);
        saveBtn.backgroundColor = [UIColor blueColor];
        saveBtn.layer.cornerRadius = 10;
        saveBtn.layer.borderColor=[[UIColor colorWithRed:.7 green:.9 blue:1 alpha:1] CGColor];
        saveBtn.showsTouchWhenHighlighted = YES;
        [saveBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont systemFontOfSize: 17]];
        [saveBtn setTitle: @"Save" forState: UIControlStateNormal];
        saveBtn.userInteractionEnabled = YES;
        [saveBtn addTarget:self action:@selector(savePress:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:saveBtn];
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
    
}

- (void)savePress:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if([entryTV.text isEqualToString:@""] || [titleTF.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"There is no title or entry"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSArray *fetchedObjs = [self returnJournalIfExist];
            
        if([fetchedObjs count] > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title already Exists"
                                                            message:@"Do you want to overwrite?"
                                                            delegate:self
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        else
        {
            AppDelegate *appDelegate = [AppDelegate sharedAppdelegate];
            NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
            
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"MM/dd/YYYY"];
            
            Journal *journal = [NSEntityDescription insertNewObjectForEntityForName: @"Journal" inManagedObjectContext: managedObjectContext];
            [journal setValue:titleTF.text forKey:@"title"];
            [journal setValue:entryTV.text forKey:@"entry"];
            [journal setValue:[dateformate stringFromDate:[NSDate date]] forKey:@"date"];
            NSError *error = nil;
            if([managedObjectContext save: &error])
            {
                NSLog(@"Successsfully added %@",titleTF.text);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:[@"Saved " stringByAppendingString:titleTF.text]
                                                                delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSLog(@"Could Not add %@",titleTF.text);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                message:[@"Could not save " stringByAppendingString:titleTF.text]
                                                                delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [alert show];
            }
        }
            
    }
    
}

-(NSArray *) returnJournalIfExist{
    AppDelegate *appDelegate = [AppDelegate sharedAppdelegate];
    
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Journal" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title ==[c] %@", titleTF.text];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error: &error];
    return fetchedObjects;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //YES
    if (buttonIndex == 1) {
        Journal *journal = [[self returnJournalIfExist] objectAtIndex:0];
        [journal setValue:entryTV.text forKey:@"entry"];
        AppDelegate *appDelegate = [AppDelegate sharedAppdelegate];
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        NSError *error = nil;
        if([managedObjectContext save: &error])
        {
            NSLog(@"%@", [[[@"Successsfully updated title: " stringByAppendingString:[journal valueForKey:@"title"]]stringByAppendingString:@" with entry: "] stringByAppendingString:[journal valueForKey:@"entry"]]);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.navigationItem.title = @"Journal";
    self.navigationController.navigationBar.translucent = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                                      initWithTitle:@"Open"
                                                                                      style:UIBarButtonItemStyleDone
                                                                                      target:self
                                                                                      action:@selector(open)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Done"
                                             style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(done)];
    
    entryTV.text = entry;
    titleTF.text = title;
}

-(void)hideKeyBoard
{
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}
- (BOOL) textFieldShouldReturn: (UITextField *) txtField {
    [txtField resignFirstResponder];
    [entryTV becomeFirstResponder];
    return NO;
}

-(BOOL)textViewShouldReturn: (UITextView *) txtView{
    [txtView resignFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [scrollView setContentOffset:CGPointMake(0, [scrollView convertPoint:CGPointZero fromView:textView].y - 5)];
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
    rvc.activity = @"Writing";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    //now present this navigation controller modally
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

-(void) open{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    //OpenEntriesViewController * oevc = [mainStoryboard instantiateViewControllerWithIdentifier:@"openEntriesViewController"];
    //OpenEntriesViewController *oevc = [[OpenEntriesViewController alloc] init];
    //[self presentViewController:oevc animated:YES completion:nil];
    //OpenEntriesViewController *oevc = [[OpenEntriesViewController alloc] init];
    //OpenEntriesViewController * oevc = [mainStoryboard instantiateViewControllerWithIdentifier:@"openEntriesViewController"];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:oevc];
    
    //now present this navigation controller modally
    //[self presentViewController:navigationController animated:YES completion:nil];
    
    OpenEntriesViewController *oevc = [[OpenEntriesViewController alloc] init];
    oevc.entry = entryTV.text;
    oevc.title = titleTF.text;
    [oevc setDelegate:self];
    [self.navigationController pushViewController:oevc animated:YES];
}

- (void)closeOpenEntries:(id)sender{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    title = ((OpenEntriesViewController*)sender).title;
    entry = ((OpenEntriesViewController*)sender).entry;
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
    if (currentTime < 12) background.image = [UIImage imageNamed:@"morning.jpg"];
    else if (currentTime > 12 && currentTime < 18) background.image = [UIImage imageNamed:@"afternoon.jpg"];
    else background.image = [UIImage imageNamed:@"evening.jpg"];
}

@end
