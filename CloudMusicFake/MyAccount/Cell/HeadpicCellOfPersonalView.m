//
//  HeadpicCellOfPersonalView.m
//  WYY
//
//  Created by OurEDA on 2018/5/13.
//  Copyright © 2018年 123. All rights reserved.
//

#import "HeadpicCellOfPersonalView.h"

@implementation HeadpicCellOfPersonalView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
//        CGFloat cellWidth = self.frame.size.width;
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat cellWidth = screen.size.width;
        
        CGFloat imageViewWidth = 40;
        CGFloat imageViewHeight = 40;
        
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth - 85, 10, imageViewWidth, imageViewHeight)];
        self.myImageView.layer.masksToBounds = YES;
        self.myImageView.layer.cornerRadius = imageViewWidth / 2.0f;
        
        [self addSubview:self.myImageView];
        
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, cellWidth - 120, 20)];
        self.myLabel.font = [UIFont systemFontOfSize:20];
        
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
