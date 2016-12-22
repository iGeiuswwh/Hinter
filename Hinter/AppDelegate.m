//
//  AppDelegate.m
//  Hinter
//
//  Created by igenius on 2016/11/5.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


//
//- (NSMutableArray *)storyDevelopArray{
//    if (!_storyDevelopArray) {
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *filePath = [path stringByAppendingPathComponent:@"storyDevelop.plist"];
//
//            _storyDevelopArray = [NSMutableArray arrayWithContentsOfFile:filePath];
//    }
//    return _storyDevelopArray;
//}
//



- (void)startGameTimer{
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(gameTimerAction:) userInfo:nil repeats:YES];
    [self readGameTime];
}

- (void)stopGameTimer{
    [self storeGameTime:self.gameTime];
    [self.gameTimer invalidate];

}


- (void)gameTimerAction:(NSTimer *)timer{

    self.gameTime = self.gameTime + 5;

}

- (void)setGameTime:(float)gameTime{

    _gameTime = gameTime;
    
}

- (void)storeGameTime:(float)gameTime{
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    [userDef setFloat:gameTime forKey:@"gameTime"];
    [userDef synchronize];
}

- (void)readGameTime{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    self.gameTime = [userDefault integerForKey:@"gameTime"];

}

+(AppDelegate*)APP{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self stopGameTimer];
    NSLog(@"%@",NSHomeDirectory());

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    //当应用程序发送即将从活跃不活跃的状态。这可能发生某些类型的暂时中断(如电话来电或短信)或当用户退出应用程序开始转换到背景状态。
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //使用这种方法暂停正在进行的任务,禁用计时器,和无效的图形渲染回调。游戏应该使用这个方法来暂停游戏。
}


- (void)applicationDidEnterBackground:(UIApplication *)application {


    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self startGameTimer];
  

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
