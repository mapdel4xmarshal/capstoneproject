//
//  AppDelegate.m
//  CapstoneProject
//
//  Created by Student on 2016-10-13.
//  Copyright © 2016 Student. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


//  AppDelegate.m

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //facebook login handler
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //CUSTOM LOGIC--------------------
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *uID = [defaults stringForKey:@"userID"];
    
    if ([FBSDKAccessToken currentAccessToken] || (uID != nil && ![uID isEqualToString: @"nil"] && ![uID isEqual:[NSNull null]])) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"Already logged %@", uID);
        
        //redirect to app homepage
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabControllers"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
        
    }
    
    
    //google login handler
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    

    // Add any custom logic here.
    return handled;
<<<<<<< HEAD
} 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}
=======
}



>>>>>>> master


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
