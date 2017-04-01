//
//  CustomJSObject.h
//  TestHtml5
//https://github.com/Coolll/TestHtml5Project.git
//  Created by 龙培 on 17/3/31.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


typedef void(^JSObjectBlock)(NSDictionary *dic);

@protocol CustomJSProtocol <JSExport>
//Html调用OC方法
- (void)helloWQL;

//从html传一个值给OC
- (void)sendValueFromHtmlToOCWithValue:(NSString*)value;

//从html传两个值给OC
- (void)sendValueFromHtmlToOCWithValue:(NSString*)value WithValueTwo:(NSString*)valueTwo;

//从OC传值给Html
- (void)sendValueToHtml;

@end


@interface CustomJSObject : NSObject <CustomJSProtocol>

- (id)initWithSuccessCallback:(JSObjectBlock)success faileCallback:(JSObjectBlock)fail;

@end
