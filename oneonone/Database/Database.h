//
//  Database.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Profile.h"
#import "Device.h"
#import "Post.h"

@interface Database: NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(Profile *)fetchProfile;
-(BOOL)updateProfile:(NSMutableDictionary *)dict;
-(Device *)fetchDevice:(NSString *)device;
-(BOOL)updateDevice:(NSMutableDictionary *)dict;
-(BOOL)hideAllDevices;
-(Post *)fetchPost:(NSString *)post;
-(BOOL)updatePost:(NSMutableDictionary *)dict;

@end