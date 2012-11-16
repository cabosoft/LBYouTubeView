//
//  LBMoviePlayerView.h
//  LBMoviePlayerView
//
//  Created by Jim Boyd
//  Copyright (c) 2012 CABOsoft. All rights reserved.
//
//  Based on Laurin Brandner's on LBYouTubeView
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol LBMoviePlayerViewDelegate;

@interface LBMoviePlayerView : UIView {
    id <LBMoviePlayerViewDelegate> __weak delegate;
    BOOL highQuality;
}

@property (nonatomic, strong, readonly) MPMoviePlayerController* controller;
@property (nonatomic, weak) IBOutlet id <LBMoviePlayerViewDelegate> delegate;
@property (nonatomic) BOOL highQuality;

+(LBMoviePlayerView*)moviePlayerViewWithURL:(NSURL*)URL;
-(id)initWithMoviePlayerURL:(NSURL*)URL;

-(void)loadMoviePlayerURL:(NSURL*)URL;

-(void)play;
-(void)stop;

@end
@protocol LBMoviePlayerViewDelegate <NSObject>

@optional
-(void)moviePlayerView:(LBMoviePlayerView*)moviePlayerView didSuccessfullyExtractMoviePlayerURL:(NSURL*)videoURL;
-(void)moviePlayerView:(LBMoviePlayerView*)moviePlayerView didStartPlayingMoviePlayerVideo:(MPMoviePlaybackState)state;
-(void)moviePlayerView:(LBMoviePlayerView*)moviePlayerView didPausePlayingMoviePlayerVideo:(MPMoviePlaybackState)state;
-(void)moviePlayerView:(LBMoviePlayerView*)moviePlayerView didStopPlayingMoviePlayerVideo:(MPMoviePlaybackState)state;
-(void)moviePlayerView:(LBMoviePlayerView*)moviePlayerView failedExtractingMoviePlayerURLWithError:(NSError*)error;

@end
