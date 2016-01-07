//
//  ProfileViewController.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController()
@end

@implementation ProfileViewController

-(id)init {
    self= [super init];
    if(self) {
    }
    return self;
}

-(void)loadView {
    width= [[UIScreen mainScreen] bounds].size.width;
    height= [[UIScreen mainScreen] bounds].size.height;
    self.view= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    self.view.backgroundColor= [UIColor whiteColor];
    
    UIView *status= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 20.0)];
    status.backgroundColor= [UIColor blackColor];
    [self.view addSubview:status];
    
    UIView *top= [[UIView alloc] initWithFrame:CGRectMake(0.0, 20.0, width, 50.0)];
    top.backgroundColor= [UIColor blackColor];
    [self.view addSubview:top];
    
    UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 26.0, width, 36.0)];
    title.font= [UIFont fontWithName:@"ChalkboardSE-Bold" size:22.0];
    title.backgroundColor= [UIColor clearColor];
    title.textAlignment= NSTextAlignmentCenter;
    title.textColor= [UIColor whiteColor];
    title.text= @"Profile";
    [self.view addSubview:title];
    
    UIButton *backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(fireBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame= CGRectMake(0.0, 20.0, 50.0, 50.0);
    [backBtn setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UIButton *submitBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(fireSubmit) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font= [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:20.0];
    submitBtn.frame= CGRectMake(width -70.0, 22.0, 60.0, 50.0);
    [self.view addSubview:submitBtn];
    
    profileTableView= [[UITableView alloc] initWithFrame:CGRectMake(0.0, 70.0, width, height- 120.0) style:UITableViewStylePlain];
    profileTableView.backgroundColor= [UIColor whiteColor];
    profileTableView.delegate= self;
    profileTableView.dataSource= self;
    profileTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:profileTableView];
}

-(void)fireBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProfileView" object:nil];
}

-(void)fireSubmit {
    if([statusCell.textField.text isEqualToString:@""]) { return; }
    
    NSMutableDictionary *dictProfile= [[NSMutableDictionary alloc] init];
    [dictProfile setObject:statusCell.textField.text forKey:@"status"];
    [[self appDelegate].database updateProfile:dictProfile];
    
    NSMutableDictionary *dictPayload= [[NSMutableDictionary alloc] init];
    [dictPayload setObject:statusCell.textField.text forKey:@"status"];
    [[self appDelegate].cloudilly updatePayload:dictPayload WithCallback:^(NSDictionary *dict) {
        NSLog(@"@@@@@@ UPDATE");
        NSLog(@"%@", dict);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideProfileView" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Profile *profile= [[self appDelegate].database fetchProfile];
    if(statusCell== nil) { statusCell= [[TextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]; }
    statusCell.label.text= @"Status";
    statusCell.textField.placeholder= @"Optional";
    statusCell.textField.text= profile.status;
    return statusCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    indexPath.row== 0 ? [statusCell hideTextFieldKeyboard] : [statusCell showTextFieldKeyboard];
}

-(AppDelegate *)appDelegate { return (AppDelegate *)[[UIApplication sharedApplication] delegate]; }
-(UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
-(void)viewDidLoad { [super viewDidLoad]; }
-(void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end