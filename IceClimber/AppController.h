//
//  AppDelegate.h
//  IceClimber
//
//  Created by kanaykin sergey on 18/10/2013.
//  Copyright (c) 2013 kanaykin sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppController : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)RootViewController    *viewController;

@end
