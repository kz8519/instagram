//
//  ProfileViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

#import "ProfileViewController.h"
#import "CollectionViewCell.h"
#import "DetailsViewController.h"
#import "Post.h"
@import Parse;
@import UITextView_Placeholder;


@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
//@property (strong, nonatomic) IBOutlet UITextView *bioView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
- (IBAction)changeProfilePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *arrayOfPosts;
- (IBAction)didTapEdit:(id)sender;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
//    self.bioView.placeholder = @"Add bio here";
    
    PFUser *user = [PFUser currentUser];
    if (user[@"profilePicture"] != nil) {
        self.profileImageView.file = user[@"profilePicture"];
        [self.profileImageView loadInBackground];
    }
    
    if (user[@"bio"] != nil) {
        self.bioLabel.text = user[@"bio"];
    }
    
    self.usernameLabel.text = user.username;
    
    [self queryPosts:user];
}

- (void)queryPosts:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:user];
    query.limit = 20;
//    query.limit = numPostsToLoad;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfPosts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.arrayOfPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    Post *post = self.arrayOfPosts[indexPath.row];
    cell.post = post;
    NSLog(@"%@", cell.post);

    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass: [CollectionViewCell class]]) {
        // Segue to DetailsViewController so user can view tweet details
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Post *dataToPass = self.arrayOfPosts[indexPath.row];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.post = dataToPass;
    }
}


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

- (IBAction)didTapEdit:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit Biography" message:@"Input your new biography below" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter new biography";
    }];
    
    // create an Save action
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
        PFUser *currentUser = [PFUser currentUser];
        currentUser[@"bio"] = [[alert textFields][0] text];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"New bio saved!");
                self.bioLabel.text = currentUser[@"bio"];
            } else {
                NSLog(@"Error: %@", error.description);
            }
        }];
    }];
    
    // add the Save action to the alert controller
    [alert addAction:saveAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
