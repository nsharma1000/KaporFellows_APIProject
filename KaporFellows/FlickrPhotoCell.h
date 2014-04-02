//
//  FlickrPhotoCell.h
//  KaporFellows
//
//  Created by Nisha Sharma on 4/2/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class FlickrPhoto;
@interface FlickrPhotoCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;
@end
