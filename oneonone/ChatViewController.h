//
//  ChatViewController.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Profile.h"
#import "Device.h"

@interface ChatViewController: UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate> {
    CGFloat width;
    CGFloat height;
    UITableView *chatTableView;
    UIView *bottom;
    UITextField *field;
    NSFetchedResultsController *chatFetchedResultsController;
}

@property (strong, nonatomic) Device *other;

-(id)initWithOther:(Device *)other;

@end