// CKRefreshArrowView.m
// 
// Copyright (c) 2012 Instructure, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CKRefreshArrowView.h"
#import <QuartzCore/QuartzCore.h>

#if !__has_feature(objc_arc)
#error Add -fobjc-arc to the compile flags for CKRefreshArrowView.m
#endif

@implementation CKRefreshArrowView {
    CGFloat range;
    CGFloat arrowRadius;
    CGFloat lineWidth;
    
    UIColor *glowColor;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

static void commonSetup(CKRefreshArrowView *self) {
    self.tintColor = [UIColor colorWithWhite:0.5 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    
    self->range = (M_PI * 1.5);
    self.layer.shadowOpacity = 0;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = (CGSizeZero);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        commonSetup(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    commonSetup(self);
}


- (void)setTintColor:(UIColor *)tintColor {
    if (tintColor == nil) {
        tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    _tintColor = tintColor;
    [self calculateGlowColor];
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat minDimension = MIN(self.bounds.size.height, self.bounds.size.width);
    
    arrowRadius = roundf(minDimension * 0.32);
    lineWidth = roundf(arrowRadius * 0.45);
    self.layer.shadowRadius = lineWidth * 0.2;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)drawRect:(CGRect)rect {
    [self updateShapeLayerPath];
    [super drawRect:rect];
}

- (void)calculateGlowColor {
    CGFloat hue = 0, saturation = 0, brightness = 0, alpha = 0;
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([self.tintColor CGColor]);
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome) {
        [self.tintColor getWhite:&brightness alpha:&alpha];
    }
    else {
        [self.tintColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    }
    
    // If it's in the middle, pull toward the extreme. If it's at an extreme, pull toward the middle.
    CGFloat centerThreshold = 0.5;
    CGFloat edgeThreshold = 0.15;
    CGFloat glowFactor = 0.35;
    
    brightness *= alpha;
    CGFloat glowBrightness = 0.0;
    
    if ((brightness > edgeThreshold && brightness <= centerThreshold) || brightness > (1 - edgeThreshold)) {
        // Going darker
        glowBrightness = brightness - glowFactor;
    }
    else {
        // Going lighter
        glowBrightness = brightness + glowFactor;
    }
    glowColor = [UIColor colorWithHue:hue saturation:saturation brightness:glowBrightness alpha:1];
    self.layer.shadowColor = [[UIColor colorWithHue:0 saturation:0 brightness:glowBrightness - 0.3 alpha:0.8] CGColor];
}

- (void)updateShapeLayerPath {
    
    CGFloat effectiveProgress = MIN(self.progress, 1.0);
    BOOL shouldGlow = (self.progress >= 1.0);
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGFloat endAngle = (effectiveProgress * range);
    CGFloat outerRadius = arrowRadius + lineWidth / 2;
    CGFloat innerRadius = arrowRadius - lineWidth / 2;
    
    
    // Start constructing the path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint start = [self pointAtProgress:0 radius:arrowRadius center:center];
    [path moveToPoint:start];
    
    // Arc to the arrow
    [path addArcWithCenter:center
                    radius:outerRadius
                startAngle:0
                  endAngle:endAngle
                 clockwise:YES];
    
    // Build the arrow head
    CGPoint arrowStart = [self pointAtProgress:effectiveProgress radius:outerRadius + lineWidth center:center];
    
    CGPoint tangent = (CGPoint){.x = cosf(endAngle + M_PI_2), .y = sinf(endAngle + M_PI_2)};
    CGPoint arrowTip = [self pointAtProgress:effectiveProgress radius:arrowRadius center:center];
    arrowTip.x += tangent.x * lineWidth * 2;
    arrowTip.y += tangent.y * lineWidth * 2;
    
    CGPoint arrowEnd = [self pointAtProgress:effectiveProgress radius:innerRadius - lineWidth center:center];
    
    [path addLineToPoint:arrowStart];
    [path addLineToPoint:arrowTip];
    [path addLineToPoint:arrowEnd];
    
    // Arc back to the start
    CGPoint innerEnd = [self pointAtProgress:effectiveProgress radius:innerRadius center:center];
    [path addLineToPoint:innerEnd];
    
    [path addArcWithCenter:center
                    radius:innerRadius
                startAngle:endAngle
                  endAngle:0
                 clockwise:NO];
    
    // Wrap it all up
    [path addLineToPoint:start];
    self.shapeLayer.path = [path CGPath];
    
    
    // Animate on/off the glow if we've passed the threshold
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.4];
    self.layer.shadowOpacity = (shouldGlow ? 1.0 : 0.0);
    self.layer.shadowPath = [path CGPath];
    
    CGColorRef targetColor = nil;
    if (shouldGlow) {
        targetColor = [glowColor CGColor];
    }
    else {
        targetColor = [self.tintColor CGColor];
    }
    
    
    if (CGColorEqualToColor(targetColor, self.shapeLayer.fillColor) == NO) {
        self.shapeLayer.fillColor = targetColor;
    }
    [CATransaction commit];
    
}

- (CGPoint)pointAtProgress:(CGFloat)progress radius:(CGFloat)radius center:(CGPoint)center {
    float x = cosf(range * progress) * radius;
    float y = sinf(range * progress) * radius;
    
    x += center.x;
    y += center.y;
    
    return (CGPoint){x, y};
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    // Enable implicit animations for shadow* and fillColor properties
    if ([event hasPrefix:@"shadow"] || [event hasPrefix:@"fillColor"]) {
        return nil;
    }
    return [super actionForLayer:layer forKey:event];
}



@end
