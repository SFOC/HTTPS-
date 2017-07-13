//
//  ViewController.m
//  HTTPS证书
//
//  Created by fly on 2017/7/13.
//  Copyright © 2017年 flyfly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSURL *url = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/"];
    [[self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"返回的字符串===%@",html);
    }] resume];
}

#pragma mark ---NSURLSessionTaskDelegate代理---

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    // https工作原理
    // 1.判断身份验证方式是否是服务器验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 2.获取服务器证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 3.信任服务器证书
        completionHandler(0,credential);
    }
}
@end













