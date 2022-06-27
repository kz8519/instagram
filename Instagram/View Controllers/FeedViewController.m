//
//  FeedViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/27/22.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>


@interface FeedViewController ()
- (IBAction)logoutUser:(id)sender;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
            NSLog(@"User logged out successfully");
        }
        
    }];
}
@end
