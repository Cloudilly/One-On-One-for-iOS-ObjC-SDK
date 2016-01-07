//
//  PublicViewController.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController()
@end

@implementation PublicViewController

-(id)init {
    self= [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProfileView:) name:@"showProfileView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProfileView:) name:@"hideProfileView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChatView:) name:@"showChatView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideChatView:) name:@"hideChatView" object:nil];
        publicFetchedResultsController= [self publicFetchedResultsController];
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
    title.text= @"Cloudilly";
    [self.view addSubview:title];
    
    UIButton *profileBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [profileBtn addTarget:self action:@selector(fireProfile) forControlEvents:UIControlEventTouchUpInside];
    profileBtn.frame= CGRectMake(0.0, 20.0, 50.0, 50.0);
    [profileBtn setImage:[UIImage imageNamed:@"Profile"] forState:UIControlStateNormal];
    [self.view addSubview:profileBtn];
    
    publicTableView= [[UITableView alloc] initWithFrame:CGRectMake(0.0, 70.0, width, height- 120.0) style:UITableViewStylePlain];
    publicTableView.backgroundColor= [UIColor whiteColor];
    publicTableView.delegate= self;
    publicTableView.dataSource= self;
    publicTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:publicTableView];
}

-(void)fireProfile {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showProfileView" object:nil];
}

-(void)showProfileView:(NSNotification *)notification {
    self.profileViewController= [[ProfileViewController alloc] init];
    [self.view addSubview:self.profileViewController.view];
}

-(void)hideProfileView:(NSNotification *)notification {
    [self.profileViewController.view removeFromSuperview];
    self.profileViewController= nil;
}

-(void)showChatView:(NSNotification *)notification {
    self.chatViewController= [[ChatViewController alloc] initWithOther:[notification.userInfo objectForKey:@"other"]];
    [self.view addSubview:self.chatViewController.view];
}

-(void)hideChatView:(NSNotification *)notification {
    [self.chatViewController.view removeFromSuperview];
    self.chatViewController= nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return sectionIndex== 0 ? 1 : publicFetchedResultsController.fetchedObjects.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section== 0) {
        static NSString *TitleCellIdentifier= @"TitleCellIdentifier";
        TitleCell *titleCell= [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier];
        if(titleCell== nil) { titleCell= [[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TitleCellIdentifier]; }
        titleCell.label.text= publicFetchedResultsController.fetchedObjects.count== 0 ? @"Oops. No one at the moment" : @"Users";
        return titleCell;
    }
    
    static NSString *UserCellIdentifier= @"UserCellIdentifier";
    UserCell *userCell= [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    if(userCell== nil) { userCell= [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserCellIdentifier]; }
    
    Device *device= [publicFetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    NSString *shortname= [[device.username componentsSeparatedByString:@"::"][1] componentsSeparatedByString:@"-"][0];
    userCell.username.text= device.username ? shortname : @"Anonymous";
    userCell.status.text= device.status ? device.status : @"No status";
    userCell.last.text= [device.timestamp isEqualToNumber:[NSNumber numberWithInt:0]] ? @"Online" :
        [NSString stringWithFormat:@"Last seen: %@", [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[device.timestamp longLongValue]/1000]]];
    return userCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section== 0 ? 44.0 : 70.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Device *other= [publicFetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    NSMutableDictionary *dictDevice= [[NSMutableDictionary alloc] init]; [dictDevice setObject:other forKey:@"other"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChatView" object:nil userInfo:dictDevice];
}

-(NSFetchedResultsController *)publicFetchedResultsController {
    NSManagedObjectContext *context= [[self appDelegate].database managedObjectContext];
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Device" inManagedObjectContext:context];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"isHidden== %@", [NSNumber numberWithInt:0]];
    NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *sortDescriptors= [NSArray arrayWithObjects:sort, nil]; NSFetchRequest *request= [[NSFetchRequest alloc] init];
    request.entity= entity; request.predicate= predicate; request.sortDescriptors= sortDescriptors;
    publicFetchedResultsController= [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    publicFetchedResultsController.delegate= self; [publicFetchedResultsController performFetch:nil];
    return publicFetchedResultsController;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [publicTableView reloadData];
}

-(NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter; static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter= [[NSDateFormatter alloc] init];
        dateFormatter.timeZone= [NSTimeZone defaultTimeZone];
        dateFormatter.dateFormat= @"d MMM yy',' h:mm a"; });
    return dateFormatter;
}

-(AppDelegate *)appDelegate { return (AppDelegate *)[[UIApplication sharedApplication] delegate]; }
-(UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
-(void)viewDidLoad { [super viewDidLoad]; }
-(void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end