//
//  NicknameCellOfPersonalView.m
//  WYY
//
//  Created by OurEDA on 2018/5/13.
//  Copyright © 2018年 123. All rights reserved.
//

#import "NicknameCellOfPersonalView.h"

@implementation NicknameCellOfPersonalView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
//        CGFloat cellWidth = self.frame.size.width;
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat cellWidth = screen.size.width;
        
        self.myLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - 175, 20, 130, 20)];
        self.myLabel_2.font = [UIFont systemFontOfSize:20];
        self.myLabel_2.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.myLabel_2];
        
        self.myLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, cellWidth - 150, 20)];
        self.myLabel_1.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.myLabel_1];
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
