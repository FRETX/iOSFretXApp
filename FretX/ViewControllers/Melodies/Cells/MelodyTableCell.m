//
//  MelodyTableCell.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MelodyTableCell.h"

#import <UIImageView+AFNetworking.h>
#import "Melody.h"

@interface MelodyTableCell ()

@property (nonatomic, weak) IBOutlet UIImageView* songImageView;
@property (nonatomic, weak) IBOutlet UILabel* songNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* artistNameLabel;

@end

@implementation MelodyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupMelody:(Melody*)melody{
    
    //self.songImageView.image = [UIImage imageNamed:@"DefaultThumb"];
    self.songNameLabel.text = melody.songName;
    self.artistNameLabel.text = melody.artistName;
    
    NSString * youtubeID = melody.youtubeVideoId;
    NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youtubeID]];
                         
    [self.songImageView setImageWithURL:youtubeURL placeholderImage:[UIImage imageNamed:@"DefaultThumb"]];
}

@end
