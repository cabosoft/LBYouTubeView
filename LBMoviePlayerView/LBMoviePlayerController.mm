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
    TT_RELEASE_SAFELY(mActivityLabel);

}

- (void) addActivityLabelWithStyle:(TTActivityLabelStyle)style
{
    REQUIRE(mActivityLabel == nil);
    
    CGRect frame = self.view.frame;
    
    mActivityLabel = [[TTActivityLabel alloc] initWithStyle2:style];
    mActivityLabel.text = @"Loading...";
    
    [mActivityLabel sizeToFit];
    mActivityLabel.frame = CGRectMake(0,  (frame.size.height - mActivityLabel.height) / 2, self.view.width, mActivityLabel.height);
    [self.view addSubview:mActivityLabel];
}

-(void) setMovieURL:(NSString*) movieURL
{
    if ((movieURL == nil) || (movieURL.length == 0))
    {
        [self.moviePlayerView stop];
        TT_RELEASE_SAFELY(mMovieURL)
        mMovieURL = nil;
    }
    else if ((self.movieURL == nil) || ([self.movieURL compare:movieURL] != 0))
    {
        [moviePlayerView stop];  
        TT_RELEASE_SAFELY(mMovieURL)
        mMovieURL = movieURL;
        
        // load the app content on a thread, with activity label
        [self addActivityLabelWithStyle:TTActivityLabelStyleBlackBezel];
        
        [self.moviePlayerView loadMoviePlayerURL:[NSURL URLWithString:mMovieURL]];
        [self.moviePlayerView play];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return TTIsSupportedOrientation(interfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (TTIsPad())
    {
        return  UIInterfaceOrientationMaskAll;
    }
    else
    {
        return  UIInterfaceOrientationMaskAllButUpsideDown;
    }
}


-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didSuccessfullyExtractmovieURL:(NSURL *)videoURL {
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView failedExtractingMoviePlayerURLWithError:(NSError *)error {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        TT_RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Failed loading video due to error:%@", error.localizedDescription);
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didStartPlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        TT_RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Did start playing moviePlayer video");
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didPausePlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        TT_RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Did pause playing moviePlayer video");
}

-(void)moviePlayerView:(LBMoviePlayerView *)moviePlayerView didStopPlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    
    if (mActivityLabel)
    {
        [mActivityLabel removeFromSuperview];
        TT_RELEASE_SAFELY(mActivityLabel);
    }

    NSLog(@"Did finish playing moviePlayer video");
}

@end
