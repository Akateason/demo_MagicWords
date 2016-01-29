//
//  ViewController.h
//  MagicWords
//
//  Created by TuTu on 16/1/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@import QuartzCore ;

@interface ViewController : UIViewController
{
    CALayer *_animationLayer;
    CAShapeLayer *_pathLayer;
    CALayer *_penLayer;
}

@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;

@end

