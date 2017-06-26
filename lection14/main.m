//
//  main.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SLVTestAppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        Class appDelegateClass = (NSClassFromString(@"XCTestCase") ? [SLVTestAppDelegate class] : [AppDelegate class]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
