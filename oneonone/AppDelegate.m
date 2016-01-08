//
//  AppDelegate.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.database= [[Database alloc] init];
    self.window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor= [UIColor clearColor];
    self.publicViewController= [[PublicViewController alloc] init];
    self.window.rootViewController= self.publicViewController;
    [self.window makeKeyAndVisible];
    
    NSString *app= @"<GET YOUR APP NAME AT CLOUDILLY.COM>";
    NSString *access= @"<GET YOUR ACCESS KEY AT CLOUDILLY.COM>";
    self.cloudilly= [[Cloudilly alloc] initWithApp:app AndAccess:access WithCallback:^(void) {
        [self.cloudilly connect];
    }];
    [self.cloudilly addDelegate:self];
    
    return YES;
}

-(void)socketConnected:(NSDictionary *)dict {
    if([[dict objectForKey:@"status"] isEqual: @"fail"]) { NSLog(@"%@", [dict objectForKey:@"msg"]); return; }
    NSLog(@"@@@@@@ CONNECTED");
    NSLog(@"%@", dict);
    
    [self.database hideAllDevices];
    NSString *device= [dict objectForKey:@"device"];
    NSString *username= [NSString stringWithFormat:@"username::%@", device];
    NSString *password= @"password";
    
    NSMutableDictionary *dictProfile= [[NSMutableDictionary alloc] init];
    [dictProfile setObject:device forKey:@"device"];
    [dictProfile setObject:username forKey:@"username"];
    [dictProfile setObject:password forKey:@"password"];
    [self.database updateProfile:dictProfile];
    
    [self.cloudilly joinGroup:@"public" WithCallback:^(NSDictionary *dict) {
        NSLog(@"@@@@@@ JOIN");
        NSLog(@"%@", dict);
    }];
    
    [self.cloudilly createGroup:username WithPassword:password WithCallback:^(NSDictionary *dict) {
        NSLog(@"@@@@@@ CREATE");
        NSLog(@"%@", dict);
        [self.cloudilly loginToUsername:username WithPassword:password WithCallback:^(NSDictionary *dict) {
            NSLog(@"@@@@@@ LOGIN");
            NSLog(@"%@", dict);
            [self.cloudilly linkGroup:username WithPassword:password WithCallback:^(NSDictionary *dict) {
                NSLog(@"@@@@@@ LINK");
                NSLog(@"%@", dict);
            }];
        }];
    }];
    
    UIUserNotificationSettings *settings= [UIUserNotificationSettings settingsForTypes:
                                           (UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)socketDisconnected {
    NSLog(@"@@@@@@ DISCONNECTED");
}

-(void)socketReceivedDevice:(NSDictionary *)dict {
    NSLog(@"@@@@@@ RECEIVED DEVICE");
    NSLog(@"%@", dict);
    
    Profile *profile= [self.database fetchProfile];
    if([profile.device isEqualToString:[dict objectForKey:@"device"]]) { return; }

    NSMutableDictionary *dictDevice= [[NSMutableDictionary alloc] init];
    [dictDevice setObject:[dict objectForKey:@"device"] forKey:@"device"];
    [dictDevice setObject:[NSNumber numberWithLongLong:[[dict objectForKey:@"timestamp"] longLongValue]] forKey:@"timestamp"];
    if([dict objectForKey:@"username"]) { [dictDevice setObject:[dict objectForKey:@"username"] forKey:@"username"]; }
    if([dict objectForKey:@"payload"]) { [dictDevice setObject:[[dict objectForKey:@"payload"] objectForKey:@"status"] forKey:@"status"]; }
    [self.database updateDevice:dictDevice];
}

-(void)socketReceivedPost:(NSDictionary *)dict {
    NSLog(@"@@@@@@ RECEIVED POST");
    NSLog(@"%@", dict);
    
    NSMutableDictionary *dictPost= [[NSMutableDictionary alloc] init];
    [dictPost setObject:[dict objectForKey:@"post"] forKey:@"post"];
    [dictPost setObject:[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]* 1000] forKey:@"timestamp"];
    [dictPost setObject:[dict objectForKey:@"device"] forKey:@"device"];
    [dictPost setObject:[dict objectForKey:@"recipient"] forKey:@"recipient"];
    [dictPost setObject:[dict objectForKey:@"sender"] forKey:@"sender"];
    [dictPost setObject:[[dict objectForKey:@"payload"] objectForKey:@"msg"] forKey:@"msg"];
    [self.database updatePost:dictPost];
    
    Profile *profile= [self.database fetchProfile];
    if([[dict objectForKey:@"sender"] isEqualToString:profile.username]) { return; }
    if([[dict objectForKey:@"timestamp"] isEqualToNumber:[NSNumber numberWithInt:0]]) { return; }
    
    [self.cloudilly removePost:[dict objectForKey:@"post"] WithCallback:^(NSDictionary *dict) {
        NSLog(@"@@@@@@ REMOVE");
        NSLog(@"%@", dict);
    }];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned *tokenBytes= [deviceToken bytes];
    NSString *token= [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                      ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]), ntohl(tokenBytes[3]),
                      ntohl(tokenBytes[4]), ntohl(tokenBytes[5]), ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];

    [self.cloudilly registerApns:token WithCallback:^(NSDictionary *dict) {
        NSLog(@"@@@@@@ REGISTER");
        NSLog(@"%@", dict);
    }];
}

-(void)applicationWillResignActive:(UIApplication *)application { }
-(void)applicationDidEnterBackground:(UIApplication *)application { }
-(void)applicationWillEnterForeground:(UIApplication *)application { }
-(void)applicationDidBecomeActive:(UIApplication *)application { }
-(void)applicationWillTerminate:(UIApplication *)application { }

@end