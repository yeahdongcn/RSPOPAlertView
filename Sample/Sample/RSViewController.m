//
//  RSViewController.m
//  Sample
//
//  Created by R0CKSTAR on 14/6/8.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSViewController.h"

#import "RSPOPAlertView.h"

@interface RSViewController ()

@end

@implementation RSViewController

- (IBAction)clicked:(id)sender
{
    [RSPOPAlertView showWithMessage:@"This is a really loooooooooooooooooooooooooooooooooooooooooong message." action:^(id alert, id sender){
        if (sender == [(RSPOPAlertView *)alert cancelButton]) {
            NSLog(@"cancel");
        } else if (sender == [(RSPOPAlertView *)alert otherButton]) {
            NSLog(@"other");
        }
    } cancelButtonTitle:@"" otherButtonTitle:@"Other"];
//    } cancelButtonTitle:@"Cancel" otherButtonTitle:@"Other"];
}

@end
