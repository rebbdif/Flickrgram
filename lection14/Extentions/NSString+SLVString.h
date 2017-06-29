//
//  NSString+SLVString.h
//  flickrgram
//
//  Created by 1 on 29.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SLVString)

/**
 Returns NSString with code representation of complex UNICODE symbols

 @param emojiString string, that needs to escape complex UNICODE symbols
 @return NSString with escaped complex UNICODE symbols - they are presented with their code representation
 */
+ (NSString *)stringWithEscapedEmojis:(NSString *)emojiString;

/**
 Returns NSString with complex UNICODE symbols
 
 @param escapedString string, that has UNICODE symbols presented with their code representation
 @return NSString with complex UNICODE symbols
 */
+ (NSString *)stringWithUnescapedEmojis:(NSString *)escapedString;

@end
