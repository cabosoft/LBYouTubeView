//
//  LBMoviePlayerController.h
//  LBMoviePlayerController
//
//  Created by Jim Boyd
//  Copyright (c) 2012 CABOsoft. All rights reserved.
//
//  Based on Laurin Brandner's LBYouTubeController (LBViewController)
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMoviePlayerView.h"

@interface LBMoviePlayerController : UIViewController <LBMoviePlayerViewDelegate>
{
@protected
    NSString* mMovieURL;
    UIActivityIndicatorView * mActivityLabel;
}

@property (nonatomic, strong) IBOutlet LBMoviePlayerView* moviePlayerView;
@property (nonatomic, strong) NSString* movieURL;

@end
