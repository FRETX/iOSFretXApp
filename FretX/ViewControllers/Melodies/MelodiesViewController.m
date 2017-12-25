//
//  MelodiesViewController.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MelodiesViewController.h"

#import "MelodyChordsViewController.h"
#import "PlayYoutubeViewController.h"
#import "NavigationManager.h"
#import "MelodyTableCell.h"
#import "UIView+Activity.h"
#import "RequestManager.h"
#import "ContentManager.h"
#import "Lesson.h"
#import "Melody.h"
#import "SongPunch.h"
#import <FretXBLE/FretXBLE-Swift.h>
@import FirebaseAnalytics;

@interface MelodiesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

//UI
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityView;
@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* searchBarTopConstraint;
//Data
@property (nonatomic, strong) NSArray<Melody*>* melodies;
//@property (assign) NSInteger selectedMelodyRowIndex;
@property (strong) Lesson* mellodyLesson;
@property (nonatomic, weak) MelodiesViewController* weakSelf;

@end

@implementation MelodiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view showActivity];
    [self hideSearchBarAnimated:NO];
    [self getContent];
}

- (void) viewDidAppear:(BOOL)animated{
    [FretxBLE.sharedInstance clear];
    printf("play tab\n");
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:@"Play",
                                     kFIRParameterItemName:@"Play",
                                     kFIRParameterContentType:@"TAB"
                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //open chords lesson
    if ([segue.identifier isEqualToString:kMelodyLessonSegue]) {
        
        if (self.mellodyLesson) {
            MelodyChordsViewController* chordsViewController = (MelodyChordsViewController*)segue.destinationViewController;
            [chordsViewController setupLesson:self.mellodyLesson];
            self.mellodyLesson = nil;
        }
    }
    
    //open chords video lesson
    if ([segue.identifier isEqualToString:kOpenPlayYoutubeSegueID]) {
        
        PlayYoutubeViewController* playYoutubeController = segue.destinationViewController;
        [playYoutubeController setupLesson:self.mellodyLesson];
    }
}

#pragma mark - Submethods

- (void)getContent{
    
    __weak typeof(self) weakSelf = self;
    [[ContentManager defaultManager] getAllSongsWithBlock:^(NSArray<Melody*>* result, NSError *error) {
        
        [self.view hideActivity];
        if (!error) {
            weakSelf.melodies = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)reloadContent{
    [self.tableView reloadData];
}

- (void)resetSelectedMelody{
    self.mellodyLesson = nil;
}

- (void)openLesson:(Lesson*)lesson{
    
    self.mellodyLesson = lesson;
    if ([NavigationManager defaultManager].needToOpenPreviewScreen) {
        [self performSegueWithIdentifier:kMelodyLessonSegue sender:self];
    } else{
        [self performSegueWithIdentifier:kOpenPlayYoutubeSegueID sender:self];
    }
}

- (void)searchForTitle:(NSString*)title{
    
    __weak typeof(self) weakSelf = self;
    [[ContentManager defaultManager] searchSongsForTitle:title withBlock:^(NSArray<Melody *> *result, NSError *error) {
        
        weakSelf.melodies = result;
        [weakSelf reloadContent];
    }];
}

- (void)showSearchBarAnimated:(BOOL)animated{
    
    self.searchBar.hidden = NO;
    self.searchBarTopConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)hideSearchBarAnimated:(BOOL)animated{
    
    self.searchBarTopConstraint.constant = -self.searchBar.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.searchBar.hidden = YES;
        [self.view endEditing:YES];
    }];
}

#pragma mark - Actions

- (void)onSearchButton:(UIBarButtonItem*)sender{
    
    if (self.searchBar.hidden) {
        [self showSearchBarAnimated:YES];
    } else{
        [self hideSearchBarAnimated:YES];
    }
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self searchForTitle:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self hideSearchBarAnimated:YES];
    [self.view endEditing:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.melodies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellID = @"MelodyTableCell";
    MelodyTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    Melody* melody = self.melodies[indexPath.row];
    [cell setupMelody:melody];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    Melody* melody = self.melodies[indexPath.row];
    
    [self.view showActivity];
    [[ContentManager defaultManager] getLessonForSong:melody withBlock:^(Lesson* lesson, NSError *error) {
        
        if (lesson) {
            [self openLesson:lesson];
        }
        [weakSelf.view hideActivity];
    }];
}

//- (NSString*)nextLessonYoutubeIDForLesson:(Lesson*)lesson{
//    
//    NSString* lessonFretxID = lesson.fretxID;
//    
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.fretxID like[c] %@",lessonFretxID];
//    NSArray* filteredArray = [self.melodies filteredArrayUsingPredicate:predicate];
//    
//    Melody* song;
//    if (filteredArray.count > 0) {
//        song = filteredArray.firstObject;
//    }
//    
//    NSUInteger nextIndex = [self.melodies indexOfObject:song] + 1;
//    if (song && nextIndex < self.melodies.count) {
//        Melody* nextSong = [self.melodies objectAtIndex:nextIndex];
//        return nextSong.youtubeVideoId;
//    } else{
//        return self.melodies.firstObject.youtubeVideoId;
//    }
//}

@end
