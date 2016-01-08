//
//  ChatViewController.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController()
@end

@implementation ChatViewController

-(id)initWithOther:(Device *)other {
    self= [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.other= other; chatFetchedResultsController= [self chatFetchedResultsController];
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
    title.text= @"Chat";
    [self.view addSubview:title];
    
    UIButton *backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(fireBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame= CGRectMake(0.0, 20.0, 50.0, 50.0);
    [backBtn setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    chatTableView= [[UITableView alloc] initWithFrame:CGRectMake(0.0, 70.0, width, height- 120.0) style:UITableViewStylePlain];
    chatTableView.backgroundColor= [UIColor whiteColor];
    chatTableView.delegate= self;
    chatTableView.dataSource= self;
    chatTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:chatTableView];
    
    bottom= [[UIView alloc] initWithFrame:CGRectMake(0.0, height- 50.0, width, 50.0)];
    bottom.userInteractionEnabled= YES;
    bottom.backgroundColor= [UIColor grayColor];
    [self.view addSubview:bottom];
    
    UIView *text= [[UIView alloc] initWithFrame:CGRectMake(5.0, 5.0, width- 70.0, 40.0)];
    text.backgroundColor= [UIColor whiteColor];
    [bottom addSubview:text];
    
    field= [[UITextField alloc] initWithFrame:CGRectMake(10.0, 0.0, width- 80.0, 40.0)];
    field.keyboardAppearance= UIKeyboardAppearanceDark;
    field.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    field.autocorrectionType= UITextAutocorrectionTypeYes;
    field.font= [UIFont systemFontOfSize:22.0];
    field.returnKeyType= UIReturnKeySend;
    field.placeholder= @"Ask me about Cloudilly";
    field.delegate= self;
    [text addSubview:field];
    
    UIButton *sendBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(fireSend) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font= [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:22.0];
    sendBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentCenter;
    sendBtn.frame= CGRectMake(width- 60.0, 0.0, 60.0, 50.0);
    [bottom addSubview:sendBtn];
    [self.view addSubview:bottom];
}

-(void)fireBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideChatView" object:nil];
}

-(void)fireSend {
    if(field.text.length== 0) { return; }
    [self storeMessage:field.text ToGroup:self.other.username];
    field.text= @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(field.text.length== 0) { return NO; }
    [self storeMessage:field.text ToGroup:self.other.username];
    field.text= @"";
    return NO;
}

-(void)storeMessage:(NSString *)msg ToGroup:(NSString *)group {
    // INSTEAD OF USING 'POST' METHOD THAT SENDS OUT A TRANSIENT MESSAGE, WE USE THE MORE PERSISTENT 'STORE' METHOD
    // MESSAGE IS STORED AT CLOUDILLY UNTIL THE RECIPIENT RECEIVES AND ISSUES OUT A SUBSUENT 'REMOVE' METHOD
    NSMutableDictionary *payload= [[NSMutableDictionary alloc] init]; [payload setObject:msg forKey:@"msg"];
    [[self appDelegate].cloudilly storeGroup:group WithPayload:payload WithCallback:^(NSDictionary *dict) {
        NSLog(@"@@@@@@ STORE");
        NSLog(@"%@", dict);
        
        // SENDS OUT PUSH NOTIFICATION TO REGISTERED DEVICES LINKED TO GROUP
        NSString *shortSender= [[group componentsSeparatedByString:@"::"][1] componentsSeparatedByString:@"-"][0];
        [[self appDelegate].cloudilly notify:[NSString stringWithFormat:@"%@: %@", shortSender, msg] Group:group WithCallback:^(NSDictionary *dict) {
            NSLog(@"@@@@@@ NOTIFY");
            NSLog(@"%@", dict);
        }];
    }];
}

-(CGFloat)returnMsgHeight:(NSString *)msg {
    NSDictionary *attributeNormal= [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:18.0] forKey:NSFontAttributeName];
    return [msg boundingRectWithSize:CGSizeMake(width- 20.0, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeNormal context:nil].size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post= [chatFetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    return indexPath.row== 0 ? [self returnMsgHeight:post.msg]+ 20.0 : [self returnMsgHeight:post.msg]+ 10.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return chatFetchedResultsController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PostCellIdentifier= @"PostCellIdentifier";
    UITableViewCell *postCell= [tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
    if(postCell== nil) { postCell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostCellIdentifier]; }
    Post *post= [chatFetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    NSString *shortSender= [[post.sender componentsSeparatedByString:@"::"][1] componentsSeparatedByString:@"-"][0];
    postCell.textLabel.text= [NSString stringWithFormat:@"%@: %@", shortSender, post.msg];
    postCell.textLabel.textColor= [UIColor grayColor];
    postCell.textLabel.numberOfLines= 0;
    return postCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSFetchedResultsController *)chatFetchedResultsController {
    NSManagedObjectContext *context= [[self appDelegate].database managedObjectContext];
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"sender== %@ || recipient== %@", self.other.username, self.other.username];
    NSSortDescriptor *sort= [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *sortDescriptors= [NSArray arrayWithObjects:sort, nil];
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    request.entity= entity; request.predicate= predicate; request.sortDescriptors= sortDescriptors;
    chatFetchedResultsController= [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    chatFetchedResultsController.delegate= self; [chatFetchedResultsController performFetch:nil];
    return chatFetchedResultsController;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [chatTableView reloadData];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame= [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight= height- keyboardFrame.origin.y;
    double duration= [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        chatTableView.frame= CGRectMake(0.0, 70.0, width, height- 70.0- 49.0- keyboardHeight);
        bottom.frame= CGRectMake(0.0, height- 50.0- keyboardHeight, width, 50.0);
        [self scrollToBottom];
    }];
}

-(void)scrollToBottom {
    if(chatTableView.contentSize.height< chatTableView.frame.size.height) { return; }
    double delayInSeconds= 0.1; dispatch_time_t popTime= dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        CGPoint offset= CGPointMake(0, chatTableView.contentSize.height- chatTableView.frame.size.height);
        [chatTableView setContentOffset:offset animated:YES];
    });
}

-(AppDelegate *)appDelegate { return (AppDelegate *)[[UIApplication sharedApplication] delegate]; }
-(UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
-(void)viewDidLoad { [super viewDidLoad]; }
-(void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
