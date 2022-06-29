//
//  ProfileViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

#import "ProfileViewController.h"
@import Parse;

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
- (IBAction)changeProfilePhoto:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *user = [PFUser currentUser];
    if (user[@"profilePicture"] != nil) {
        self.profileImageView.file = user[@"profilePicture"];
        [self.profileImageView loadInBackground];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeProfilePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = [self resizeImage:originalImage withSize:self.profileImageView.bounds.size];

    // Do something with the images (based on your use case)
    [self.profileImageView setImage:resizedImage];
    
    // https://stackoverflow.com/questions/4623931/get-underlying-nsdata-from-uiimage
    NSData *profileImageData = UIImagePNGRepresentation(resizedImage);
    PFFileObject *file = [PFFileObject fileObjectWithData:profileImageData];
    [self.profileImageView setFile:file];
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profilePicture"] = self.profileImageView.file;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Profile picture saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
