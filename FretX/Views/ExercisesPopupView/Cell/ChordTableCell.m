//
//  ChordTableCell.m
//  FretX
//
//  Created by Developer on 7/12/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordTableCell.h"

#import "SongPunch.h"

@class SongPunch;

@interface ChordTableCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
//data
@property (strong) SongPunch* songPunch;
@property (weak) IBOutlet UIButton *removeButton;
@end

@implementation ChordTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSongPunch:(SongPunch*)songPunch{
    self.removeButton.hidden = NO;
    self.nameLabel.text = songPunch.chordName;
    self.songPunch = songPunch;
}

- (void)seExerciseName:(NSString*)name{
    self.nameLabel.text = name;
    self.removeButton.hidden = YES;
}

#pragma mark - Actions

- (IBAction)onDeleteButton:(UIButton*)sender{
    
    if (self.didTapDeleteChord) {
        self.didTapDeleteChord(self.songPunch);
    }
}

@end
