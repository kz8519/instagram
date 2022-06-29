//
//  PostCell.h
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;

@property (nonatomic, strong) Post *post;


@end

NS_ASSUME_NONNULL_END
