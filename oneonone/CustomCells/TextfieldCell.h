//
//  TextfieldCell.h
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextfieldCell: UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;

-(void)showTextFieldKeyboard;
-(void)hideTextFieldKeyboard;

@end