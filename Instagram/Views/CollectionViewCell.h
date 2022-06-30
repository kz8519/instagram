//
//  CollectionViewCell.h
//  Instagram
//
//  Created by Kathy Zhong on 6/29/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet PFImageView *pictureView;
@property (nonatomic, strong) Post *post;


@end

NS_ASSUME_NONNULL_END
