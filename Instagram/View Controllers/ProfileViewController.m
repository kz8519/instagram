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


@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
- (IBAction)changeProfilePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayOfPosts;
- (IBAction)didTapEdit:(id)sender;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
        
    PFUser *user = [PFUser currentUser];
    
    [self setProfileImage:user];
    [self setBioText:user];
    [self setUsernameText:user];
    [self queryPosts:user];
}

- (void) setProfileImage:(PFUser *)user {
    if (user[@"profilePicture"] != nil) {
        self.profileImageView.file = user[@"profilePicture"];
        [self.profileImageView loadInBackground];
    }
}

- (void) setBioText:(PFUser *)user {
    self.bioLabel.text = user[@"bio"];
}

- (void) setUsernameText:(PFUser *)user {
    self.usernameLabel.text = user.username;
}

- (void)queryPosts:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:user];
    query.limit = 20;

    // Fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
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

    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass: [CollectionViewCell class]]) {
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
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [self resizeImage:originalImage withSize:self.profileImageView.bounds.size];

    [self.profileImageView setImage:resizedImage];
    
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
    
    // Create an Save action
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Handle response
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
    
    [alert addAction:saveAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
