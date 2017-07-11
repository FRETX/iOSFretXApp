//
//  ProgrammTableCell.m
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ProgrammTableCell.h"

@interface ProgrammTableCell ()

@property (weak) IBOutlet UILabel* titleLabel;
@property (weak) IBOutlet UILabel* subtitleLabel;
@property (weak) IBOutlet UIImageView* bgImageView;
@end

@implementation ProgrammTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image{
    
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
    
    self.bgImageView.image = image;
}

@end
