//
//  LearnProgrammsViewController.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "LearnProgrammsViewController.h"
#import <FretXBLE/FretXBLE-Swift.h>
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>

#import "ProgrammTableCell.h"

//Chord Exercicises", @"Custom Chord Exercices",@"Chords", @"Scale Exercicises"];
typedef enum {
    ProgrammChordExercicises,
    ProgrammCustomChordExercices,
    ProgrammChords,
    ProgrammScaleExercicises
}Programm;

@interface LearnProgrammsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak) IBOutlet UITableView* tableView;

//data
@property (strong) NSArray<NSString*>* programmTitles;
@property (strong) NSArray<NSString*>* programmSubtitles;

@end

@implementation LearnProgrammsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layout];
}

- (void) viewDidAppear:(BOOL)animated{
    [FretxBLE.sharedInstance clear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)layout{
    
    self.programmTitles = @[@"Chord Exercises", @"Custom Chord Exercises",@"Chord Library", @"Scale Library"];
    self.programmSubtitles = @[@"Start learning with our guided exercises",
                               @"Build your own training session",
                               @"Learn all chords",
                               @"Practice scales and improvisation"];
    
    [self.tableView reloadData];
}

- (UIImage*)imageForIndexPath:(NSIndexPath*)indexPath{
    
    UIImage* image = nil;
    switch (indexPath.row) {
        case ProgrammChordExercicises:
            image = [UIImage imageNamed:@"ChordExercisesBG"];
            break;
        case ProgrammCustomChordExercices:
            image = [UIImage imageNamed:@"CustomChordBG"];
            break;
        case ProgrammChords:
            image = [UIImage imageNamed:@"ChordsBG"];
            break;
        case ProgrammScaleExercicises:
            image = [UIImage imageNamed:@"ScaleExercisesBG"];
            break;
        default:
            break;
    }
    
    return image;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.programmTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* title = self.programmTitles[indexPath.row];
    NSString* subtitle = self.programmSubtitles[indexPath.row];
    
    static NSString* cellID = @"ProgrammTableCell";
    ProgrammTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell setTitle:title subtitle:subtitle image:[self imageForIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case ProgrammChordExercicises:
            [self performSegueWithIdentifier:kChordExercisesSegue sender:self];
            break;
        case ProgrammCustomChordExercices:
            [self performSegueWithIdentifier:kCustomChordSegue sender:self];
            break;
        case ProgrammChords:
            [self performSegueWithIdentifier:kChordsSegue sender:self];
            break;
        case ProgrammScaleExercicises:
            [self performSegueWithIdentifier:kScaleExercisesSegue sender:self];
            break;
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView.frame.size.height/self.programmTitles.count;
}


@end
