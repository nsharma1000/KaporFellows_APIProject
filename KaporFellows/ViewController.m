//
//  ViewController.m
//  KaporFellows
//
//  Created by Nisha Sharma on 4/1/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import "FlickrPhoto.h"
#import "Flickr.h"
#import "FlickrPhotoCell.h"
#import "FlickrPhotoHeaderView.h"
#import "FlickrPhotoViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController () <UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) NSMutableArray *selectedPhotos;
@property(nonatomic, strong) Flickr *flickr;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.searches = [@[] mutableCopy];
	self.searchResults = [@{} mutableCopy];
    self.flickr = [[Flickr alloc] init];
    self.selectedPhotos = [@[] mutableCopy];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSString *searchTerm = self.searches[section];
    return [self.searchResults[searchTerm] count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.searches count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    cell.photo = self.searchResults[searchTerm][indexPath.row];
    return cell;
}
 //4
- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.height += 35;
    retval.width += 35;
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - UITextFieldDelegate methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if(results && [results count] > 0)
        {
            if(![self.searches containsObject:searchTerm])
            {
                NSLog(@"Found %d photos matching %@",[results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        } else {
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        }
    }];
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)social:(id)sender {
    //This is how you create a UIACtionSheet.
    UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"Sharing Your Update" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Tweet!", @"Facebook!", nil];
    
    [share showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *tweetSheet =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You can't tweet right now, make sure you're logined to Twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
    }else if (buttonIndex == 1) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *facebookSheet =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [self presentViewController:facebookSheet animated:YES completion:nil];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You can't do a facebook update right now, make sure you're logined." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    
}

@end
