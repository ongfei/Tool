//
//  WebViewController.m
//  MobileBusiness
//
//  Created by SINOKJ on 16/4/18.
//  Copyright © 2016年 中嘉信诺. All rights reserved.
//

#import "WebViewController.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webV;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.title = _titleStr;
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.superBtn];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeNone)];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    rightBtn.frame = CGRectMake(0, 2, 20, 20);
//    
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    
//    [rightBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//
    self.webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.webV];
    self.webV.backgroundColor = [UIColor whiteColor];
    self.webV.delegate = self;
    
    self.webV.scalesPageToFit = YES;
    
        
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *js = @"function imgAutoFit() { \
//    var imgs = document.getElementsByTagName('img'); \
//    for (var i = 0; i < imgs.length; ++i) {\
//    var img = imgs[i];   \
//    img.style.maxWidth = %f;   \
//    } \
//    }";
//    js = [NSString stringWithFormat:js, ([UIScreen mainScreen].bounds.size.width - 100)];
//    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeNone)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

//- (void)shareClick {
//    //1、创建分享参数
////    NSArray* imageArray = [NSArray arrayWithObject:[UIImage imageNamed:@"qqicon"]];
////    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (true) {
//        
//       
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        
////        NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
//        [shareParams SSDKSetupShareParamsByText:self.shareDescribe == nil? @"" : self.shareDescribe
//                                         images:self.shareImage == nil? @[[UIImage imageNamed:@"shareImg"]] :@[self.shareImage]
//                                            url:[NSURL URLWithString:self.str]
//                                          title:self.shareTitle == nil? @"" : self.shareTitle
//                                           type:SSDKContentTypeAuto];
//
//        
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//}


@end
