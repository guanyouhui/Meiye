//
//  SplashViewController.m
//  TinyShop
//
//  Created by zhwx on 14-8-26.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "LaunchViewController.h"
#import "Member.h"
#import "MemberService.h"
#import "MSWeakTimer.h"
#import "BDSSpeechSynthesizer.h"
#import "BDSBuiltInPlayer.h"

#define MINUTE_COUNT 5

@interface LaunchViewController ()<UIAlertViewDelegate,BDSSpeechSynthesizerDelegate>
{
    MemberService *memberService;
    
    BOOL _isPaused;
    BOOL _isStart;
    BOOL _isNOSpeak;
    
    MSWeakTimer * o_serviceTimer;
    NSInteger secondCount;
}
@property (weak, nonatomic) IBOutlet UIImageView *o_bgImageView;

//第一次 创建此控制器(即第一次启动软件)
@property (assign, nonatomic)BOOL o_isFirstLoadView;

@property (nonatomic, copy) NSString *userInput;
@property (nonatomic) NSInteger playProgress;
@property (nonatomic, strong)BDSSpeechSynthesizer* synthesizer;
@property (nonatomic, strong)BDSBuiltInPlayer* player;

@end

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _o_isFirstLoadView = YES;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotify:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.o_bgImageView.image = [UIImage imageNamed:IPHONE5_OR_LATER?@"Default-568h":@"Default"];
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    memberService = [[MemberService alloc] init];
  
    
    [self initBaiduVoice];
//    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    
//    UIWebView* agentWebView = [[UIWebView alloc] init];
//    agentWebView.delegate = self;
//    [agentWebView loadRequest:request];
//    [self.view addSubview:agentWebView];

    
//    [((AppDelegate*)[UIApplication sharedApplication].delegate) showDefaultImageView];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    __weak LaunchViewController* __mySelf = self;
    dispatch_async(kBgQueue, ^{
        [__mySelf asynAutoLogin];
    });
    
    [self startTimer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) asynAutoLogin
{
//    //网络检测
//    if (![Global sharedInstance].applicationHelper.isOnlineMode) {
//        dispatch_async(kMainQueue, ^{
//            [JoProgressHUD makeToast:@"当前网络不可用,请检查"];
//        });
//        
//        return;
//    }

    [self checkLogin];
    
    //先进入首页
    __weak LaunchViewController* __mySelf = self;
    dispatch_async(kMainQueue, ^{
        [__mySelf entryToHome];
        return ;
    });
    
}

- (void)entryToHome{
    
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [GlobalVC sharedInstance].mainTabVC;
}

-(void) asyncTaskWillExecute:(NSInteger)what
{
    
}

-(void) asyncTaskDidExecute:(NSInteger)what
{
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView == o_strongUpateAlert) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WeiXiaoDian_Appstore_URL]];
//        o_strongUpateAlert = nil;
//    }
    
}


#pragma mark - yuyin 

- (void)initBaiduVoice{
    
    _isPaused = NO;
    _isStart = NO;
    
    _playProgress = 0;
    
    self.synthesizer = [[BDSSpeechSynthesizer alloc] initSynthesizer:@"holder" delegate:self];
    // 设置日志级别
    [BDSSpeechSynthesizer setLogLevel: BDS_PUBLIC_LOG_VERBOSE];
    
    NSLog(@"tts sdk version is %@", [BDSSpeechSynthesizer version]);
    
    
    //    [[BDSEmbeddedSynthesizer sharedInstance] setPlayerVolume:2.0f];
    
    _isNOSpeak = NO; // 设置为YES，则只合成不播放
    
}

- (void)setVoiceParams
{
    // 此处需要将setApiKey:withSecretKey:方法的两个参数替换为你在百度开发者中心注册应用所得到的apiKey和secretKey
    //#error "Must replace api and secret keys with valid ones"
    [self.synthesizer setApiKey:@"am8EWgaSc8PtMXHp5Y8eKV0B" withSecretKey:@"xLr1C9fq8cWND6Td7UyR56fm9a4yGGgF"];
    
    [self.synthesizer setParamForKey:BDS_PARAM_TEXT_ENCODE value:BDS_TEXT_ENCODE_UTF8];
    [self.synthesizer setParamForKey:BDS_PARAM_SPEAKER value:BDS_SPEAKER_FEMALE];
    [self.synthesizer setParamForKey:BDS_PARAM_VOLUME value:@"9"];
    [self.synthesizer setParamForKey:BDS_PARAM_SPEED value:@"5"];
    [self.synthesizer setParamForKey:BDS_PARAM_PITCH value:@"9"];
    [self.synthesizer setParamForKey:BDS_PARAM_AUDIO_ENCODE value:BDS_AUDIO_ENCODE_AMR];
    [self.synthesizer setParamForKey:BDS_PARAM_AUDIO_RATE value:BDS_AUDIO_BITRATE_AMR_15K85];
}


- (void)playVoice:(NSString *)palyText
{
    
    self.userInput = palyText;
    if ([ZUtilsString isEmpty:self.userInput]) {
        return;
    }
    
    [self setVoiceParams];
    
    self.playProgress = 0;
    
    NSInteger ret = 0;
    
    if (_isStart == NO) {
        _isStart = YES;
        _isPaused = NO;
//        [self changePlayButtonBasedOnState:@"暂停"];
        
        if (_isNOSpeak == YES) {
            ret = [self.synthesizer synthesize: self.userInput];
        } else {
            ret = [self.synthesizer speak: self.userInput];
        }
        if (ret != 0) {
            
        }
    } else {
        if (_isPaused) {
            _isPaused = NO;
//            [self changePlayButtonBasedOnState:@"暂停"];
            ret = [self.synthesizer resume];
            if (ret != 0) {
                
            }
        } else {
            _isPaused = YES;
//            [self changePlayButtonBasedOnState:@"恢复"];
            ret = [self.synthesizer pause];
            if (ret != 0) {
                
            }
        }
    }
}



