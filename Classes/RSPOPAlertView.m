//
//  RSPOPAlertView.m
//  RSPOPAlertView
//
//  Created by R0CKSTAR on 14/6/8.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSPOPAlertView.h"

#import <POP.h>

#define SharedWindow ((UIWindow *)[[[UIApplication sharedApplication] delegate] window])
#define LoadXib(name) [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject]

@interface RSPOPAlertView ()

@property (nonatomic, weak) IBOutlet UIView *background;

@property (nonatomic, weak) IBOutlet UIView *alert;

@property (nonatomic, weak) IBOutlet UILabel *text;

@property (nonatomic, weak) IBOutlet RSPlainButton *singleButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *y;

@property (nonatomic, copy) AlertActionEvent action;

@end

@implementation RSPOPAlertView

- (void)show
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.2);
    [self.background.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [self.alert.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    positionAnimation.toValue = @(0);
    positionAnimation.springBounciness = 4;
        [self.y pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.95f, 0.95f)];
    [self.alert.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)dismiss
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [[[self class] sharedAlertView] removeFromSuperview];
        }
    };
    [self.background.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [self.alert.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    positionAnimation.toValue = @(-SharedWindow.bounds.size.height / 2 - self.alert.bounds.size.height / 2);
    positionAnimation.springBounciness = 4;
    [self.y pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.95f, 0.95f)];
    [self.alert.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)resetButtonAction
{
    self.cancelButton.click = ^(id sender) {
        if (self.action) {
            self.action(self, sender);
        }
        [self dismiss];
    };
    
    self.otherButton.click = ^(id sender) {
        if (self.action) {
            self.action(self, sender);
        }
        [self dismiss];
    };
    
    self.singleButton.click = ^(id sender) {
        if (self.action) {
            NSString *cancelButtonTitle = [self.cancelButton titleForState:UIControlStateNormal];
            if (cancelButtonTitle && ![cancelButtonTitle isEqualToString:@""]) {
                self.action(self, self.cancelButton);
            } else {
                self.action(self, self.otherButton);
            }
        }
        [self dismiss];
    };
}

+ (instancetype)sharedAlertView
{
    static RSPOPAlertView *sharedAlertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAlertView = LoadXib(@"RSPOPAlertView");
    });
    return sharedAlertView;
}

- (void)awakeFromNib
{
    self.frame = SharedWindow.bounds;
    self.backgroundColor = [UIColor clearColor];
    
    self.background.layer.opacity = 0;
    self.background.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    self.alert.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    
    self.cancelButton.backgroundColor = [UIColor orangeColor];
    self.otherButton.backgroundColor = [UIColor orangeColor];
    self.singleButton.backgroundColor = [UIColor orangeColor];
}

+ (void)showWithMessage:(NSString *)message action:(AlertActionEvent)action cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    RSPOPAlertView *alert = [[self class] sharedAlertView];
    alert.text.text = message;
    if (cancelButtonTitle && otherButtonTitle
        && ![cancelButtonTitle isEqualToString:@""]
        && ![otherButtonTitle isEqualToString:@""]) {
        [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [alert.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        [alert.singleButton setTitle:@"" forState:UIControlStateNormal];
        alert.singleButton.hidden = YES;
        alert.cancelButton.hidden = NO;
        alert.otherButton.hidden = NO;
    } else {
        [alert.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [alert.otherButton setTitle:@"" forState:UIControlStateNormal];
        [alert.singleButton setTitle:(cancelButtonTitle && ![cancelButtonTitle isEqualToString:@""]) ? cancelButtonTitle : otherButtonTitle forState:UIControlStateNormal];
        alert.singleButton.hidden = NO;
        alert.cancelButton.hidden = YES;
        alert.otherButton.hidden = YES;
    }
    alert.y.constant = -SharedWindow.bounds.size.height / 2 - alert.alert.bounds.size.height / 2;
    alert.action = action;
    [alert resetButtonAction];
    [SharedWindow addSubview:alert];
    [alert show];
}

@end
