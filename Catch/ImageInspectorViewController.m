//
//  ImageInspectorViewController.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/1/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "ImageInspectorViewController.h"

@interface ImageInspectorViewController ()

@end

@implementation ImageInspectorViewController
@synthesize image;
-(void)setImage:(UIImage *)newValue
{
    image = newValue;
    UIImageView *uiimage = [[UIImageView alloc] initWithFrame:self.view.frame];
    uiimage.image = newValue;
    [self.view addSubview: uiimage];
    
}
-(UIImage *)image
{
    return  image;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUp];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    // Do any additional setup after loading the view.
}
-(void) setUp
{
    [self.backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissViewController:(UIButton *)sender {
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
