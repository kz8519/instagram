//
//  CollectionViewCell.m
//  Instagram
//
//  Created by Kathy Zhong on 6/29/22.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)setPost:(Post *)post {
    _post = post;

    self.pictureView.image = nil;
    if (self.post.image != nil) {
        self.pictureView.file = self.post.image;
        [self.pictureView loadInBackground];
    }
}

@end
