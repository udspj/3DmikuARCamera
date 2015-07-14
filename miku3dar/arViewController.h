//
//  MainViewController.h
//
//  Created by udspj
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
