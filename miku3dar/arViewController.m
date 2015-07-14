//
//  MainViewController.m
//
//  Created by udspj
//

#import "arViewController.h"
#import "miku.h"


@interface arViewController ()

@property (strong, nonatomic) GLKBaseEffect* effect;

@end

@implementation arViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rotateX = 0.0f;
    rotateY = 0.0f;
    zoom = -20.0f;
    rotateZ = 0.0f;
    positionX = 0.0f;
    positionY = -20.0f;
    isMove = YES;
    
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView* glkview = (GLKView *)self.view;
    glkview.context = context;
    glkview.delegate = self;
    glkview.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    CAEAGLLayer*gllayer = (CAEAGLLayer*) glkview.layer;
    gllayer.opaque = YES;
    
    [self createEffect];
    
    
// 拖动 和 旋转
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(30.0f, 30.0f, 50.0f, 30.0f)];
    switchView.on = YES;
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 30.0f, 100.0f, 30.0f)];
    label.text = @"isMove";
    [self.view addSubview:label];
    
    
// GestureRecognizer
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)createEffect
{
    self.effect = [[GLKBaseEffect alloc] init];
    
    glEnable(GL_DEPTH_TEST);
    
// Texture
    NSDictionary* options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"miku_xx_tx_head_01" ofType:@"bmp"];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(texture == nil)
    {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    
    self.effect.texture2d0.name = texture.name;
    self.effect.texture2d0.enabled = true;
    
// Light
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.position = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.lightingType = GLKLightingTypePerPixel;
}

- (void)setMatrices
{
// Projection Matrix
    const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
    const GLfloat fieldView = GLKMathDegreesToRadians(100.0f);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 1000.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
// ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, positionX, positionY, zoom);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(rotateX));
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(rotateY));
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_CULL_FACE);
    
    [self.effect prepareToDraw];
    
    [self setMatrices];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, mikuPositions);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, mikuTexels);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, mikuNormals);
    
    glDrawArrays(GL_TRIANGLES, 0, mikuVertices);
}

#pragma mark - Gesture Recognizer

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    NSLog(@"scale %f",recognizer.scale);
    zoom += recognizer.scale - 1;
    if (zoom > -10.0f)
    {
        zoom = -10.0f;
    }
    if (zoom < -50)
    {
        zoom = -50.0f;
    }
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    NSLog(@"scale %@",NSStringFromCGPoint(translation));
    
    if (isMove)
    {
        positionX = translation.x / 10;
        positionY = - translation.y / 10 - 20;
    }
    else
    {
        rotateX += translation.y / 50;
        rotateY += translation.x / 50;
    }
}

-(void)switchAction:(UISwitch *)sender
{
    isMove = !isMove;
}


@end
