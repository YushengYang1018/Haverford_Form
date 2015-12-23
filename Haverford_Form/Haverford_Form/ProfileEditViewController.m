//
//  ProfileEditViewController.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/22/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "ProfileEditViewController.h"
#import <BFPaperButton/BFPaperButton.h>
#import <GoogleSignIn/GIDSignIn.h>
#import "UIColor+Haverford.h"

@interface ProfileEditViewController ()

@property (strong, nonatomic) IBOutlet BFPaperButton *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;




@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(400, 700);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.nameLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    self.nameLabel.textColor = [UIColor haverfordMainRedColor];
    self.emailLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    self.emailLabel.textColor = [UIColor haverfordMainRedColor];
    self.addressLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    self.addressLabel.textColor = [UIColor haverfordMainRedColor];
    self.phoneNumberLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    self.phoneNumberLabel.textColor = [UIColor haverfordMainRedColor];
    
    self.view.backgroundColor = [UIColor haverfordMainBackgroundColor];
    
    NSLog(@"contentSize width %f", self.scrollView.contentSize.width);
    NSLog(@"contentSize height %f", self.scrollView.contentSize.height);
    
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [UIColor haverfordMainRedColor];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([[GIDSignIn sharedInstance]hasAuthInKeychain]) {
        self.nameTextField.text = [settings objectForKey:@"Name"];
        self.emailTextField.text = [settings objectForKey:@"Email"];
    }
    
    if ([settings objectForKey:@"Address"]) {
        self.addressTextField.text = [settings objectForKey:@"Address"];
    }
    if ([settings objectForKey:@"Email"]) {
        self.phoneNumberTextField.text = [settings objectForKey:@"Phone"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveButtonClicked:(id)sender
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"Name"];
    [settings removeObjectForKey:@"Email"];
    [settings removeObjectForKey:@"Address"];
    [settings removeObjectForKey:@"Phone"];
    
    [settings setObject:self.nameTextField.text forKey:@"Name"];
    [settings setObject:self.emailTextField.text forKey:@"Email"];
    [settings setObject:self.addressTextField.text forKey:@"Address"];
    [settings setObject:self.phoneNumberTextField.text forKey:@"Phone"];
    [settings synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
