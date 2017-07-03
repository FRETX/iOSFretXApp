//
//  MelodiesViewController.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MelodiesViewController.h"

#import "MelodyChordsViewController.h"
#import "MelodyTableCell.h"
#import "UIView+Activity.h"
#import "RequestManager.h"
#import "Lesson.h"
#import "Melody.h"

#define kMelodyLessonSegue @"MelodyLessonSegue"

@interface MelodiesViewController () <UITableViewDelegate, UITableViewDataSource>

//UI
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityView;

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
    [self getContent];
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
    
    if ([segue.identifier isEqualToString:kMelodyLessonSegue]) {
        
        if (self.mellodyLesson) {
            MelodyChordsViewController* chordsViewController = (MelodyChordsViewController*)segue.destinationViewController;
            [chordsViewController setupLesson:self.mellodyLesson];
            self.mellodyLesson = nil;
        }
    }
}

#pragma mark - Submethods

- (void)getContent{
    
    __weak typeof(self) weakSelf = self;
    [[RequestManager defaultManager] loadAllMelodiesWithBlock:^(NSArray<Melody*>* result, NSError *error) {
        
        [self.view hideActivity];
        if (!error) {
            weakSelf.melodies = [weakSelf sortedArrayWithArray:result];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSArray<Melody*>*)sortedArrayWithArray:(NSArray<Melody*>*)array{
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    NSArray* sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

- (void)reloadContent{
    [self.tableView reloadData];
}

- (void)resetSelectedMelody{
    self.mellodyLesson = nil;
}

#pragma mark - Actions



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
    
    __weak typeof(self) weakSelf = self;
    Melody* melody = self.melodies[indexPath.row];
    
    [self.view showActivity];
    [[RequestManager defaultManager] getLessonForMelody:melody withBlock:^(Lesson* lesson, NSError *error) {
        
        if (lesson) {
            weakSelf.mellodyLesson = lesson;
            [weakSelf performSegueWithIdentifier:kMelodyLessonSegue sender:weakSelf];
        }
        [weakSelf.view hideActivity];
    }];
}

@end
