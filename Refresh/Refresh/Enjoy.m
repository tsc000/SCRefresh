//
//  Enjoy.m
//  Refresh
//
//  Created by tsc on 17/2/21.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "Enjoy.h"

#define LightGray ([[UIColor colorWithRed:214 /255.0 green:214 /255.0 blue:214 /255.0 alpha:1.0] setFill])

@interface Enjoy ()<SCRefreshComponentDelegate>
{
    RefreshState _oldstate;
}
/** 顶部箭头 */
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *smallImageView;

@property (nonatomic, assign) CGFloat imageViewCenterY;

@property (nonatomic, assign) CGFloat contentOffSide;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) BOOL reset;

@property (nonatomic, assign) CGFloat num;

@end

@implementation Enjoy

- (void)prepare {
    [super prepare];
    
    [self createRectWithName:@"2"];
    [self createRectWithName:@"3"];
    [self createFrame];
    
    self.imageView = [self createImageViewWithFrame:CGRectMake(0, - SCTopHeight + (SCTopHeight - 40)/2, SCTopHeight, SCTopHeight)];
    
    self.smallImageView = [self createImageViewWithFrame:CGRectMake(0, - SCTopHeight + (SCTopHeight - 40)/2, 15, 10)];
    
    self.smallImageView.center = self.imageView.center;
    
    self.smallImageView.backgroundColor = [UIColor redColor];
    
}

- (void)placeSubviews {
    
    [super placeSubviews];
    
    self.imageView.centerX = self.scrollView.centerX - self.scrollView.x;
    
    self.smallImageView.center = self.imageView.center;
}

- (void)endRefreshing {
    [super endRefreshing];

    dispatch_cancel(self.timer);
    
    self.timer = nil;
}

- (void)scrollViewContentOffsetChange:(NSDictionary *)change {
    [super scrollViewContentOffsetChange:change];
    
    
    
    [self createCirecle:[change[@"new"] CGPointValue].y];
    
    [self createRectWithName:@"2"];
    [self createRectWithName:@"3"];
    [self createFrame];
    
}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
    
    [super scrollViewContentSizeChange:change];
    
    
}


- (void)normal2pulled:(CGFloat)contentOffSide {
    [super normal2pulled:contentOffSide];
    
    NSString *p =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"2.png"];
    NSLog(@"%@",p);
    
    self.smallImageView.center = self.imageView.center;
    
    [self createCirecle:contentOffSide];
    
    [self createRectWithName:@"2"];
    [self createRectWithName:@"3"];
    [self createFrame];
}

- (void)pulled2nomal:(CGFloat)contentOffSide {
    
    if (self.contentOffSide >= contentOffSide) return;
    
    [self createCirecle:contentOffSide];
    
}

- (void)setState:(RefreshState)state {
    
    //防止重复调用
    SCStateCheck();
    
    if (state == RefreshStateRefreshing) {
        self.num = 1;
        
        self.reset = false;
        
        if (!self.timer) {
            
            dispatch_queue_t queue =dispatch_get_main_queue();
            
            // 创建一个定时器(dispatch_source_t本质还是个OC对象)
            
            self.timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
            
            dispatch_time_t start =dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
            
            uint64_t interval = (uint64_t)(0.07 *NSEC_PER_SEC);
            
            dispatch_source_set_timer(self.timer, start, interval,0);
            
            // 设置回调
            
            dispatch_source_set_event_handler(self.timer, ^{
                
                [self creatMaskLayer:_num];
                _num -= 0.1;
                if (_num <= -0.1) {
                    
                    self.reset = !self.reset;
                    _num = 1;
                }
                
            });
            
            dispatch_resume(self.timer);
            
        }

    }
}

/** 创建箭头 */
- (UIImageView *)createImageViewWithFrame:(CGRect)frame {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.frame = frame;
    
    [self addSubview:imageView];
    
    return imageView;
}

