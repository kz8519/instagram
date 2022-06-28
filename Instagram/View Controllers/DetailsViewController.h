//
//  DetailsViewController.h
//  Instagram
//
//  Created by Kathy Zhong on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
