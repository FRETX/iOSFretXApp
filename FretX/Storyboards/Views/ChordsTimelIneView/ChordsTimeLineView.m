//
//  ChordsTimeLineView.m
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordsTimeLineView.h"

#import "ChordCollectionViewCell.h"
#import "Chord.h"

#define kOneSecondWidth 85.f // pixels per 1 second

@interface ChordsTimeLineView () <UICollectionViewDelegate, UICollectionViewDataSource>

//ui
@property (weak) IBOutlet UICollectionView* collectionView;

//data
@property (nonatomic, strong) NSArray<Chord*>* chords;
@property (assign) NSUInteger currentChordIndex;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation ChordsTimeLineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.currentChordIndex = 0;
    
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
    
//    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ChordCollectionViewCell"
//                                                      owner:self
//                                                    options:nil];
//    [self.collectionView registerNib:[nibViews firstObject] forCellWithReuseIdentifier:@"ChordCollectionViewCell"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChordCollectionViewCell"];
    
}

#pragma mark - Public

- (void)setupWithDuration:(float)duration chords:(NSArray<Chord*>*)chords{
    
    if (chords.count <= 0) {
        return;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.timeMs > 0"];
    NSArray<Chord*>* filteredChords = [chords filteredArrayUsingPredicate:predicate];
    self.chords = filteredChords;
//    self.chords = chords;
    
    [self.collectionView reloadData];

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
    self.collectionView.contentOffset = CGPointMake(currentPoint.x + 1, currentPoint.y);
    
}

#pragma mark - Private

- (float)chordViewWidthForIndex:(NSUInteger)index{
    
    Chord* chord = [self.chords objectAtIndex:index];
    
    Chord* prevChord;
    if (index >= self.chords.count || index == 0) {
        prevChord = nil;
    } else{
        prevChord = [self.chords objectAtIndex:index-1];
    }
    
    float timeMS = prevChord ? chord.timeMs - prevChord.timeMs : chord.timeMs;
    
    float width = (timeMS/1000) * kOneSecondWidth;
    
    return width;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.chords.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Chord* chord = self.chords[indexPath.row];
    static NSString* identifier = @"ChordCollectionViewCell";
    ChordCollectionViewCell* cell = (ChordCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    BOOL selected = self.currentChordIndex == indexPath.row ? YES : NO;
    [cell setupWithChordName:chord.chordName selected:selected];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    ChordCollectionViewCell* nextCell = (ChordCollectionViewCell*)[collectionView cellForItemAtIndexPath:nextIndexPath];
    [nextCell setSelected:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = [self chordViewWidthForIndex:indexPath.row];
    return CGSizeMake(width, self.frame.size.height);
}


@end
