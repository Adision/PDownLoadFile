//
//  ViewController.m
//  PDownLoadFile
//
//  Created by Apple on 2017/1/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "PDownClass.h"

@interface ViewController ()

@property(nonatomic,strong)UIImageView*imageView;
@property(nonatomic,strong)UIProgressView*progressView;
@property(nonatomic,strong)UILabel*percentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //图片
    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width,200)];
    [self.view addSubview:self.imageView];
    
    //进度条
    self.progressView=[[UIProgressView alloc] initWithFrame:CGRectMake(50, 300,self.view.frame.size.width-130,10)];
    self.progressView.progressTintColor=[UIColor redColor];
    self.progressView.trackTintColor=[UIColor lightGrayColor];
    self.progressView.progressViewStyle=UIProgressViewStyleBar;
    [self.view addSubview:self.progressView];
    
    //下载百分比
    self.percentLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.progressView.frame.origin.x+self.progressView.frame.size.width+5, self.progressView.frame.origin.y-15,100,30)];
    self.percentLabel.textColor=[UIColor blackColor];
    [self.view addSubview:self.percentLabel];
    
    UIButton*downButton=[UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame=CGRectMake(self.view.center.x-40,self.view.center.y+50,80, 44);
    [downButton setTitle:@"下载" forState:UIControlStateNormal];
    downButton.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:downButton];
    [downButton addTarget:self action:@selector(downButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)downButtonAction
{
    self.progressView.progress=0.0;
    __weak typeof(self) weakSelf = self;
    [PDownClass judgeNetwork:^(PNetworkReachabilityStatus status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (status!=2) {//非wifi状态
            [strongSelf showAlert];
        }else{
            [strongSelf downLoadFile];
        }
    }];
}
-(void)showAlert
{
    UIAlertController*alertCtl=[UIAlertController alertControllerWithTitle:nil message:@"非wifi状态确定要下载?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self downLoadFile];
    }];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:sure];
    [alertCtl addAction:cancel];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

-(void)downLoadFile
{
    NSString*url=@"http://img.ivsky.com/img/bizhi/slides/201611/21/yourname-008.jpg";
    
    //请求
    [PDownClass downFileWitchUrl:url progress:^(NSProgress *downloadProgress) {
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            self.percentLabel.text=[NSString stringWithFormat:@"%.0f%%",self.progressView.progress*100];
        });
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"filePath=%@\n error=%@",filePath,error);
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
        self.imageView.image = img;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
