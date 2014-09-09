//
//  ToolbarSingleton.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/6/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ToolbarSingletonDelegate
-(void) doneButton;
-(void) addPictureButton;
@end
@interface ToolbarSingleton : NSObject
+ (id)sharedManager;

@property UIButton *addPictureButton;
@property UIButton *doneButton;
@property UIToolbar *keyboardToolbar;
@property UILabel *characterCount;
@property id<ToolbarSingletonDelegate> delegate;
-(void) changeDoneButtonTitle:(NSString *) title;
@end
