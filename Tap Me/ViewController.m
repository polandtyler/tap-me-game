//
//  ViewController.m
//  Tap Me
//
//  Created by Tyler Poland on 8/23/14.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (AVAudioPlayer *)setupAudioPlayerWithFile:(NSString *)file type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (!audioPlayer) {
        NSLog(@"%@", [error description]);
    }
    
    return audioPlayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tile.png"]];
    
    scoreLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_score.png"]];
    
    timerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_time.png"]];
    
    //audio
    buttonBeep = [self setupAudioPlayerWithFile:@"ButtonTap" type:@"wav"];
    secondBeep = [self setupAudioPlayerWithFile:@"SecondBeep" type:@"wav"];
    backgroundMusic = [self setupAudioPlayerWithFile:@"HallOfTheMountainKing" type:@"mp3"];
	[self setupGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed {
    count++;
    
    scoreLabel.text = [NSString stringWithFormat:@"Score\n%i", count];
    [buttonBeep play];
}

- (void)setupGame {
    seconds = 30;
    count = 0;
    
    timerLabel.text = [NSString stringWithFormat:@"Time: %i", seconds];
    scoreLabel.text = [NSString stringWithFormat:@"Score:\n%i", count];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(subtractTime) userInfo:nil repeats:YES];
    
    [backgroundMusic setVolume:0.3];
    [backgroundMusic play];
}

- (void)subtractTime {
    seconds--;
    timerLabel.text = [NSString stringWithFormat:@"Time: %i", seconds];
    [secondBeep play];
    
    if (seconds == 0) {
        [timer invalidate];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time is up!" message:[NSString stringWithFormat:@"You scored %i points", count] delegate:self cancelButtonTitle:@"Play Again" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self setupGame];
}

@end
