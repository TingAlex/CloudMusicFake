//
//  OneCell.m
//  WYY
//
//  Created by OurEDA on 2018/5/13.
//  Copyright © 2018年 123. All rights reserved.
//

#import "OneCell.h"

@implementation OneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
//        CGFloat cellWidth = self.frame.size.width;
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat cellWidth = screen.size.width;
        
        CGFloat imageViewWidth = 90;
        CGFloat imageViewHeight = 90;
        
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, imageViewWidth, imageViewHeight)];
        self.myImageView.layer.masksToBounds = YES;
        self.myImageView.layer.cornerRadius = imageViewWidth / 2.0f;
        
        [self addSubview:self.myImageView];
        
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, cellWidth - 120, 30)];
        self.myLabel.font = [UIFont systemFontOfSize:30];
        
        [self addSubview:self.myLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
