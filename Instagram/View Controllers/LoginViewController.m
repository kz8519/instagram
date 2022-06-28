//
//  LoginViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/27/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "FeedViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginUser:(id)sender;
- (IBAction)registerUser:(id)sender;

@end

@implementation LoginViewController

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

- (IBAction)registerUser:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    // If the username or password field is empty, alert the user
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Fields" message:@"There are empty fields" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
        }];
        
        // add the OK action to the alert controller
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    else { // Otherwise, call sign-up function on the object
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
//                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                // Swap window root view controller
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FeedViewController *feedNVC = [storyboard instantiateViewControllerWithIdentifier:@"FeedNavigationViewController"];
                self.view.window.rootViewController = feedNVC;
            }
        }];
    }
}

- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // If the username or password field is empty, alert the user
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Fields" message:@"There are empty fields" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
        }];
        
        // add the OK action to the alert controller
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    else { // Otherwise, log the user in
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
                
                // display view controller that needs to shown after successful login
//                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                
                
                
                // TODO: sync login with logout (these three lines are what logout uses; either change login to this, or change logout to the one-line dismiss view) (same deal above)
                // Swap window root view controller
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FeedViewController *feedNVC = [storyboard instantiateViewControllerWithIdentifier:@"FeedNavigationViewController"];
                self.view.window.rootViewController = feedNVC;
                
            }
        }];
    }
}
@end
