//
//  LBYouTubePlayerController.m
//  LBYouTubeView
//
//  Created by Marco Muccinelli on 11/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LBYouTubePlayerViewController.h"
#import "LBYouTubeExtractor.h"

@interface LBYouTubePlayerViewController ()

@property (nonatomic, strong) LBYouTubePlayerController* view;
@property (nonatomic, strong) LBYouTubeExtractor* extractor;

-(void)_setupWithYouTubeURL:(NSURL*)URL quality:(LBYouTubeVideoQuality)quality;

-(void)_loadVideoWithURL:(NSURL *)videoURL;

-(void)_didSuccessfullyExtractYouTubeURL:(NSURL*)videoURL;
-(void)_failedExtractingYouTubeURLWithError:(NSError*)error;
-(void)_didStartPlayingYouTubeVideo:(MPMoviePlaybackState)state;
-(void)_didPausePlayingYouTubeVideo:(MPMoviePlaybackState)state;
-(void)_didStopPlayingYouTubeVideo:(MPMoviePlaybackState)state;

@end
@implementation LBYouTubePlayerViewController

@synthesize view, delegate, extractor;

#pragma mark

-(LBYouTubePlayerController*)view {
    if (view) {
        return view;
    }
    self.view = [LBYouTubePlayerController new];
    return view;
}

#pragma mark -
#pragma mark Initialization

-(id)initWithYouTubeURL:(NSURL *)URL quality:(LBYouTubeVideoQuality)quality {
    self = [super init];
    if (self) {
        [self _setupWithYouTubeURL:URL quality:quality];
    }
    return self;
}

-(id)initWithYouTubeID:(NSString *)youTubeID quality:(LBYouTubeVideoQuality)quality {
    self = [super init];
    if (self) {
        [self _setupWithYouTubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", youTubeID]] quality:quality];
    }
    return self;
}

-(id)initWithPlayerController:(LBYouTubePlayerController*)_view youTubeURL:(NSURL*)youTubeURL quality:(LBYouTubeVideoQuality)quality
{
    self = [self initWithYouTubeURL:youTubeURL quality:quality];
    
    if (self) {
        self.view = _view;
    }
    return self;
}

-(id)initWithPlayerController:(LBYouTubePlayerController*)_view youTubeID:(NSString*)youTubeID quality:(LBYouTubeVideoQuality)quality
{
    self = [self initWithYouTubeID:youTubeID quality:quality];
    
    if (self) {
        self.view = _view;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.view.videoController stop];
}

-(void)_setupWithYouTubeURL:(NSURL *)URL quality:(LBYouTubeVideoQuality)quality {
    self.view = nil;
    self.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_controllerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_controllerPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification  object:nil];

    self.extractor = [[LBYouTubeExtractor alloc] initWithURL:URL quality:quality];
    self.extractor.delegate = self;
    [self.extractor startExtracting];
}

#pragma mark - 
#pragma mark Private

-(void)_loadVideoWithURL:(NSURL *)videoURL {
    [self.view loadYouTubeVideo:videoURL];
}

-(void)_controllerPlaybackStateChanged:(NSNotification *)__unused notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState currentState = moviePlayer.playbackState;
    
    if (currentState == MPMoviePlaybackStateStopped)
    {
        [self _didStopPlayingYouTubeVideo:currentState];
    }
    else if (currentState == MPMoviePlaybackStatePaused)
    {
        [self _didPausePlayingYouTubeVideo:currentState];
    }
    else if (currentState == MPMoviePlaybackStateInterrupted)
    {
        [self _didPausePlayingYouTubeVideo:currentState];
    }
    else if (currentState == MPMoviePlaybackStatePlaying)
    {
        [self _didStartPlayingYouTubeVideo:currentState];
    }
}

- (void) _controllerPlayBackDidFinish:(NSNotification*)__unused notification
{
    [self _didStopPlayingYouTubeVideo:MPMoviePlaybackStateStopped];
}

-(void)_didStartPlayingYouTubeVideo:(MPMoviePlaybackState)state {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:didStartPlayingYouTubeVideo:)]) {
        [self.delegate youTubePlayerViewController:self didStartPlayingYouTubeVideo:state];
    }
}

-(void)_didPausePlayingYouTubeVideo:(MPMoviePlaybackState)state {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:didPausePlayingYouTubeVideo:)]) {
        [self.delegate youTubePlayerViewController:self didPausePlayingYouTubeVideo:state];
    }
}

-(void)_didStopPlayingYouTubeVideo:(MPMoviePlaybackState)state {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:didStopPlayingYouTubeVideo:)]) {
        [self.delegate youTubePlayerViewController:self didStopPlayingYouTubeVideo:state];
    }
}

#pragma mark -
#pragma mark Delegate Calls

-(void)_didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:didSuccessfullyExtractYouTubeURL:)]) {
        [self.delegate youTubePlayerViewController:self didSuccessfullyExtractYouTubeURL:videoURL];
    }
}

-(void)_failedExtractingYouTubeURLWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:failedExtractingYouTubeURLWithError:)]) {
        [self.delegate youTubePlayerViewController:self failedExtractingYouTubeURLWithError:error];
    }
}

#pragma mark -
#pragma mark LBYouTubeExtractorDelegate

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    [self _didSuccessfullyExtractYouTubeURL:videoURL];
    [self _loadVideoWithURL:videoURL];
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error {
    [self _failedExtractingYouTubeURLWithError:error];
}

#pragma mark -

@end
