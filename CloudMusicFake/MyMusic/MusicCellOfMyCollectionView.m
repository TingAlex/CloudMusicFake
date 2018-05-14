//
//  MusicCellOfMyCollectionView.m
//  WYY
//
//  Created by OurEDA on 2018/5/12.
//  Copyright © 2018年 123. All rights reserved.
//

#import "MusicCellOfMyCollectionView.h"

@interface MusicCellOfMyCollectionView ()

@end

@implementation MusicCellOfMyCollectionView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
//        CGFloat cellWidth = self.frame.size.width;
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat cellWidth = screen.size.width;

        CGFloat imageViewWidth = 25;
        CGFloat imageViewHeight = 25;

        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth - 40, 12.5, imageViewWidth, imageViewHeight)];

        [self addSubview:self.myImageView];

        self.myLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, cellWidth - 80, 25)];
        self.myLabel1.font = [UIFont systemFontOfSize:20];
        self.myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, cellWidth - 80, 15)];
        self.myLabel2.font = [UIFont systemFontOfSize:14];
        self.myLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.myLabel3.font = [UIFont systemFontOfSize:20];
        self.myLabel3.textAlignment = UITextAlignmentCenter;

        [self addSubview:self.myLabel1];
        [self addSubview:self.myLabel2];
        [self addSubview:self.myLabel3];
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
