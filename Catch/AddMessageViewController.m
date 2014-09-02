//
//  AddMessageViewController.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/14/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "AddMessageViewController.h"
@interface AddMessageViewController()
@property (strong, nonatomic) IBOutlet UIView *messageContainerView;

@end

@implementation AddMessageViewController
@synthesize messageContainerView;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.messageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageView.layer.borderWidth = 1;
    self.messageView.layer.cornerRadius = 1;
    self.messageView.textColor = [UIColor darkGrayColor];
    self.messageContainerView.layer.cornerRadius = 5;
    self.messageContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageContainerView.layer.borderWidth = 1;
    [self.messageView becomeFirstResponder];
    
}


- (IBAction)doneEditing:(UIButton *)sender {
    
    self.message = self.messageView.text;
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark textView delegate
-(BOOL) textViewShouldBeginEditing:(UITextView *) textView
{
    return true;
}
-(void) textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        self.messageView.textColor = [UIColor lightGrayColor];
        self.messageView.text = self.defaultMessage;
        [self.messageView resignFirstResponder];
    }
    if (textView.text.length > 121) {
        textView.text = [textView.text substringToIndex:121];
    }
    self.characterCount.text = [NSString stringWithFormat:@"%d", textView.text.length];
}


@end
