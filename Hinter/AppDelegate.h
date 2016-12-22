//
//  AppDelegate.h
//  Hinter
//
//  Created by igenius on 2016/11/5.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ) float gameTime;

@property (nonatomic ,strong) NSTimer *gameTimer;


+ (AppDelegate*)APP;

@end

