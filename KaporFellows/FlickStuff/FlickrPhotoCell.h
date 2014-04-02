//
//  FlickrPhotoCell.h
//  Flickr Search
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FlickrPhoto;

@interface FlickrPhotoCell : UICollectionViewCell
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) FlickrPhoto *photo;
@end
