//
//  ChordTableCell.h
//  FretX
//
//  Created by Developer on 7/12/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongPunch;

@interface ChordTableCell : UITableViewCell

@property (copy) void (^didTapDeleteChord)(SongPunch* songPunch);

- (void)setupSongPunch:(SongPunch*)songPunch;
- (void)seExerciseName:(NSString*)name;
@end
