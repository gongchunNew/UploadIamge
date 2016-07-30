//
//  ViewController.m
//  UploadIamge
//
//  Created by 龚纯 on 16/7/30.
//  Copyright © 2016年 龚纯. All rights reserved.
//

#import "ViewController.h"

#define CURRENTIMAGENAME @"currentImage"

@interface ViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) UIImagePickerController *imagePickController;
@property (strong,nonatomic) UIAlertController *alertController;
@property (strong,nonatomic) UIAlertAction *cancelAction;
@property (strong,nonatomic) UIAlertAction *cameraAction;
@property (strong,nonatomic) UIAlertAction *photoAction;
@property (assign) BOOL fullScreen;//判断是否全屏

@property (assign) UIImagePickerControllerSourceType sourceType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)chooseImage:(id)sender {
    _alertController = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    _cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    _cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sourceType = UIImagePickerControllerSourceTypeCamera;
        [self initImagePickController:_sourceType];
    }];
    _photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self initImagePickController:_sourceType];
    }];
    [_alertController addAction:_cancelAction];
    //判断是否可以访问相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_alertController addAction:_cameraAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        [_alertController addAction:_photoAction];
    }
    [self presentViewController:_alertController animated:YES completion:nil];
}

-(void)initImagePickController : (UIImagePickerControllerSourceType)sourceType{
    _imagePickController = [[UIImagePickerController alloc] init];
    _imagePickController.delegate = self;
    _imagePickController.sourceType = sourceType;
    [self presentViewController:_imagePickController animated:YES completion:nil];
}

#pragma image Pick delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"1111");
    [_imagePickController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    [self saveImageWithName:image name:CURRENTIMAGENAME];
    _fullScreen = NO;
    [self.imageView setImage:image];
}

#pragma mark 把图片保存到沙盒
-(void)saveImageWithName :(UIImage*)currentImage name:(NSString*)name
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);//无损压缩图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];

    [imageData writeToFile:fullPath atomically:NO];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _fullScreen = !_fullScreen;
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];//获取点击的点
    
    //判断点击的点 是否在图片范围以内
    if (CGRectContainsPoint(self.imageView.frame, touchPoint)) {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        
        if (_fullScreen) {
            // 放大尺寸
            self.imageView.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            // 缩小尺寸
            self.imageView.frame = CGRectMake(50, 65, 90, 115);
        }
        
        // commit动画
        [UIView commitAnimations];
    }
}
@end
