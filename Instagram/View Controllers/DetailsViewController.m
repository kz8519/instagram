//
//  DetailsViewController.m
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

#import "DetailsViewController.h"
#import "DateTools.h"
@import Parse;

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
    
    PFUser *postAuthor = self.post.author;
    [postAuthor fetchIfNeeded];
    self.usernameLabel.text = postAuthor.username;

    self.captionLabel.text = self.post.caption;

    self.timestampLabel.text = [self.post.createdAt.shortTimeAgoSinceNow stringByAppendingString:@" ago"];

    self.postImageView.image = nil;
    if (self.post.image != nil) {
        self.postImageView.file = self.post.image;
        [self.postImageView loadInBackground];
    }
    
    self.profileImageView.image = nil;
    if (postAuthor[@"profilePicture"] != nil) {
        self.profileImageView.file = postAuthor[@"profilePicture"];
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