- (void)cancel
{
    //[self.synthesizer setPlayerVolume:10.0f];
    [self.synthesizer cancel];
    /*
     if (ret != 0) {
     [self logError: [self.synthesizer errorDescriptionForCode: ret]];
     }
     */
    self.userInput = @"";
    _isStart = NO;
    _isPaused = NO;
    //_textIndex = 0;
//    [self changePlayButtonBasedOnState: @"开始"];
}

#pragma mark - BDSSpeechSynthesizer Delegate

- (void)synthesizerStartWorking:(BDSSpeechSynthesizer *)speechSynthesizer
{
    NSLog(@"开始合成");
}

- (void)synthesizerSpeechStart:(BDSSpeechSynthesizer *)speechSynthesizer
{
    NSLog(@"开始播放");
}

- (void)synthesizerSpeechDidResumed:(BDSSpeechSynthesizer *)speechSynthesizer
{
    
    NSLog(@"播放已恢复");
}

- (void)synthesizerSpeechProgressChanged:(BDSSpeechSynthesizer *)speechSynthesizer progress:(float)progress
{
    
}

- (void)synthesizerBufferProgressChanged:(BDSSpeechSynthesizer *)speechSynthesizer progress:(float)newProgress
{
    
}

- (void)synthesizerTextBufferedLengthChanged:(BDSSpeechSynthesizer *)speechSynthesizer length:(int)newLength
{
    
}

- (void)synthesizerTextSpeakLengthChanged:(BDSSpeechSynthesizer *)speechSynthesizer length:(int)newLength
{
    // NSLog(@"current progress is %f", newProgress);
    if (self.playProgress == newLength) {
        return ;
    }
    
//    NSString* text = self.inputTextView.text;
//    NSString* readText = [text substringWithRange: NSMakeRange( 0, newLength)];
//    NSString* unReadText = [text substringWithRange: NSMakeRange(newLength, [text length] - newLength)];
//    
//    NSMutableAttributedString *allMessage = [[NSMutableAttributedString alloc] initWithAttributedString:[self string: readText withColor: [UIColor redColor]]];
//    [allMessage appendAttributedString:[self string: unReadText withColor: [UIColor blackColor]]];
//    [self.inputTextView setAttributedText:allMessage];
    self.playProgress = newLength;
}

- (void)synthesizerSpeechDidPaused:(BDSSpeechSynthesizer *)speechSynthesizer
{
    NSLog(@"播放已暂停");
}

- (void)synthesizerSpeechDidFinished:(BDSSpeechSynthesizer *)speechSynthesizer
{
    NSLog(@"合成完成");
    self.userInput = @"";
    
    _isStart = NO;
    _isPaused = NO;
//    [self performSelectorOnMainThread:@selector(changePlayButtonBasedOnState:) withObject: @"开始" waitUntilDone:NO];
}

- (void)synthesizerNewDataArrived:(BDSSpeechSynthesizer *)speechSynthesizer data:(NSData *)newData isLastData:(BOOL)lastDataFlag
{
    if(lastDataFlag)
    {
        // Finished working
        if (_isNOSpeak) {
            [self synthesizerSpeechDidFinished:speechSynthesizer];
        }
    }
}

- (void)synthesizerDidCanceled:(BDSSpeechSynthesizer *)speechSynthesizer
{
    
    NSLog(@"播放已取消");
}

- (void)synthesizerErrorOccurred:(BDSSpeechSynthesizer *)speechSynthesizer error:(NSError *)error
{
    NSString* info = [[NSString alloc] initWithFormat:@"合成发生错误(%d)： %@", (int)[error code], [error localizedDescription] ];
    NSLog(@"%@",info);
//    [self logError: info];
}



#pragma mark- service timer
/**
 * 开启 服务器时间 计算的 timer
 */
-(void) startTimer
{
    [self stopTimer];
    o_serviceTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleServiceTimer:) userInfo:nil repeats:YES dispatchQueue:kBgQueue];
}

/**
 * 停止
 */
-(void) stopTimer
{
    if (o_serviceTimer) {
        [o_serviceTimer invalidate];
        o_serviceTimer = nil;
    }
}

-(void) handleServiceTimer:(MSWeakTimer*)timer
{
    secondCount ++ ;
    if (secondCount % (MINUTE_COUNT * D_MINUTE) == 0) {
        @try {
            ApplicationHelper * applicationHelper = [Global sharedInstance].applicationHelper;
            
            NSMutableDictionary * requestParam = [NSMutableDictionary dictionary];
            [requestParam setObject:@(0) forKey:@"LocationType"];
            [requestParam setObject:@(applicationHelper.currendCoordinate.latitude) forKey:@"Latidude"];
            [requestParam setObject:@(applicationHelper.currendCoordinate.longitude) forKey:@"Longitude"];
            [requestParam setObjectNotNull:applicationHelper.locationCity forKey:@"CityName"];
            [requestParam setObjectNotNull:applicationHelper.locationAddress forKey:@"Address"];
            [self.baseService getDetailWithoutCache:URI_Track requestParam:requestParam];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.name);
        }
        @finally {
            
        }
        
    }
    
}


-(void) dealloc
{
    
    
}

@end
