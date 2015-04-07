//
//  ExerciseTableViewController.m
//  iCope
//
//  Created by Costas Simiharv on 1/25/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "ExerciseTableViewController.h"
#import "Exercises.h"

@implementation ExerciseTableViewController
@synthesize fetchedObjects;
@synthesize startTime;
@synthesize endTime;

- (void)viewDidLoad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    startTime = [NSDate date];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];;
    
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercises" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error: &error];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Done"
                                             style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(done)];
    
    self.navigationItem.title = @"Exercises";
    self.navigationController.navigationBar.translucent = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
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
    rvc.activity = @"Exercise";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    //now present this navigation controller modally
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    static NSString *cellIdentifier = @"exerciseCell";
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ExerciseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    Exercises *exercise = [fetchedObjects objectAtIndex:indexPath.row];
    cell.exerciseName.text = [exercise valueForKey:@"exerciseName"];
    [cell.exerciseImage setImage:[UIImage imageNamed:[exercise valueForKey:@"mainPicture"]]];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExerciseViewController *evc = [[ExerciseViewController alloc] initWithExercise: [fetchedObjects objectAtIndex:indexPath.row]];
    //Exercises *exercise = [fetchedObjects objectAtIndex:indexPath.row];
    //evc.exercises = exercise;
    [self.navigationController pushViewController:evc animated:YES];
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
