//
//  MainTabBarController.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIViewController+Alerts.h"
@import Firebase;
@import FBSDKCoreKit;
@import FBSDKLoginKit;

typedef enum{
    TabIconMelodies,
    TabIconLearn,
    TabIconTuner,
    TabIconSettings
}TabIcon;

@interface MainTabBarController () <UITabBarControllerDelegate, UITabBarDelegate>
{
    FIRDatabaseReference *dbRef;
    NSString *currentUID;
    AppDelegate *app;
    MBProgressHUD *hud;
    
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    [self storePrefs];
    
    [self hideNavigationBarbutton];
    [self customizeTabBarItems];
  
}

- (void) storePrefs
{
    // default values Handedness=right , skill level=beginner , guitar type=classical
    currentUID =[[[FIRAuth auth]currentUser]uid];
    dbRef = [[[[[FIRDatabase database] reference] child: @"users"] child: currentUID] child:@"prefs"];
    if (dbRef == nil) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"right", @"hand",
                             @"classical", @"guitar",
                             @"beginner", @"level", nil];
        [dbRef setValue: dic];
    }
    
}

- (void) showLoading: (NSString *) message
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideNavigationBarbutton
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


#pragma mark - Submethods

- (void)customizeTabBarItems{
    //set font
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                                                        NSForegroundColorAttributeName:[UIColor blackColor]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    
}


#pragma mark - UITabBarControllerDelegate
//
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
//    for(UITabBarItem * tabBarItem in self.tabBar.items){
//        tabBarItem.imageInsets = UIEdgeInsetsMake(3, 3, 3, 3);
//    }
//    return YES;
//}
//
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    for(UITabBarItem * tabBarItem in self.tabBar.items){
//        tabBarItem.imageInsets = UIEdgeInsetsMake(3, 3, 3, 3);
//    }
//}


@end
