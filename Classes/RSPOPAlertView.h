//
//  RSPOPAlertView.h
//  RSPOPAlertView
//
//  Created by R0CKSTAR on 14/6/8.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSPlainButton.h"

typedef void(^AlertActionEvent)(id alert, id sender);

@interface RSPOPAlertView : UIView

@property (nonatomic, weak) IBOutlet RSPlainButton *cancelButton;

@property (nonatomic, weak) IBOutlet RSPlainButton *otherButton;

+ (void)showWithMessage:(NSString *)message action:(AlertActionEvent)action cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

@end
