//
//  TunerViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "TunerViewController.h"
#import <FretXBLE/FretXBLE-Swift.h>

typedef enum {
    StringTypNone = 0,
    StringTypeA,
    StringTypeB,
    StringTypeD,
    StringTypeG,
    StringTypeELeft,
    StringTypeERight
}StringType;

@interface TunerViewController ()

@property (weak) IBOutlet UIImageView* imageView;

@end

@implementation TunerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupString:StringTypNone];
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

#pragma mark - 

- (UIImage*)imageForString:(StringType)stringType{
    
    NSString* imageName = @"EmptyGuitarHeadBG";
    UIImage* image = nil;
    switch (stringType) {
        case StringTypeA:
            imageName = @"A";
            break;
        case StringTypeB:
            imageName = @"B";
            break;
        case StringTypeD:
            imageName = @"D";
            break;
        case StringTypeG:
            imageName = @"G";
            break;
        case StringTypeELeft:
            imageName = @"Eleft";
            break;
        case StringTypeERight:
            imageName = @"Eright";
            break;
            
        default:
            break;
    }
    image = [UIImage imageNamed:imageName];
    return image;
}

- (void)setupString:(StringType)stringType{
    
    UIImage* image = [self imageForString:stringType];
    self.imageView.image = image;
}

#pragma mark - Actions

- (IBAction)onStringSetButton:(UIButton*)sender{
    
    StringType stringType = (StringType)sender.tag;
    [self setupString:stringType];
}

@end
