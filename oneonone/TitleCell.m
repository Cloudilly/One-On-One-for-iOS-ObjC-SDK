//
//  TitleCell.m
//  oneonone
//
//  Created by Zhongcai Ng on 6/1/16.
//  Copyright © 2016 Cloudilly Private Limited. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        CGFloat width= [[UIScreen mainScreen] bounds].size.width;
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        self.backgroundColor= [UIColor clearColor];
        
        self.label= [[UILabel alloc] initWithFrame:CGRectMake(5.0, 20.0, width- 10.0, 20.0)];
        self.label.backgroundColor= [UIColor clearColor];
        self.label.font= [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:14.0];
        self.label.textColor= [UIColor grayColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end