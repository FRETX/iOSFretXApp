//
//  LearnProgrammsViewController.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "LearnProgrammsViewController.h"
#import <FretXBLE/FretXBLE-Swift.h>
#import <FretXAudioProcessing/FretXAudioProcessing.h>

@interface LearnProgrammsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak) IBOutlet UITableView* tableView;

//data
@property (strong) NSArray* programmTitles;
@property (strong) NSArray* programmSubtitles;

@end

@implementation LearnProgrammsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Scale * sc = [Scale new];
    Chord* ch = [Chord alloc] init;
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
    
    self.programmTitles = @[@"", @"",@"", @""];
    self.programmSubtitles = @[@"", @"",@"", @""];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}





@end
