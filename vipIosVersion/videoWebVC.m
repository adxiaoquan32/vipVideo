//
//  videoWebVC.m
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//

#import "videoWebVC.h"
#import <WebKit/WebKit.h>
#import "NSObject+apiManager.h"
#import "Masonry.h"

@class viAlertAction;
@interface videoWebVC ()<WKUIDelegate,WKNavigationDelegate>

@property (nullable, nonatomic, strong) WKWebView *webview;

@end

@implementation videoWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"线路" style:UIBarButtonItemStylePlain target:self action:@selector(onVipTransferBtnClick:)];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtnClick:)];
   
}

- (void)onBackBtnClick:(id)sender{
    
    if ( [self.webview canGoBack]) {
        [self.webview goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)setPlatformDic:(NSDictionary *)platformDic{
    _platformDic = platformDic;
   NSURL *url = [NSURL URLWithString:platformDic[@"url"]];
   NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
   [self.webview loadRequest:request];
    
}

- (void)onVipTransferBtnClick:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用破解线路" message:nil preferredStyle:UIAlertControllerStyleAlert];

    __weak typeof(self) weakSelf = self;
    [self.tranferList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        viAlertAction *action = [viAlertAction actionWithTitle:obj[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            viAlertAction *vaction = (viAlertAction *)action;
            [weakSelf.webview evaluateJavaScript:@"document.location.href" completionHandler:^(id _Nullable url, NSError * _Nullable error) {
                    NSString *originUrl = [[url componentsSeparatedByString:@"url="] lastObject];
                    if (![url hasPrefix:@"http"]) {
                        return ;
                    }
                    NSString *finalUrl = [NSString stringWithFormat:@"%@%@", vaction.platformDic[@"url"]?:@"",originUrl?:@""];
                    NSString * encodingString = [finalUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodingString]];
                    [weakSelf.webview loadRequest:request];
                }];
        }];
        action.platformDic = obj;
        [alertController addAction:action];
    }];
    
    viAlertAction *action = [viAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
     
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
        
        _webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator = NO;
        _webview.allowsLinkPreview = NO;
        _webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [_webview setAllowsBackForwardNavigationGestures:YES];
        [self.view addSubview:_webview];
        __weak typeof(self) weakSelf = self;
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
                make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(weakSelf.view.mas_bottom);
                make.top.equalTo(weakSelf.view);
            }
        }];
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
        NSLog(@"__url:%@",navigationAction.request.URL);
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


@implementation viAlertAction
@end
