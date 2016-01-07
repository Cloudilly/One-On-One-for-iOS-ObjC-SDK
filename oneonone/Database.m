//
//  Database.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "Database.h"

@implementation Database

@synthesize managedObjectContext= _managedObjectContext;
@synthesize managedObjectModel= _managedObjectModel;
@synthesize persistentStoreCoordinator= _persistentStoreCoordinator;

-(id)init {
    self= [super init];
    if(self) {
    }
    return self;
}

// PROFILE
-(Profile *)fetchProfile {
    NSManagedObjectContext *context= [self managedObjectContext];
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:context];
    request.entity= entity; NSArray *profile= [context executeFetchRequest:request error:nil];
    return profile.count> 0 ? [profile objectAtIndex:0] : [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
}

-(BOOL)updateProfile:(NSMutableDictionary *)dict {
    Profile *profile= [self fetchProfile];
    NSManagedObjectContext *context= [self managedObjectContext];
    if(!profile) { profile= [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; }
    if([dict objectForKey:@"username"]) { profile.username= [dict objectForKey:@"username"]; }
    if([dict objectForKey:@"password"]) { profile.password= [dict objectForKey:@"password"]; }
    if([dict objectForKey:@"status"]) { profile.status= [dict objectForKey:@"status"]; }
    if([dict objectForKey:@"device"]) { profile.device= [dict objectForKey:@"device"]; }
    if([dict objectForKey:@"token"]) { profile.token= [dict objectForKey:@"token"]; }
    return [context save:nil];
}

// DEVICE
-(Device *)fetchDevice:(NSString *)device {
    NSManagedObjectContext *context= [self managedObjectContext];
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Device" inManagedObjectContext:context];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"device== %@", device];
    request.entity= entity; request.predicate= predicate;
    NSArray *devices= [context executeFetchRequest:request error:nil];
    return devices.count> 0 ? [devices objectAtIndex:0] : nil;
}

-(BOOL)updateDevice:(NSMutableDictionary *)dict {
    Device *device= [self fetchDevice:[dict objectForKey:@"device"]];
    NSManagedObjectContext *context= [self managedObjectContext];
    if(!device) { device= [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context]; }
    if([dict objectForKey:@"device"]) { device.device= [dict objectForKey:@"device"]; }
    if([dict objectForKey:@"timestamp"]) { device.timestamp= [dict objectForKey:@"timestamp"]; }
    if([dict objectForKey:@"username"]) { device.username= [dict objectForKey:@"username"]; }
    if([dict objectForKey:@"status"]) { device.status= [dict objectForKey:@"status"]; }
    device.isHidden= [NSNumber numberWithInt:0];
    return [context save:nil];
}

-(BOOL)hideAllDevices {
    NSManagedObjectContext *context= [self managedObjectContext];
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Device" inManagedObjectContext:context];
    request.entity= entity; NSArray *devices= [context executeFetchRequest:request error:nil];
    for(Device *device in devices) { device.isHidden= [NSNumber numberWithInt:1]; }
    return [context save:nil];
}

// POST
-(Post *)fetchPost:(NSString *)post {
    NSManagedObjectContext *context= [self managedObjectContext];
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"post== %@", post];
    request.entity= entity; request.predicate= predicate;
    NSArray *posts= [context executeFetchRequest:request error:nil];
    return posts.count> 0 ? [posts objectAtIndex:0] : nil;
}

-(BOOL)updatePost:(NSMutableDictionary *)dict {
    Post *post= [self fetchPost:[dict objectForKey:@"post"]];
    NSManagedObjectContext *context= [self managedObjectContext];
    if(!post) { post= [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context]; }
    if([dict objectForKey:@"post"]) { post.post= [dict objectForKey:@"post"]; }
    if([dict objectForKey:@"timestamp"]) { post.timestamp= [dict objectForKey:@"timestamp"]; }
    if([dict objectForKey:@"device"]) { post.device= [dict objectForKey:@"device"]; }
    if([dict objectForKey:@"sender"]) { post.sender= [dict objectForKey:@"sender"]; }
    if([dict objectForKey:@"recipient"]) { post.recipient= [dict objectForKey:@"recipient"]; }
    if([dict objectForKey:@"msg"]) { post.msg= [dict objectForKey:@"msg"]; }
    return [context save:nil];
}

// CORE DATA
-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext!= nil) { return _managedObjectContext; }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator!= nil) {
        _managedObjectContext= [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel {
    if(_managedObjectModel!= nil) { return _managedObjectModel; }
    NSURL *modelURL= [[NSBundle mainBundle] URLForResource:@"oneonone.v.1.0.0" withExtension:@"momd"];
    _managedObjectModel= [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator != nil) { return _persistentStoreCoordinator; }
    NSURL *storeURL= [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"oneonone.v.1.0.0.sqlite"];
    NSError *error= nil;
    _persistentStoreCoordinator= [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options= [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"@@@ COREDATA ERROR: %@", error.localizedDescription); abort();
    }
    return _persistentStoreCoordinator;
}

@end