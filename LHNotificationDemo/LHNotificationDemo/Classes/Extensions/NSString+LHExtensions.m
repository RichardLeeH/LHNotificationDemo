//
//  NSString+LHExtensions.m
//  NSString+Extensions
//
//  Created by 李辉 on 15/3/9.
//  Copyright (c) 2015年 gushiwen.org. All rights reserved.
//  字符串扩展

#import "NSString+LHExtensions.h"

#include <CommonCrypto/CommonDigest.h> //md5计算相关

//?////////////////////////////////////////////////////////////////////////
//时间日期操作 操作相关
@implementation NSString (dateTime)

//
// Function   : string2Hour
// Description: 将时间字符串转为小时 以：分隔
// Input      :
//
// Output     :
// Return     : float：转换后的小时数
//
- (float) string2Hour
{
    float ret = 0.0;
    
    NSArray *strArry = [self componentsSeparatedByString:@":"];
    switch (strArry.count)
    {
        case 1://没有分隔符
        {
            ret = [strArry[0] intValue];
        }
        break;
        case 2://只有一个分隔符
        {
            int h = [strArry[0] intValue];
            int m = [strArry[1] intValue];
            ret = h + m/60.0;
        }
        break;
        case 3://有两个分隔符
        {
            int h = [strArry[0] intValue];
            int m = [strArry[1] intValue];
            int s = [strArry[2] intValue];
            ret = h + m/60.0 + s/3600.0;
        }
        break;
    }//end of switch (strArry.count)
    
    return ret;
}

@end

//?////////////////////////////////////////////////////////////////////////
//url 操作相关
@implementation NSString (url)

//
// Function   : decodeUTFContent
// Description: 将URL中utf-8编码的内容解码用户显示
// Input      :
//
// Output     :
// Return     : NSString *：解码内容
//
- (NSString *) decodeUTFContent
{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
}

//
// Function   : getValueFromUrl
// Description: 从url中解析出指定标签的值
// Input      : aLabel:标签名
//
// Output     :
// Return     : NSString *：查找到的值
//
- (NSString *) getValueFromUrl:(NSString *)aLabel
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", aLabel];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    for (NSTextCheckingResult *match in matches)
    {
        NSString *tagValue = [self substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}

@end

@implementation NSString (md5)

//
// Function   : md5
// Description: 字符串生成md5,返回字符串
// Input      : aSrcStr:原字符串
// Output     :
// Return     : NSString *：生成的md5
//
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

//?////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (Data)

//
// Function   : stringWithData
// Description: 字符串生成md5,返回字符串
// Input      : aData:NSData数据
// Output     :
// Return     : NSString *：
//
+ (id) stringWithData: (NSData*) aData
{
    id result = [[NSString alloc] initWithData: aData encoding: NSUTF8StringEncoding];
    
    if (!result) result = [[NSString alloc] initWithData: aData encoding: NSASCIIStringEncoding];
    
    return result;
}

//
// Function   : stringWithCString
// Description: C字符串生成NSString
// Input      : aCString:C字符串
// Output     :
// Return     : NSString *：
//
+ (NSString*) stringWithCString: (const char *) aCString
{
    if (!aCString)
        return nil;
    return [NSString stringWithCString: aCString encoding: NSUTF8StringEncoding];
}

//
// Function   : data
// Description: 字符串转NSData
// Input      :
// Output     :
// Return     : id：
//
- (id) data
{
    return [self dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
}

@end

@implementation NSString (Extensions)

//
// Function   : contains
// Description: 是否包含指定的字符串
// Input      :
// Output     :
// Return     : BOOL：
//
- (BOOL) contains:(NSString *)aSubStr
{
    if (aSubStr)
    {
        return ([self rangeOfString: aSubStr options: 0].location != NSNotFound);
    }
    return NO;
}

- (NSString*) escapedString
{
    return [[[self stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingString: @"&" withString: @"%26"] stringByReplacingString: @"+" withString: @"%2B"];
}

- (NSString*) unescapedString
{
    return [self stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

- (NSRange) rangeBetween: (NSString*) a and: (NSString*) b
{
    if ([self isEqualToString: @""]) return NSMakeRange(NSNotFound,0);
    
    NSRange ra = NSMakeRange(0,0);
    NSRange rb = NSMakeRange([self length]-1,0);
    
    if (a)
    {
        if ([self length] > [a length])
            ra = [self rangeOfString: a];
        else
            ra.location = NSNotFound;
    }
    
    if (b && ra.location != NSNotFound)
    {
        NSRange searchRange = NSMakeRange(ra.location + ra.length, [self length] - ra.location - ra.length);
        if (searchRange.length > 0)
            rb = [self rangeOfString: b options: 0 range: searchRange];
    }
    
    if (ra.location == NSNotFound)
        return NSMakeRange(NSNotFound,0);
    else if (rb.location == NSNotFound)
        return NSMakeRange(ra.location + ra.length, [self length] - ra.location - ra.length);
    else
        return NSMakeRange(ra.location + ra.length, rb.location - ra.location - ra.length);
}

- (NSString*) substringBetween: (NSString*) a and: (NSString*) b
{
    NSRange range = [self rangeBetween: a and: b];
    if (range.location != NSNotFound)
        return [self substringWithRange: range];
    else
        return nil;
}

- (NSString*) stringByRemovingPrefix: (NSString*) thePrefix
{
    if ([self hasPrefix: thePrefix])
    {
        return [self substringFromIndex: [thePrefix length]];
    }
    else
    {
        return self;
    }
}

- (NSString*) stringByRemovingSuffix: (NSString*) theSuffix
{
    if ([self hasSuffix: theSuffix])
    {
        return [self substringToIndex: [self length]-[theSuffix length]];
    }
    else
    {
        return self;
    }
}

- (NSString*) trimmedString
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*) stringByReplacingString: (id) a withString: (id) b
{
    id result = [NSMutableString stringWithString: self];
    [result replaceOccurrencesOfString: a withString: b options: 0 range: NSMakeRange(0, [result length])];
    return result;
}

//
// Function   : stringSizeWithFont
// Description: 指定字体下的文字的实际占用宽高
// Input      : UIFont
// Output     :
// Return     : CGSize：
//
- (CGSize)stringSizeWithFont:(UIFont *)aFont
{
    return [self sizeWithAttributes:@{ NSFontAttributeName : aFont }];
}

//
// Function   : string2Number
// Description: 字符串转为NSNumber
// Input      :
// Output     :
// Return     : NSNumber *：
//
- (NSNumber *)string2Number
{
    if (self.length)
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        return [f numberFromString:self];
    }
    else
    {
        return nil;
    }
}

//
// Function   : subString
// Description: 获取子串
// Input      : aBeginIndex:开始位置，aEndIndex：结束位置
// Output     :
// Return     : NSString *：
//
-(NSString*) subString:(int)aBeginIndex toIndex:(int)aEndIndex
{
    if (aEndIndex <= aBeginIndex)
    {
        return @"";
    }
    
    NSRange range = NSMakeRange(aBeginIndex, aEndIndex - aBeginIndex);
    return [self substringWithRange:range];
}

-(NSArray *) split:(NSString*) separator
{
    return [self componentsSeparatedByString:separator];
}

@end

