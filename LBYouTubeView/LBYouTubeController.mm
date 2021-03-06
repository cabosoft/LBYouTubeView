//
//  LBYouTubeController.m
//  LBYouTubeView
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

#import "LBYouTubeController.h"
#import "LBYouTubePlayerController.h"

@implementation LBYouTubeController

@synthesize youTubeView = mYouTubeView;
@synthesize controller = mController;
@synthesize youTubeURL = mYouTubeURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if ((self = [super initWithNibName:(nibNameOrNil ? nibNameOrNil : @"LBYouTubeController") bundle:nibBundleOrNil]))
	{
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    mActivityLabel = nil;
}

- (void)viewDidUnload
{
    [self.youTubeView.videoController stop];
    self.youTubeView= nil; 

	self.controller.delegate = nil;
	self.controller = nil;

    [super viewDidUnload];
}

- (void)dealloc
{
    [self.youTubeView.videoController stop];
    self.controller.delegate = nil;
    self.youTubeView= nil;
    self.controller= nil;
    
    self.youTubeURL= nil; 
    mActivityLabel = nil;
}

- (void) addActivityLabelWithStyle:(UIActivityIndicatorViewStyle) style
{
    assert(mActivityLabel == nil);
        
    mActivityLabel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [mActivityLabel sizeToFit];
    
    mActivityLabel.center = self.view.center;
    
    [mActivityLabel startAnimating];
    
    [self.view addSubview:mActivityLabel];
}

-(void) setYouTubeURL:(NSString*) youTubeURL
{
    if ((youTubeURL == nil) || (youTubeURL.length == 0))
    {
        [self.youTubeView.videoController stop];
        mYouTubeURL = nil;

        self.controller.delegate = nil;
        self.controller = nil;
    }
    else if ((self.youTubeURL == nil) || ([self.youTubeURL compare:youTubeURL] != 0))
    {
        [self.youTubeView.videoController stop];
        mYouTubeURL = youTubeURL;

        self.controller.delegate = nil;
        self.controller = nil;

        self.controller = [[LBYouTubePlayerViewController alloc] initWithPlayerController:self.youTubeView youTubeURL:[NSURL URLWithString:youTubeURL] quality:LBYouTubeVideoQualityLarge];
        self.controller.delegate = self;

        // load the app content on a thread, with activity label
        [self addActivityLabelWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.youTubeView.videoController play];
    }
}

+(BOOL) isPad
{
	static NSInteger isPad = -1;
	if (isPad < 0)
	{
		isPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0;
	}
	return isPad > 0;
}


+(BOOL) isSupportedOrientation:(UIInterfaceOrientation) orientation
{
	if ([LBYouTubeController isPad])
	{
		return YES;
		
	}
	else
	{
		switch (orientation)
		{
			case UIInterfaceOrientationPortrait:
			case UIInterfaceOrientationLandscapeLeft:
			case UIInterfaceOrientationLandscapeRight:
				return YES;
			default:
				return NO;
		}
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return [LBYouTubeController isSupportedOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([LBYouTubeController isPad])
    {
        return  UIInterfaceOrientationMaskAll;
    }
    else
    {
        return  UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
										 duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	if (mActivityLabel != nil)
	{
		mActivityLabel.center = self.view.center;
	}
}


-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"Did extract video source:%@", videoURL);
    [self.youTubeView.videoController play];
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        mActivityLabel = nil;
    }

    NSLog(@"Failed loading video due to error:%@", error.localizedDescription);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didStartPlayingYouTubeVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        mActivityLabel = nil;
    }

    NSLog(@"Did start playing YouTube video");
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didPausePlayingYouTubeVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        mActivityLabel = nil;
    }

    NSLog(@"Did pause playing YouTube video");
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didStopPlayingYouTubeVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        mActivityLabel = nil;
    }

    NSLog(@"Did finish playing YouTube video");
}

@end
