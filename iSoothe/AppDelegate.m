//
//  AppDelegate.m
//  iSoothe
//
//  Created by Costas Simiharv on 4/7/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize exerciseNames;
@synthesize exerciseImgs;
@synthesize mainImg;
@synthesize exercise;
@synthesize quotes;
@synthesize authors;
@synthesize bec;
@synthesize viewController;
@synthesize exerciseDesc;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Exercises" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error: &error];
    
    if (fetchedObjects.count == 0) {
        exerciseNames = @[@"Back lifts", @"Crunches", @"Leg lifts", @"Planks"];
        exerciseImgs= @[@"backlifts1.jpg|backlifts2.jpg", @"crunches1.jpg|crunches2.jpg|crunches3.jpg", @"leglifts1.jpg|leglifts2.jpg|leglifts3.jpg", @"plank.jpg|sideplank.jpg"];
        mainImg = @[@"backlifts1.jpg", @"crunches1.jpg", @"leglifts1.jpg", @"plank.jpg"];
        exerciseDesc = @[@"Lay down on your stomach and lift your hands and feet off the ground", @"Lay down on you back and use your abdominal muscles to lift your torso up", @"Lay down on you back and lift your feet into the air", @"Use your forearms and feet to keep your body off the ground"];
        [self setUpExerciseTable];
    }
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    error = nil;
    fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error: &error];
    
    if (fetchedObjects.count == 0) {
        quotes = @[@"\"You have a brain in your head. You have feet in your shoes.  You can steer yourself any direction you choose!\"",
                   @"\"If you can dream it, you can do it\"",
                   @"\"You can search throughout the entire universe for someone who is more deserving of your love and affection than you are yourself, and that person is not to be found anywhere.  You yourself, as much as anybody in the entire universe deserve your love and affection.\"",
                   @"\"Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.\"",
                   @"\"Go confidently in the direction of your dreams. Live the life you have imagined.\"",
                   @"\"What you think you become. What you feel you attract. What you imagine you create.\"",
                   @"\"Believe you can and you’re halfway there.\"",
                   @"\"To love oneself is the beginning of a lifelong romance.\"",
                   @"\"Look for goodness in others, for beauty in the world, and for possibilities in yourself.\"",
                   @"\"What lies behind us and what lies before us are tiny matters compared to what lies within us.\"",
                   @"\"Only as high as I reach can I grow, only as far as I seek can I go, only as deep as I look can I see, only as much as I dream can I be.\"",
                   @"\"You have to be unique, and different, and shine in your own way.\"",
                   @"\"The mind is everything. What you think you become.\"",
                   @"\"Who looks outside, dreams. Who looks inside, awakes.\"",
                   @"\"The mind is everything.  What you think you become.\"",
                   @"\"You must expect great things of yourself before you can do them.\"",
                   @"\"Be happy in the moment, that’s enough. Each moment is all we need, not more.\"",
                   @"\"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.\"",
                   @"\"Nothing is impossible, the word itself says 'I'm possible'!\"",
                   @"\"There are far, far better things ahead than any we leave behind.\"",
                   @"\"Just keep swimming\"",
                   @"\"The power for creating a better future is contained in the present moment; you create a good future by creating a good present.\"",
                   @"\"There is no way to happiness, happiness is the way.\"",
                   @"\"If you want others to be happy, practice compassion.  If you want to be happy, practice compassion.\""];
        authors = @[@"–Dr. Seuss", @"–Walt Disney", @"–Buddha", @"–Buddha",@"–Henry David Thoreau",
                    @"-Buddha", @"–Theodore Roosevelt", @"–Oscar Wilde", @"–Wes Fessler", @"–Ralph Waldo Emerson",
                    @"–Karen Ravn", @"–Lady Gage", @"–Buddha", @"–Carl Jung", @"–Buddha",
                    @"-Michael Jordan", @"–Mother Teresa", @"–Helen Keller", @"–Audrey Hepburn", @"–Ralph Waldo Emerson",
                    @"–Finding Nemo", @"–Eckhart Tolle", @"–Thich Nhat Hanh", @"–Dalai Lama"];
        [self setUpQuotesTable];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bec = [[BackEndComunicator alloc] initWithManagedObjectContext:_managedObjectContext];
    if ([bec isPatientAndTherapistOnDevice])
        self.viewController = [[RatingViewController alloc] init];
    else
        self.viewController = [[LoginViewController alloc] init];
    
    //self.viewController = [[RatingViewController alloc] init];//debug
    
    self.navCtrl = [[UINavigationController alloc] initWithRootViewController: self.viewController];
    //[self.navCtrl setNavigationBarHidden:NO animated:YES];
    self.navCtrl.delegate = self.viewController;
    [self.window 	setRootViewController: self.navCtrl];
    self.window.userInteractionEnabled = YES;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    return YES;
}

-(void)setUpQuotesTable{
    for (int i = 0; i < [quotes count]; i++)
    {
        quote = [NSEntityDescription insertNewObjectForEntityForName: @"Quotes" inManagedObjectContext: _managedObjectContext];
        [quote setValue:quotes[i] forKey:@"quote"];
        [quote setValue:authors[i] forKey:@"author"];
        
        NSError *error = nil;
        if([_managedObjectContext save: &error])
        {
            NSLog(@"%@", [@"Successsfully added " stringByAppendingString:quotes[i]]);
        }
    }
}


-(void)setUpExerciseTable{
    for (int i = 0; i < [exerciseNames count]; i++)
    {
        exercise = [NSEntityDescription insertNewObjectForEntityForName: @"Exercises" inManagedObjectContext: _managedObjectContext];
        [exercise setValue:exerciseNames[i] forKey:@"exerciseName"];
        [exercise setValue:exerciseImgs[i] forKey:@"pictures"];
        [exercise setValue:mainImg[i] forKey:@"mainPicture"];
        [exercise setValue:exerciseDesc[i] forKey:@"descriptions"];
        
        NSError *error = nil;
        if([_managedObjectContext save: &error])
        {
            NSLog(@"%@", [@"Successsfully added " stringByAppendingString:exerciseNames[i]]);
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

+(AppDelegate*)sharedAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cvrahimis.iSoothe" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iSoothe" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iSoothe.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
