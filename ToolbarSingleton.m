//
//  ToolbarSingleton.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/6/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "ToolbarSingleton.h"
@interface ToolbarSingleton()
{
    NSString *defaultCharacterCount;
}
@end
@implementation ToolbarSingleton
+ (id)sharedManager {
    static ToolbarSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        defaultCharacterCount = @"100";
        [self createInputAccessoryView];
    }
    return self;
}
-(void) reset
{
    self.characterCount.text = defaultCharacterCount;
}
-(void)createInputAccessoryView{
    //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    //[self.keyboardToolbar addGestureRecognizer:tapGesture];


    self.keyboardToolbar = [[UIToolbar alloc] init];
    self.keyboardToolbar.translucent = YES;
    self.keyboardToolbar.barTintColor = [UIColor lightGrayColor];
    UIView *keyBoard = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];

    self.keyboardToolbar.frame = CGRectMake(0, keyBoard.frame.origin.y - 35, [UIScreen mainScreen].bounds.size.width, 35);
    self.addPictureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35,35)];
    [self.addPictureButton setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:self.addPictureButton];
    
    
    //Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil action:nil];
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self action:nil];
    self.characterCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    self.characterCount.text = defaultCharacterCount;
    self.characterCount.textColor = [UIColor whiteColor];
    UIBarButtonItem *characterLabel = [[UIBarButtonItem alloc] initWithCustomView:self.characterCount];
    doneItem.tintColor = [UIColor whiteColor];
    doneItem.customView = self.doneButton;
    NSArray *items = [NSArray arrayWithObjects:cameraItem, flexItem, characterLabel, flexItem, doneItem, nil];
    [self.keyboardToolbar setItems:items animated:YES];
    
    //[self.view addSubview:self.keyboardToolbar];
    
}

-(void) doneButton: (UITapGestureRecognizer *) sender
{
    [self.delegate doneButton];
}

-(void) changeDoneButtonTitle:(NSString *) title
{
    [self.doneButton setTitle:title forState:UIControlStateNormal];
}
@end
