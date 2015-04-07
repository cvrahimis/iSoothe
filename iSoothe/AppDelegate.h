//
//  AppDelegate.h
//  iSoothe
//
//  Created by Costas Simiharv on 4/7/15.
//  Copyright (c) 2015 cvrahimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Exercises.h"
#import "Quotes.h"
#import "LoginViewController.h"
#import "BackEndComunicator.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Exercises *exercise;
    Quotes *quote;
    NSArray *exerciseNames;
    NSArray *exerciseImgs;
    NSArray *exerciseDesc;
    NSArray *mainImg;
    NSArray *quotes;
    NSArray *authors;
    UIViewController<UINavigationControllerDelegate> *viewController;
    BackEndComunicator *bec;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BackEndComunicator *bec;
@property (strong, nonatomic) UINavigationController *navCtrl;
@property (strong, nonatomic) UIViewController<UINavigationControllerDelegate> *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) NSArray *exerciseNames;
@property (strong, nonatomic) NSArray *exerciseImgs;
@property (strong, nonatomic) NSArray *exerciseDesc;
@property (strong, nonatomic) NSArray *mainImg;
@property (strong, nonatomic) NSArray *quotes;
@property (strong, nonatomic) NSArray *authors;
@property (strong, nonatomic) Exercises *exercise;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+(AppDelegate*)sharedAppdelegate;


@end
