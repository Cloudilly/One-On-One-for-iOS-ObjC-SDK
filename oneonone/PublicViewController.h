//
//  PublicViewController.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "ChatViewController.h"
#import "TitleCell.h"
#import "UserCell.h"

@class ProfileViewController, ChatViewController;

@interface PublicViewController: UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    CGFloat width;
    CGFloat height;
    UITableView *publicTableView;
    NSFetchedResultsController *publicFetchedResultsController;
}

@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) ChatViewController *chatViewController;

@end