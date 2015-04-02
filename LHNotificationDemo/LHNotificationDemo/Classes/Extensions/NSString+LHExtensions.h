//
//  NSString+LHExtensions.h
//  NSString+Extensions
//
//  Created by 李辉 on 15/3/9.
//  Copyright (c) 2015年 gushiwen.org. All rights reserved.
//

#import <Foundation/Foundation.h>


//?////////////////////////////////////////////////////////////////////////
//时间日期操作 操作相关
@interface NSString (dateTime)

//
// Function   : string2Hour
// Description: 将时间字符串转为小时 以：分隔
// Input      :
//
// Output     :
// Return     : float：转换后的小时数
//
- (float) string2Hour;

@end

//?////////////////////////////////////////////////////////////////////////
//url 操作相关
@interface NSString (url)

//
// Function   : decodeUTFContent
// Description: 将URL中utf-8编码的内容解码用户显示
// Input      :
//
// Output     :
// Return     : NSString *：解码内容
//
- (NSString *) decodeUTFContent;

//
// Function   : getValueFromUrl
// Description: 从url中解析出指定标签的值
// Input      : aLabel:标签名
//
// Output     :
// Return     : NSString *：查找到的值
//
- (NSString *) getValueFromUrl:(NSString *)aLabel;

@end

//?/////////////////////////////////////////////////////////////////////////
//字符串转md5
@interface NSString (md5)

//
// Function   : md5
// Description: 字符串生成md5,返回字符串
// Input      :
// Output     :
// Return     : NSString *：生成的md5
//
- (NSString *)md5;

@end

//?/////////////////////////////////////////////////////////////////////////
//NSString初始化
@interface NSString (Data)

//
// Function   : stringWithData
// Description: 字符串生成md5,返回字符串
// Input      : aData:NSData数据
// Output     :
// Return     : NSString *：
//
+ (id) stringWithData: (NSData*) aData;

//
// Function   : stringWithCString
// Description: C字符串生成NSString
// Input      : aCString:C字符串
// Output     :
// Return     : NSString *：
//
+ (NSString*) stringWithCString: (const char *) aCString;

//
// Function   : data
// Description: 字符串转NSData
// Input      :
// Output     :
// Return     : id：
//
- (id) data;

@end


@interface NSString (Extensions)

//
// Function   : stringSizeWithFont
// Description: 指定字体下的文字的实际占用宽高
// Input      : UIFont
// Output     :
// Return     : CGSize：
//
- (CGSize)stringSizeWithFont:(UIFont *)aFont;

//
// Function   : string2Number
// Description: 字符串转为NSNumber
// Input      :
// Output     :
// Return     : NSNumber *：
//
- (NSNumber *)string2Number;

//
// Function   : contains
// Description: 是否包含指定的字符串
// Input      :
// Output     :
// Return     : BOOL：
//
- (BOOL) contains:(NSString *)aSubStr;

- (NSString*) escapedString;
- (NSString*) unescapedString;

//
// Function   : subString
// Description: 获取子串
// Input      : aBeginIndex:开始位置，aEndIndex：结束位置
// Output     :
// Return     : NSString *：
//
-(NSString*) subString:(int)aBeginIndex toIndex:(int)aEndIndex;

-(NSArray*) split:(NSString*) separator;

- (NSRange) rangeBetween: (NSString*) a and: (NSString*) b;
- (NSString*) substringBetween: (NSString*) a and: (NSString*) b;

- (NSString*) stringByRemovingPrefix: (NSString*) thePrefix;
- (NSString*) stringByRemovingSuffix: (NSString*) theSuffix;
- (NSString*) trimmedString;

- (NSString*) stringByReplacingString: (id) a withString: (id) b;

@end
