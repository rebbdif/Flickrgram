//
//  NSString+SLVString.m
//  flickrgram
//
//  Created by 1 on 29.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "NSString+SLVString.h"

@implementation NSString (SLVString)

+ (NSString *)stringWithEscapedEmojis:(NSString *)emojiString {
    NSString *escapedEmoji = [NSString stringWithCString:[emojiString cStringUsingEncoding:NSNonLossyASCIIStringEncoding] encoding:NSUTF8StringEncoding];
    return escapedEmoji;
    
}

+ (NSString *)stringWithUnescapedEmojis:(NSString *)escapedString {
    NSString *unescapedEmoji = [NSString stringWithCString:[escapedString cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return unescapedEmoji;
}

@end
