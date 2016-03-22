//
//  SplashViewController.h
//  TinyShop
//
//  Created by zhwx on 14-8-26.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "TXViewController.h"
#import "BDSSpeechSynthesizer.h"
#import "BDSBuiltInPlayer.h"

@interface LaunchViewController : TXViewController

@property (nonatomic,strong) NSDictionary* o_apnsUserInfo;

@property (nonatomic, strong)BDSSpeechSynthesizer* synthesizer;
@property (nonatomic, strong)BDSBuiltInPlayer* player;

@end
