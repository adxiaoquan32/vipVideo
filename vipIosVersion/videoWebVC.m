//
//  ViewController.m
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "NSObject+apiManager.h"

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nullable, nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
   
}

- (void)setPlatformDic:(NSDictionary *)platformDic{
    _platformDic = platformDic; 
   NSURL *url = [NSURL URLWithString:platformDic[@"url"]];
   NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
   [self.webview loadRequest:request];
    
}


- (WKWebView *)webview{
    if ( !_webview ) {
         
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 启动驱动，否则flash不可播
//        configuration.preferences.plugInsEnabled = YES;
//        configuration.preferences.javaEnabled = YES;
 
        if (@available(iOS 10.0, *)) {
            configuration.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        _webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        
        [self.view addSubview:_webview];
        
    }
    return _webview;
}
  
 
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *requestUrl = navigationAction.request.URL.absoluteString;
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    if (navigationAction.request.URL.absoluteString.length > 0) {
        // 拦截广告
        __block BOOL isAdUrl = NO;
        [self.adUrlList enumerateObjectsUsingBlock:^(NSDictionary *urlDic, NSUInteger idx, BOOL * _Nonnull stop) {
            isAdUrl = [requestUrl containsString:urlDic[@"url"]];
            if ( isAdUrl ) {
                *stop = YES;
            }
        }];
        if ( isAdUrl ) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"createWebViewWithConfiguration  request     %@",navigationAction.request);
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
//    [VipURLManager sharedInstance].finalUrl = webView.URL.absoluteString;
//    [self saveHistoryUrl:webView.URL.absoluteString title:webView.title];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    //[VipURLManager sharedInstance].finalUrl = webView.URL.absoluteString;
}

 


@end
