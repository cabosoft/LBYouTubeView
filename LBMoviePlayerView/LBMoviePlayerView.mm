//
//  LBMoviePlayerView.m
//  LBMoviePlayerView
//
//  Created by Jim Boyd
//  Copyright (c) 2012 CABOsoft. All rights reserved.
//
//  Based on Laurin Brandner's on LBYouTubeView
//  Copyright (c) 2012. All rights reserved.
//

#import "LBMoviePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JSON.h"

static NSString* const kUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3";
static NSString* const kLBMoviePlayerViewErrorDomain = @"LBMoviePlayerViewErrorDomain";

@interface LBMoviePlayerView () {
    MPMoviePlayerController* controller;
    
    BOOL shouldAutomaticallyStartPlaying;
}

@property (nonatomic, strong) MPMoviePlayerController* controller;
@property (nonatomic) BOOL shouldAutomaticallyStartPlaying;

-(void)_setupWithURL:(NSURL*)URL;

-(void)_loadVideoWithContentOfURL:(NSURL*)videoURL;
-(void)_controllerPlaybackStateChanged:(NSNotification*)notification;

-(void)_didSuccessfullyExtractMoviePlayerURL:(NSURL*)videoURL;
-(void)_didStartPlayingMoviePlayerVideo:(MPMoviePlaybackState)state;
-(void)_didPausePlayingMoviePlayerVideo:(MPMoviePlaybackState)state;
-(void)_didStopPlayingMoviePlayerVideo:(MPMoviePlaybackState)state;
-(void)_failedExtractingMoviePlayerURLWithError:(NSError*)error;

@end


@implementation LBMoviePlayerView

@synthesize controller;
@synthesize delegate;
@synthesize highQuality;
@synthesize shouldAutomaticallyStartPlaying;

#pragma mark Initialization
+(LBMoviePlayerView*)moviePlayerViewWithURL:(NSURL *)URL {
    return [[self alloc] initWithMoviePlayerURL:URL];
}

-(id)initWithMoviePlayerURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        [self _setupWithURL:URL];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupWithURL:nil];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupWithURL:nil];
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        [self _setupWithURL:nil];
    }
    return self;
}

-(void)loadMoviePlayerURL:(NSURL*)URL
{
    [self _setupWithURL:URL];
}

-(void)_setupWithURL:(NSURL *)URL {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_controllerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_controllerPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification  object:nil];

    self.backgroundColor = [UIColor blackColor];
    self.controller = nil;
    
    if (URL) {
        [self _loadVideoWithContentOfURL:URL];
    }
}

#pragma mark -
#pragma mark Memory

-(void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    
    [self.controller stop];
    
}

#pragma mark -
#pragma mark Private

-(void)_loadVideoWithContentOfURL:(NSURL *)videoURL {
    self.controller = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    self.controller.view.frame = self.bounds;
    [self.controller prepareToPlay];
    self.controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.controller.view];
    
    if (self.shouldAutomaticallyStartPlaying) {
        [self play];
    }
}

-(void)_controllerPlaybackStateChanged:(NSNotification *)__unused notification {
    MPMoviePlaybackState currentState = self.controller.playbackState;
    
    if (currentState == MPMoviePlaybackStateStopped)
    {
        [self _didStopPlayingMoviePlayerVideo:currentState];
    }
    else if (currentState == MPMoviePlaybackStatePaused)
    {
        [self _didPausePlayingMoviePlayerVideo:currentState];
    }
    else if (currentState == MPMoviePlaybackStateInterrupted) 
    {
        [self _didPausePlayingMoviePlayerVideo:currentState];
    }
    else if (currentState == MPMoviePlaybackStatePlaying) 
    {
        [self _didStartPlayingMoviePlayerVideo:currentState];
    }
}

- (void) _controllerPlayBackDidFinish:(NSNotification*)__unused notification
{
    [self _didStopPlayingMoviePlayerVideo:MPMoviePlaybackStateStopped];
}

-(void)_didStartPlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    if ([self.delegate respondsToSelector:@selector(moviePlayerView:didStartPlayingMoviePlayerVideo:)]) {
        [self.delegate moviePlayerView:self didStartPlayingMoviePlayerVideo:state];
    }
}

-(void)_didPausePlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    if ([self.delegate respondsToSelector:@selector(moviePlayerView:didPausePlayingMoviePlayerVideo:)]) {
        [self.delegate moviePlayerView:self didPausePlayingMoviePlayerVideo:state];
    }
}

-(void)_didStopPlayingMoviePlayerVideo:(MPMoviePlaybackState)state {
    if ([self.delegate respondsToSelector:@selector(moviePlayerView:didStopPlayingMoviePlayerVideo:)]) {
        [self.delegate moviePlayerView:self didStopPlayingMoviePlayerVideo:state];
    }
}


#pragma mark -
#pragma mark Other Methods

-(void)play {
    if (self.controller) {
        [self.controller play];
    }
    else {
        self.shouldAutomaticallyStartPlaying = YES;
    }
}

-(void)stop {
    if (self.controller) {
        [self.controller stop];
    }
    else {
        self.shouldAutomaticallyStartPlaying = NO;
    }
}

#pragma mark
#pragma mark Delegate Calls

-(void)_didSuccessfullyExtractMoviePlayerURL:(NSURL *)videoURL {
    if ([self.delegate respondsToSelector:@selector(moviePlayerView:didSuccessfullyExtractMoviePlayerURL:)]) {
        [self.delegate moviePlayerView:self didSuccessfullyExtractMoviePlayerURL:videoURL];
    }
}

-(void)_failedExtractingMoviePlayerURLWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(moviePlayerView:failedExtractingMoviePlayerURLWithError:)]) {
        [self.delegate moviePlayerView:self failedExtractingMoviePlayerURLWithError:error];
    }
}


@end
