//
//  AppDelegate.m
//  IceClimber
//
//  Created by kanaykin sergey on 18/10/2013.
//  Copyright (c) 2013 kanaykin sergey. All rights reserved.
//

//#import "AppDelegate.h"
#import "EAGLView.h"
#import "cocos2d.h"
#import "RootViewController.h"
#import "AppController.h"
#import "AppDelegate.h"

@implementation AppController

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    EAGLView *__glView = [EAGLView viewWithFrame: [self.window bounds]
                                     pixelFormat: kEAGLColorFormatRGBA8
                                     depthFormat: GL_DEPTH_COMPONENT16
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];
    
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    // Use RootViewController manage EAGLView
    self.viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    self.viewController.wantsFullScreenLayout = YES;
    self.viewController.view = __glView;
    
    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [self.window addSubview: self.viewController.view];
    }
    else
    {
        // use this method on ios6
        [self.window setRootViewController:self.viewController];
    }
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    cocos2d::CCApplication::sharedApplication()->run();
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
