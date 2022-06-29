//
//  ComposeViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/27/22.
//

#import "ComposeViewController.h"
#import "Post.h"
#import <Parse/Parse.h>


@interface ComposeViewController ()
//@property (strong, nonatomic) IBOutlet UITextField *captionField;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
- (IBAction)useCamera:(id)sender;
- (IBAction)usePhotos:(id)sender;
- (IBAction)sharePost:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *captionView;

@end

@implementation ComposeViewController

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

- (IBAction)sharePost:(id)sender {
    
    // Resize image
//    [self resizeImage:originalImage withSize:self.photoView.image.size];
    
    // Save with parse
    [Post postUserImage:[self resizeImage:self.photoView.image withSize:CGSizeMake(self.photoView.bounds.size.width * 5, self.photoView.bounds.size.height * 5)] withCaption:self.captionView.text withCompletion:^(BOOL success, NSError *error) {
        if(error){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Success!");
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)usePhotos:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)useCamera:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // TODO: Do something with the images (based on your use case)
    self.photoView.image = originalImage;
//    self.photoView.image = [self resizeImage:originalImage withSize:self.photoView.image.size];
    
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
