//
//  MusicCellOfMyCollectionView.m
//  WYY
//
//  Created by OurEDA on 2018/5/12.
//  Copyright © 2018年 123. All rights reserved.
//

#import "MusicCellOfMyCollectionView.h"

@implementation MusicCellOfMyCollectionView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellWidth = self.frame.size.width;
        CGFloat imageViewWidth = 50;
        CGFloat imageViewHeight = 50;
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth - imageViewWidth - 10, 10, imageViewWidth, imageViewHeight)];
        [self addSubview:self.myImageView];
        self.myLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cellWidth - 80, 25)];
        self.myLabel1.font = [UIFont systemFontOfSize:20];
        self.myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, cellWidth - 80, 15)];
        self.myLabel2.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.myLabel1];
        [self addSubview:self.myLabel2];
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
