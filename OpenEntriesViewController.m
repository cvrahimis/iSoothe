//
//  OpenEntriesViewController.m
//  iCope
//
//  Created by Costas Simiharv on 1/18/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "OpenEntriesViewController.h"

@interface OpenEntriesViewController ()

@end

@implementation OpenEntriesViewController

@synthesize dates;
@synthesize results;
@synthesize dateGroups;
@synthesize entry;
@synthesize title;
@synthesize delegate;


-(id) init{
    if(self = [super init])
    {        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"Done"
                                                 style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(done)];
        
        AppDelegate* appDelegate = [AppDelegate sharedAppdelegate];
        managedObjectContext = appDelegate.managedObjectContext;
        //================================================================Fetch From Core Data
        /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
         NSEntityDescription *entity = [NSEntityDescription
         entityForName:@"Journal" inManagedObjectContext:managedObjectContext];
         
         
         [fetchRequest setEntity:entity];
         [fetchRequest setResultType:NSDictionaryResultType];
         [fetchRequest setReturnsDistinctResults:YES];
         [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES]]];
         [fetchRequest setPropertiesToFetch:@[@"date"]];
         //NSDictionary *entityProperties = [entity propertiesByName];
         
         
         NSError *error = nil;
         dates = [managedObjectContext executeFetchRequest:fetchRequest error: &error];
         
         if (dates == nil) {
         // Handle the error.
         }*/
        
        //================================================================End Fetch From Core Data
        
        //================================================================Fetch From Core Date
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName: @"Journal" inManagedObjectContext: managedObjectContext];
        request.entity = entity;
        
        //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"date" ascending: YES];
        //request.sortDescriptors = @[[NSArray arrayWithObjects: sortDescriptor, nil]];
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:request error: &error];
        
        if (results == nil) {
            // Handle the error.
        }
        //================================================================End Fetch From Core Data
        dateGroups = [[NSMutableDictionary alloc] init];
        for(Journal *j in results)
        {
            if([dateGroups objectForKey:[j valueForKey:@"date"]] != nil)
            {
                NSMutableArray *temp = [dateGroups objectForKey:[j valueForKey:@"date"]];
                [temp addObject:j];
                [dateGroups setObject:temp forKey:[j valueForKey:@"date"]];
            }
            else
            {
                [dateGroups setObject:[NSMutableArray arrayWithArray:@[j]] forKey:[j valueForKey:@"date"]];
            }
        }
        dates = [dateGroups allKeys];
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.navigationItem.title = @"Open";
    self.navigationController.navigationBar.translucent = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

-(void) done{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    entry = @"";
    title = @"";
    [self.delegate closeOpenEntries:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [dateGroups count];
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
    
    NSMutableArray *temp = [dateGroups objectForKey:[dates objectAtIndex:section]];
    
    return temp.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"%s %@",__PRETTY_FUNCTION__,[dates objectAtIndex:section]);
    return [dates objectAtIndex:section];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //NSLog(@"%ld =============================", (long)indexPath.row);
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    //NSLog(@"%@ ////////",sectionTitle);
    static NSString *CellIdentifier = @"Cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    NSArray *temp = [dateGroups objectForKey:sectionTitle];
    Journal *journal = [temp objectAtIndex: indexPath.row];
    
    if (journal.title == nil)
        cell.textLabel.text = @"\t This is not Working";
    else
        cell.textLabel.text = journal.title;
    journal = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSArray *temp = [dateGroups objectForKey:sectionTitle];
    Journal *journal = [temp objectAtIndex: indexPath.row];
    entry = [journal valueForKey:@"entry"];
    title = [journal valueForKey:@"title"];
    [self.delegate closeOpenEntries:self];
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
