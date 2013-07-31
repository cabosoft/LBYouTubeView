//
//  LBMoviePlayerController.m
//  LBMoviePlayerController
//
//  Created by Jim Boyd
//  Copyright (c) 2012 CABOsoft. All rights reserved.
//
//  Based on Laurin Brandner's LBYouTubeController (LBViewController)
//  Copyright (c) 2012. All rights reserved.
//

#import "LBMoviePlayerController.h"

@implementation LBMoviePlayerController

@synthesize moviePlayerView;
@synthesize movieURL = mMovieURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if ((self = [super initWithNibName:(nibNameOrNil ? nibNameOrNil : @"LBMoviePlayerController") bundle:nibBundleOrNil]))
	{
    }
    
    return self;
}

-(void)viewDidLoad 
{
    [super viewDidLoad];
	
    self.moviePlayerView.delegate = self;
    self.moviePlayerView.highQuality = YES;
    mActivityLabel = nil;
}

- (void)viewDidUnload
{
    [self.moviePlayerView stop];        
    self.moviePlayerView.delegate = nil;
    self.moviePlayerView= nil; 

    [super viewDidUnload];
}

- (void)dealloc
{
    [self.moviePlayerView stop];        
    self.moviePlayerView.delegate = nil;
    
    self.movieURL= nil; 
    RELEASE_SAFELY(mActivityLabel);
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

-(void) setMovieURL:(NSString*) movieURL
{
    if ((movieURL == nil) || (movieURL.length == 0))
    {
        [self.moviePlayerView stop];
        RELEASE_SAFELY(mMovieURL)
        mMovieURL = nil;
    }
    else if ((self.movieURL == nil) || ([self.movieURL compare:movieURL] != 0))
    {
        [moviePlayerView stop];  
        RELEASE_SAFELY(mMovieURL)
        mMovieURL = movieURL;
        
        // load the app content on a thread, with activity label
        [self addActivityLabelWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self.moviePlayerView loadMoviePlayerURL:[NSURL URLWithString:mMovieURL]];
        [self.moviePlayerView play];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return NIIsSupportedOrientation(interfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (NIIsPad())
    {
        return  UIInterfaceOrientationMaskAll;
    }
    else
    {
        return  UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
										 duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	if (mActivityLabel != nil)
	{
		mActivityLabel.center = self.view.center;
	}
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didSuccessfullyExtractmovieURL:(NSURL *)videoURL {
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView failedExtractingMoviePlayerURLWithError:(NSError *)error {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Failed loading video due to error:%@", error.localizedDescription);
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didStartPlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Did start playing moviePlayer video");
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didPausePlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Did pause playing moviePlayer video");
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didStopPlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Did finish playing moviePlayer video");
}

@end
