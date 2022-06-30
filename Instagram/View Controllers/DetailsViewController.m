//
//  DetailsViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

@import Parse;
#import "DetailsViewController.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self setUsernameText:self.post.author];
    
    [self setCaptionText];

    [self setTimestampText];
    
    [self setPostImage];
    
    [self setProfileImage:self.post.author];
}

- (void) setUsernameText: (PFUser *)user {
    [user fetchIfNeeded];
    self.usernameLabel.text = user.username;
}

- (void) setCaptionText {
    self.captionLabel.text = self.post.caption;
}

- (void) setTimestampText {
    self.timestampLabel.text = [self.post.createdAt.shortTimeAgoSinceNow stringByAppendingString:@" ago"];
}

- (void) setPostImage {
    self.postImageView.image = nil;
    if (self.post.image != nil) {
        self.postImageView.file = self.post.image;
        [self.postImageView loadInBackground];
    }
}

- (void) setProfileImage: (PFUser *)user {
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

@end
