//
//  LoginViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/27/22.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
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

- (BOOL)areFieldsEmpty {
    return ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]);
}

- (void)emptyFieldAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Fields" message:@"There are empty fields" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    // Add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)swapRootVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *feedNVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.view.window.rootViewController = feedNVC;
}

- (void)parseSignup: (PFUser *)user {
    // call sign up function on the object
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User registered successfully");
            
            [self swapRootVC];
        }
    }];
}

- (void)parseLogin: (NSString *)username: (NSString *)password {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            [self swapRootVC];
        }
    }];
}

- (IBAction)registerUser:(id)sender {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
    
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [self areFieldsEmpty] ? [self emptyFieldAlert] : [self parseSignup:newUser];
}

- (IBAction)loginUser:(id)sender {
    [self areFieldsEmpty] ? [self emptyFieldAlert] : [self parseLogin: self.usernameField.text :self.passwordField.text];
}
@end
