//
//  PostCell.m
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

#import "PostCell.h"
@import Parse;


@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
//    PFUser *postAuthor = self.post.author;
//    [postAuthor fetchIfNeeded];
//    self.usernameLabel.text = postAuthor.username;

    self.captionLabel.text = self.post.caption;

    self.postImageView.image = nil;
    if (self.post.image != nil) {
        self.postImageView.file = self.post.image;
        [self.postImageView loadInBackground];
    }
}

@end
