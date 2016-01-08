//
//  Post+CoreDataProperties.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *post;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) NSString *device;
@property (nullable, nonatomic, retain) NSString *sender;
@property (nullable, nonatomic, retain) NSString *recipient;
@property (nullable, nonatomic, retain) NSString *msg;

@end

NS_ASSUME_NONNULL_END