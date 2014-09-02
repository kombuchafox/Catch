//
//  AddMessageViewController.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/14/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMessageViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *messageView;
@property NSString *defaultMessage;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;
@property NSString *message;
@end
