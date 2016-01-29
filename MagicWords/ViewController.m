//
//  ViewController.m
//  MagicWords
//
//  Created by TuTu on 16/1/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ViewController.h"
@import CoreText ;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(20.0f, 64.0f,
                                           CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                           CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view.layer addSublayer:self.animationLayer];
    
    // [self setupDrawingLayer];
    [self setupTextLayer];
    [self startAnimation];
}


- (void) setupTextLayer
{
    if (self.pathLayer != nil) {
//        [self.penLayer removeFromSuperlayer];
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
//        self.penLayer = nil;
    }
    
    // Create path from text
    // See: http://www.codeproject.com/KB/iPhone/Glyph.aspx
    // License: The Code Project Open License (CPOL) 1.02 http://www.codeproject.com/info/cpol10.aspx
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 32.0f, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"谢天宸来了呵呵呵呵呵!"
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    //pathLayer.backgroundColor = [[UIColor yellowColor] CGColor];
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1].CGColor;
    // pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.animationLayer addSublayer:pathLayer];
    self.animationLayer.speed = 0;
    self.animationLayer.timeOffset = 0;
    
    self.pathLayer = pathLayer;
    
    //    UIImage *penImage = [UIImage imageNamed:@"noun_project_347_2.png"];
    //    CALayer *penLayer = [CALayer layer];
    //    penLayer.contents = (id)penImage.CGImage;
    //    penLayer.anchorPoint = CGPointZero;
    //    penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
    //    [pathLayer addSublayer:penLayer];
    //
    //    self.penLayer = penLayer;
}



- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
//    [self.penLayer removeAllAnimations];
    
//    self.penLayer.hidden = NO;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0 ;
    pathAnimation.fromValue = @(0.) ;
    pathAnimation.toValue = @(1.) ;
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
//    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    penAnimation.duration = 10.0;
//    penAnimation.path = self.pathLayer.path;
//    penAnimation.calculationMode = kCAAnimationPaced;
//    penAnimation.delegate = self;
//    [self.penLayer addAnimation:penAnimation forKey:@"position"];
}

- (IBAction)sliderbarchanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.animationLayer.timeOffset = slider.value;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
