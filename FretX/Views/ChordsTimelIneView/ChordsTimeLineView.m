//
//  ChordsTimeLineView.m
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordsTimeLineView.h"

#import "ChordCollectionViewCell.h"
#import "SongPunch.h"

#define kOneSecondWidth 85.f // pixels per 1 second

@interface ChordsTimeLineView () <UICollectionViewDelegate, UICollectionViewDataSource>

//ui
@property (weak) IBOutlet UICollectionView* collectionView;

//data
@property (nonatomic, strong) NSArray<SongPunch*>* chords;
@property (assign) NSUInteger currentChordIndex;
@property (nonatomic, strong) NSTimer* timer;
@property (assign) float duration;

@property (assign) float advance;

@property (assign) float firstChordInset;;
@end

@implementation ChordsTimeLineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.currentChordIndex = 0;
    self.advance = 0;
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
    
//    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ChordCollectionViewCell"
//                                                      owner:self
//                                                    options:nil];
//    [self.collectionView registerNib:[nibViews firstObject] forCellWithReuseIdentifier:@"ChordCollectionViewCell"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChordCollectionViewCell"];
    
}

#pragma mark - Public

- (void)setupWithDuration:(float)duration chords:(NSArray<SongPunch*>*)chords{
    
    if (chords.count <= 0) {
        return;
    }

    self.chords = chords;
    self.duration = duration;
    
    float initialInset = [self offsetFromMSTime: chords.firstObject.timeMs];
    self.firstChordInset = initialInset;
    
    [self.collectionView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setHorizontalOffset:-initialInset];
    });
}

- (void)move{
    if (self.chords.count > 0) {
        [self startChordsTimer];
    }
}

- (void)stop{
    if (self.chords.count > 0) {
        [self stopChordsTimer];
    }
}

- (void)moveToTime:(float)time{
    
    float offset = [self offsetFromMSTime:time] - self.firstChordInset + [self offsetFromMSTime:self.advance];
//    float offset = [self offsetFromMSTime:time];
    [self setHorizontalOffset:offset];
    
    [self move];
}

- (void)setupChordsAdvance:(float)advance{
    self.advance = advance;
}

#pragma mark -

- (void)startChordsTimer{
    
    [self stopChordsTimer];
    
    float interval = 1 / kOneSecondWidth;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onFiredChordsTimer:) userInfo:nil repeats:YES];
    
}

- (void)stopChordsTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onFiredChordsTimer:(NSTimer*)timer{

    CGPoint currentPoint = self.collectionView.contentOffset;
    [self setHorizontalOffset:currentPoint.x + 1];
}

#pragma mark - Private

- (void)setHorizontalOffset:(float)offset{
    self.collectionView.contentOffset = CGPointMake(offset, 0);
}

- (float)offsetFromMSTime:(float)time{
    float offset = (time/1000) * kOneSecondWidth;
    return offset;
}

- (float)chordViewWidthForIndex:(NSUInteger)index{
    
    SongPunch* chord = [self.chords objectAtIndex:index];
    
    SongPunch* nextChord;
    if (index >= (self.chords.count-1) ) {
        nextChord = nil;
    } else{
        nextChord = [self.chords objectAtIndex:index+1];
    }
    
    float timeMS = nextChord ? nextChord.timeMs - chord.timeMs : (self.duration - chord.timeMs);
    
    float width = (timeMS/1000) * kOneSecondWidth;
    
    return width;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.chords.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SongPunch* chord = self.chords[indexPath.row];
    static NSString* identifier = @"ChordCollectionViewCell";
    ChordCollectionViewCell* cell = (ChordCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    BOOL selected = self.currentChordIndex == indexPath.row ? YES : NO;
    [cell setupWithChordName:chord.chordName selected:selected];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    ChordCollectionViewCell* nextCell = (ChordCollectionViewCell*)[collectionView cellForItemAtIndexPath:nextIndexPath];
    [nextCell setSelectedStatus:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = [self chordViewWidthForIndex:indexPath.row];
    return CGSizeMake(width, self.collectionView.frame.size.height);
}


@end
