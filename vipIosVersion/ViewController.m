//
//  ViewController.m
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nullable, nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"http://www.iqiyi.com/"];
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
        if ([requestUrl containsString:@"ynjczy.net"] ||
            [requestUrl containsString:@"ylbdtg.com"] ||
            [requestUrl containsString:@"662820.com"] ||
            [requestUrl containsString:@"api.vparse.org"] ||
            [requestUrl containsString:@"hyysvip.duapp.com"] ||
            [requestUrl containsString:@"f.qcwzx.net.cn"] ||
            [requestUrl containsString:@"adx.dlads.cn"] ||
            [requestUrl containsString:@"dlads.cn"]
            ) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        if ([requestUrl hasSuffix:@".m3u8"]) {
            NSArray *urls = [requestUrl componentsSeparatedByString:@"url="];
            //[VipURLManager sharedInstance].m3u8Url = urls.lastObject;
        }
        else {
            //[VipURLManager sharedInstance].m3u8Url = nil;
        }
        NSLog(@"request.URL.absoluteString = %@",requestUrl);
//        if ([[requestUrl URLDecodedString] hasSuffix:@"clearAllHistory"]) {
//            [self clearAllHistory];
//        }
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
