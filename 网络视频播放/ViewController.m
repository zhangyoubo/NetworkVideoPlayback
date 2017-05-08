//
//  ViewController.m
//  网络视频播放
//
//  Created by 张友波 on 17/3/30.
//  Copyright © 2017年 张友波. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface ViewController ()
{
    
    AVPlayerViewController * avPlayer;
    
}

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

@end

@implementation ViewController

#pragma mark - 控制器视图方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * playVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    playVideoButton.center = self.view.center;
    playVideoButton.backgroundColor = [UIColor grayColor];
    [playVideoButton setTitle:@"点击播放" forState:UIControlStateNormal];
    [playVideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playVideoButton addTarget:self action:@selector(playeVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playVideoButton];
    
    //添加通知
    [self addNotification];
}

- (void)playeVideo
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
   
    NSURL *url =[[NSBundle mainBundle] URLForResource:@"Britney Spears - Make Me" withExtension:@"mp4"];
    
    //http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4
  //  NSURL * videoURL = [NSURL URLWithString:@"http://vcntv.dnion.com/flash/live_back/nettv_cctv3/cctv3-2017-03-29-00-010.mp4"];
    avPlayer = [[AVPlayerViewController alloc] init];
    avPlayer.player = [[AVPlayer alloc] initWithURL:url];
    /*
     可以设置的值及意义如下：
     AVLayerVideoGravityResizeAspect   不进行比例缩放 以宽高中长的一边充满为基准
     AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
     AVLayerVideoGravityResize     进行缩放充满屏幕
     */
    avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    avPlayer.allowsPictureInPicturePlayback = true;    //画中画，iPad可用
    avPlayer.showsPlaybackControls = true;
    avPlayer.view.translatesAutoresizingMaskIntoConstraints = true;    //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
    
//    [self addChildViewController:avPlayer];
//    
//    avPlayer.view.frame = CGRectMake(0, 0, 320, 300);
//    [self.view addSubview:avPlayer.view];
    [avPlayer.player play];    //自动播放
    
    [self presentViewController:avPlayer animated:YES completion:nil];
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSString *urlStr=@"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}


/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}

@end
