//
//  UserCell.m
//  oneonone
//
//  Created by Zhongcai Ng on 7/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        CGFloat width= [[UIScreen mainScreen] bounds].size.width;
        self.backgroundView= [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor= [UIColor clearColor];
        self.selectedBackgroundView= [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor= [UIColor clearColor];
        
        self.username= [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, width- 10.0, 20.0)];
        self.username.backgroundColor= [UIColor clearColor];
        self.username.font= [UIFont boldSystemFontOfSize:19.0];
        self.username.textColor= [UIColor grayColor];
        self.username.textAlignment= NSTextAlignmentCenter;
        [self.contentView addSubview:self.username];
        
        self.status= [[UILabel alloc] initWithFrame:CGRectMake(5.0, 25.0, width- 10.0, 20.0)];
        self.status.backgroundColor= [UIColor clearColor];
        self.status.font= [UIFont italicSystemFontOfSize:16.0];
        self.status.textColor= [UIColor grayColor];
        self.status.textAlignment= NSTextAlignmentCenter;
        [self.contentView addSubview:self.status];
        
        self.last= [[UILabel alloc] initWithFrame:CGRectMake(5.0, 45.0, width- 10.0, 15.0)];
        self.last.backgroundColor= [UIColor clearColor];
        self.last.font= [UIFont fontWithName:@"Avenir-LightOblique" size:10.0];
        self.last.textColor= [UIColor grayColor];
        self.last.textAlignment= NSTextAlignmentCenter;
        [self.contentView addSubview:self.last];
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end