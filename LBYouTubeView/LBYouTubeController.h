//
//  LBYouTubeController.h
//  LBYouTubeController
//
//  Created by Laurin Brandner on 27.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Updated by Jim Boyd
//      Renamed file and class to LBYouTubeController (was LBViewController)
//      Removed ARC requirement
//      Added support for iOS 4.0
//      Added Three20 support
//      Copyright (c) 2012 CABOsoft.
//

#import <UIKit/UIKit.h>
#import "LBYouTubePlayerViewController.h"

@class LBYouTubePlayerController;

@interface LBYouTubeController : UIViewController <LBYouTubePlayerControllerDelegate>
{
    NSString* mYouTubeURL;
    UIActivityIndicatorView * mActivityLabel;
    
    LBYouTubePlayerController* mYouTubeView;
    LBYouTubePlayerViewController* mController;
}

@property (nonatomic, strong) IBOutlet LBYouTubePlayerController* youTubeView;
@property (nonatomic, strong) LBYouTubePlayerViewController* controller;
@property (nonatomic, strong) NSString* youTubeURL;

@end
