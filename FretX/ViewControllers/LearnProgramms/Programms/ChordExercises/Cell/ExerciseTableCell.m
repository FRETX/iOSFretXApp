//
//  ExerciseTableCell.m
//  FretX
//
//  Created by Developer on 7/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ExerciseTableCell.h"

#import "ChordExercise.h"
#import "SongPunch.h"

@interface ExerciseTableCell ()

@property (weak) IBOutlet UILabel* nameLabel;
@property (weak) IBOutlet UILabel* descriptionLabel;
@end

@implementation ExerciseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupChordExercise:(ChordExercise*)chordExercise{
    
    self.nameLabel.text = chordExercise.exerciseName;
    self.descriptionLabel.text = [NSString stringWithFormat:@"Chord: %@", [self allChordsStringFromExercise:chordExercise]];
}

- (NSString*)allChordsStringFromExercise:(ChordExercise*)chordExercise{
    
    NSMutableString* mutResult = [NSMutableString new];
    [chordExercise.chords enumerateObjectsUsingBlock:^(SongPunch * _Nonnull songPunch, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* coma = (chordExercise.chords.count - 1) == idx ? @"" : @" ";
        NSString* chordItem = [songPunch.chordName stringByAppendingString:coma];
        [mutResult appendString:chordItem];
    }];
    NSString* result = [NSString stringWithString:mutResult];
    return result;
}

@end
