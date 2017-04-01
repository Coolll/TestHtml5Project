//
//  ViewController.m
//  TestHtml5
//https://github.com/Coolll/TestHtml5Project.git
//  Created by 龙培 on 17/3/31.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CustomJSObject.h"

#define PhoneScreen_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PhoneScreen_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIWebViewDelegate>

/**
 *  主webView
 **/
@property (nonatomic,strong) UIWebView *mainWebView;

/**
 *  调用Html方法的按钮
 **/
@property (nonatomic,strong) UIButton *callHtmlButton;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Load Html";
    
    [self loadWebView];
    [self loadCustomButton];
}

- (void)loadCustomButton
{
    self.callHtmlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callHtmlButton.frame = CGRectMake(0, 64, PhoneScreen_WIDTH, 30);
    self.callHtmlButton.backgroundColor = [UIColor lightGrayColor];
    [self.callHtmlButton setTitle:@"OC调用Html方法" forState:UIControlStateNormal];
    [self.view addSubview:self.callHtmlButton];
}

//调用html的方法
- (void)callHtmlMethodAction:(UIButton*)sender
{
    JSContext *context = [self.mainWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    CustomJSObject *object = [CustomJSObject new];
    NSString *textJS = [NSString stringWithFormat:@"methodForOC()"];
    [context evaluateScript:textJS];
    context[@"native"] = object;

}

//加载本地的html文件
- (void)loadWebView
{
    self.mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, PhoneScreen_WIDTH, PhoneScreen_HEIGHT-100)];
    self.mainWebView.delegate = self;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];
    
    
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];

    
    [self.mainWebView loadHTMLString:htmlCont baseURL:baseURL];
    
    [self.view addSubview:self.mainWebView];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载完成后注入object，让我们可以得到html的点击事件
    [self addCustomAction];
    
    //加载完成之后添加按钮的点击事件，点击OC的按钮就能让html响应事件
    [self.callHtmlButton addTarget:self action:@selector(callHtmlMethodAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCustomAction
{
    //获取context，这里的path是固定的
    JSContext *context = [self.mainWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //自定义的JS对象，需要注入到context中
    CustomJSObject *object = [[CustomJSObject alloc]initWithSuccessCallback:^(NSDictionary *dic) {
        
        
        if ([[dic.allKeys firstObject] isEqualToString:@"helloWQL"]) {
            //html调用OC的方法
            NSLog(@"HelloWQLDic:%@",dic);
            [self webViewClickButtonAction];

        }else if ([[dic.allKeys firstObject] isEqualToString:@"sendValueFromHtmlToOCWithValue"]){
            //从html传一个值给OC
            NSLog(@"SendOneValueDic:%@",dic);
            
        }else if ([[dic.allKeys firstObject] isEqualToString:@"sendValueFromHtmlToOCWithValueWithValueTwo"]){
            
            //从html传两个值给OC
            NSLog(@"SendTwoValueDic:%@",dic);
            
        }else if ([[dic.allKeys firstObject] isEqualToString:@"sendValueToHtml"]){
            //从OC传值给html
            NSLog(@"sendValueToHtml:%@",dic);
            
            NSString *name = @"WQL";
            NSString *age = @"22";
            NSString *textJS = [NSString stringWithFormat:@"getUserNameAndAge('%@','%@')",name,age];
            [context evaluateScript:textJS];
            
        }
        
    } faileCallback:^(NSDictionary *dic) {
        NSLog(@"FailDic:%@",dic);

    }];
    
    //这里要使用native，html那边调用的是native
    context[@"native"] = object;

    
}

- (void)webViewClickButtonAction
{
    NSLog(@"OC 接收到 H5按钮点击事件");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
