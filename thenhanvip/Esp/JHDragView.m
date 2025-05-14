#import "JHDragView.h"
#define asconfig_h
#define asconfig @"https://yt3.googleusercontent.com/N8TKXoH8ZMSmYxiHU2X44tRrmtycKrvNsnfohEbba2I_Ji8SHRjBZW8US_etIcLn9pg6XiY4NOg=s160-c-k-c0x00ffffff-no-rj"

@implementation JHDragView

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectGetWidth(frame) <= 0 || CGRectGetHeight(frame) <= 0) {
        frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 130, 60, 60);
    }

    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.20];
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.clipsToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
        self.alpha = 1.0; // Alpha chỉ nên từ 0.0 đến 1.0

        // Tải ảnh từ URL
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageURL = [NSURL URLWithString:asconfig];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData];
            
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.layer.contents = (id)image.CGImage;
                });
            }
        });
    }
    return self;
}

#pragma mark - override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    self.center = point;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self shouldResetFrame];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self shouldResetFrame];
}

#pragma mark - private

- (void)shouldResetFrame {
    CGFloat midX = CGRectGetWidth(self.superview.frame) * 0.5;
    CGFloat midY = CGRectGetHeight(self.superview.frame) * 0.5;
    CGFloat maxX = midX * 2;
    CGFloat maxY = midY * 2;
    CGRect frame = self.frame;

    if (CGRectGetMinX(frame) < 0 || CGRectGetMidX(frame) <= midX) {
        frame.origin.x = 0;
    } else if (CGRectGetMidX(frame) > midX || CGRectGetMaxX(frame) > maxX) {
        frame.origin.x = maxX - CGRectGetWidth(frame);
    }

    if (CGRectGetMinY(frame) < 0) {
        frame.origin.y = 0;
    } else if (CGRectGetMaxY(frame) > maxY) {
        frame.origin.y = maxY - CGRectGetHeight(frame);
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    }];
}

@end
