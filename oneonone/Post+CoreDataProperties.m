//
//  Post+CoreDataProperties.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post+CoreDataProperties.h"

@implementation Post (CoreDataProperties)

@dynamic post;
@dynamic timestamp;
@dynamic device;
@dynamic sender;
@dynamic recipient;
@dynamic msg;

@end