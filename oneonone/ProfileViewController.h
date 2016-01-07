//
//  ProfileViewController.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TextfieldCell.h"

@class TextfieldCell;

@interface ProfileViewController: UIViewController <UITableViewDataSource, UITableViewDelegate> {
    CGFloat width;
    CGFloat height;
    UITableView *profileTableView;
    TextfieldCell *statusCell;
}

@end