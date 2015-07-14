//
//  MainViewController.h
//  GLBlender1
//
//  Created by RRC on 9/9/13.
//  Copyright (c) 2013 Ricardo Rendon Cepeda. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface arViewController : GLKViewController<UIGestureRecognizerDelegate>
{
    CGFloat rotateX;
    CGFloat rotateY;
    CGFloat zoom;
    CGFloat rotateZ;
    CGFloat positionX;
    CGFloat positionY;
    BOOL isMove;
    CGFloat lastPositionX;
    CGFloat lastPositionY;
}

@end
