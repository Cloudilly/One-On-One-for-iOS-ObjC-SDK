//
//  AppDelegate.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cloudilly.h"
#import "Database.h"
#import "PublicViewController.h"

@class Cloudilly, Database, PublicViewController;

@interface AppDelegate: UIResponder <UIApplicationDelegate, CloudillyDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Cloudilly *cloudilly;
@property (strong, nonatomic) Database *database;
@property (strong, nonatomic) PublicViewController *publicViewController;

@end