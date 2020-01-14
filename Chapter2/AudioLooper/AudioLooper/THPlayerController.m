//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "THPlayerController.h"
#import <AVFoundation/AVFoundation.h>

@interface THPlayerController()

@property (nonatomic) BOOL playing;
@property (strong, nonatomic) NSArray *players;

@end

@implementation THPlayerController

-(instancetype)init{
    self = [super init];
    if (self) {
        AVAudioPlayer *guitarPlayer = [self playerForFile:@"guitar"];
        AVAudioPlayer *bassPlayer = [self playerForFile:@"bass"];
        AVAudioPlayer *drumsPlayer = [self playerForFile:@"drums"];
        
        _players = @[guitarPlayer,bassPlayer,drumsPlayer];
    }
    return  self;
}

-(AVAudioPlayer *)playerForFile:(NSString *)name{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"caf"];
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    
    if (player) {
        player.numberOfLoops = -1;
        player.enableRate = YES;
        [player prepareToPlay];
    }else{
        NSLog(@"Error %@",[error description]);
    }
    
    return player;
}

- (void)play {
    if (self.playing == NO) {
        NSTimeInterval delayTime = [self.players[0] deviceCurrentTime] + 0.01;
        for (AVAudioPlayer *player in self.players) {
            [player playAtTime:delayTime];
        }
        
        self.playing = YES;
    }
}

- (void)stop {
    if (self.playing == YES) {
        for (AVAudioPlayer *player in self.players) {
            [player stop];
            player.currentTime = 0;
        }
        
        self.playing = NO;
    }
}

- (void)adjustRate:(float)rate {
    for (AVAudioPlayer *player in self.players) {
        [player setRate:rate];
    }
}

- (void)adjustPan:(float)pan forPlayerAtIndex:(NSUInteger)index {
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.pan = pan;
    }
}

- (void)adjustVolume:(float)volume forPlayerAtIndex:(NSUInteger)index {
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.volume = volume;
    }
}

-(BOOL)isValidIndex:(NSUInteger)index{
    return (index == 0 || index < self.players.count);
}

@end