- (void)createRectWithName:(NSString *)name {
    
    NSString *p =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    
    NSLog(@"%@",p);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:p]) return;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(45, 10), NO, 0.0);
    //top
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contex, 1); //设置线宽
    
    /*********************************************/

    [name isEqualToString:@"2"] ? LightGray : [[UIColor blackColor] setFill];
    UIBezierPath *black1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 15, 10) cornerRadius:0];
    CGContextAddPath(contex, black1.CGPath);
    CGContextDrawPath(contex, kCGPathFill);
    
    [name isEqualToString:@"2"] ? [[UIColor blackColor] setFill] : LightGray ;
    UIBezierPath *gray = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 0, 15, 10) cornerRadius:0];
    CGContextAddPath(contex, gray.CGPath);
    CGContextDrawPath(contex, kCGPathFill);
    
    [name isEqualToString:@"2"] ? LightGray : [[UIColor blackColor] setFill];
    UIBezierPath *black2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 0, 15, 10) cornerRadius:0];
    CGContextAddPath(contex, black2.CGPath);
    CGContextDrawPath(contex, kCGPathFill);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 
    NSData *data = UIImagePNGRepresentation(newImage);
    
    UIGraphicsEndImageContext();
    
    [data writeToFile:p atomically:YES];
}

- (void)createFrame {
    
    NSString *p =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"1.png"];
    
    NSLog(@"%@",p);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:p]) return;
    
    //120 60
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(15, 10), NO, 0.0);
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contex, 1); //设置线宽
    
    [[UIColor blackColor] setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath]; //path
    
    [path moveToPoint:CGPointMake(0, 3)];
    [path addCurveToPoint:CGPointMake(15, 3) controlPoint1:CGPointMake(6, -2) controlPoint2:CGPointMake(9, 8)];
    
    [path addLineToPoint:CGPointMake(15,6)];
    
    [path addCurveToPoint:CGPointMake(0, 6) controlPoint1:CGPointMake(9, 11) controlPoint2:CGPointMake(6, 1)];
    
    [path addLineToPoint:CGPointMake(0,3)];
    
    CGContextAddPath(contex, path.CGPath);
    
    CGContextDrawPath(contex, kCGPathFill);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    NSData *data = UIImagePNGRepresentation(newImage);
    
    UIGraphicsEndImageContext();
    
    [data writeToFile:p atomically:YES];
}

- (void)creatMaskLayer:(CGFloat)senderValue {
    
    
    CGFloat value = senderValue / 3.0;
    
    NSLog(@"%lf",value);
    
    NSString *p = nil;
    
    if (!self.reset) {
        p =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"2.png"];
    }
    else {
        p =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"3.png"];
    }
//    NSString *p =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"2.png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:p];
    
    [self addSpriteImage:image withContentRect:CGRectMake(value, 0, value + 0.02, 1) toLayer:self.smallImageView.layer];
    
    //create mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.smallImageView.bounds;
    NSString *p2 =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"1.png"];
    UIImage *maskImage = [UIImage imageWithContentsOfFile:p2];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    //apply mask to image layer￼
    self.smallImageView.layer.mask = maskLayer;
    
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer //set image
{
    layer.contents = (__bridge id)image.CGImage;
    
    //scale contents to fit
    layer.contentsGravity = kCAGravityResize;
    
    //set contentsRect
    layer.contentsRect = rect;
}

- (void)createCirecle:(CGFloat)contentOffSide {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 0.0);
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contex, 1); //设置线宽
    
    CGFloat senderValue = (- contentOffSide -10) / 33.9 ;
    
    CGFloat endA = M_PI * 2;
    
    CGFloat radius = (54 ) * senderValue ;
    
    //外半径最大70
    if (radius > 70) {
        radius = 70;
        
        self.smallImageView.hidden = false;
        
        [self creatMaskLayer:0];
    }
    else {
        self.smallImageView.hidden = true;
    }
    
    self.imageViewCenterY = self.imageView.centerY;
    
    self.contentOffSide = contentOffSide;
    
    //30-----70
    //0 -----61
    //61/40 = 1.522
    //半径为30的时候开始画同心环
    if (radius >= 30) {
        
        CGFloat radius1 = 1.522 * (radius - 30);
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:radius1 startAngle:0 endAngle:endA clockwise:YES];
        [path1 addLineToPoint:CGPointMake(100, 100)];
        
        CGContextAddPath(contex, path1.CGPath);
        
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:radius startAngle:0 endAngle:endA clockwise:YES];
    [path addLineToPoint:CGPointMake(100, 100)];
    
    CGContextAddPath(contex, path.CGPath);
    
    [[UIColor blackColor] setFill];
    
    CGContextDrawPath(contex, kCGPathEOFill);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.layer.contents = (__bridge CALayer * _Nullable)(newImage.CGImage);

    UIGraphicsEndImageContext();

    self.imageView.image = newImage;
    
}

@end
