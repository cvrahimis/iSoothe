//
//  ExerciseViewController.m
//  iCope
//
//  Created by Costas Simiharv on 1/26/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "ExerciseViewController.h"
#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height

@implementation ExerciseViewController
@synthesize contentView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize exercises;
@synthesize descriptions;

-(id) initWithExercise:(Exercises*) ex{
    if(self = [super init])
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        self.view.backgroundColor = [UIColor whiteColor];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, frameWidth, frameWidth)];
        //contentView.center = CGPointMake(frameWidth / 2, self.navigationController.navigationBar.frame.size.height);
        //contentView.layer.cornerRadius = 40;
        contentView.clipsToBounds = YES;
        contentView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
        [self.view addSubview:contentView];
        //self.alpha = 0;
        
        // set default properties
        //self.popUpStyle = BTPopUpStyleDefault;
        //self.popUpBorderStyle = BTPopUpBorderStyleDefaultNone;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
        scrollView.alwaysBounceHorizontal=YES;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        [contentView addSubview:scrollView];
        
        pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, 5, contentView.frame.size.width, 25);
        pageControl.backgroundColor = [UIColor clearColor];
        [contentView addSubview:pageControl];
        
        exercises = ex;
        
        NSArray *pictures = [[exercises valueForKey:@"pictures"] componentsSeparatedByString:@"|"];
        pageControl.numberOfPages = pictures.count;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pictures.count, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        
        for(int i = 0; i < [pictures count]; i++){
            NSLog(@"%@",pictures[i]);
            pageControl.currentPage = i;
            UIImageView *ex = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
            [ex setImage:[UIImage imageNamed:pictures[i]]];
            [scrollView addSubview: ex];
        }
        
        descriptions = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight * .3)];
        descriptions.center = CGPointMake(frameWidth / 2, frameWidth + (frameHeight * .1));
        descriptions.text = [exercises valueForKey:@"descriptions"];
        descriptions.numberOfLines = 2;
        descriptions.textAlignment = NSTextAlignmentCenter;
        descriptions.textColor = [UIColor blackColor];
        [self.view addSubview:descriptions];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // initialize the main content of the menu
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [exercises valueForKey:@"exerciseName"];
    self.navigationController.navigationBar.translucent = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
