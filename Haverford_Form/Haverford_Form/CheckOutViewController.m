//
//  CheckOutViewController.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/22/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "CheckOutViewController.h"
#import <BFPaperButton/BFPaperButton.h>
#import <UIColor+BFPaperColors/UIColor+BFPaperColors.h>
#import <Parse/Parse.h>
#import <MailCore/MailCore.h>

@interface CheckOutViewController ()

@property (strong, nonatomic) IBOutlet UITextField *whereTextField;
@property (strong, nonatomic) IBOutlet BFPaperButton *submitButton;


@end

@implementation CheckOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor paperColorRed900];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitButtonclick:(id)sender
{
    PFObject *record = [PFObject objectWithClassName:@"CheckOutRecords"];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    record[@"WhereToGo"] = self.whereTextField.text;
    record[@"Name"] = [settings objectForKey:@"Name"];
    record[@"Email"] = [settings objectForKey:@"Email"];
    record[@"State"] = @"CheckOut";
    record[@"TimeStamp"] = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    [record saveInBackground];
    [self sendCheckOutRecordEmail:self.whereTextField.text];
    [self showAlertViewWithTitle:@"Check-Out" andMessage:@"Check Out Successful"];
}

- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)sendCheckOutRecordEmail:(NSString *)dest
{
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = @"smtp.gmail.com";
    smtpSession.port = 465;
    smtpSession.username = @"thsformvi@gmail.com";
    smtpSession.password = @"Haverford2016";
    smtpSession.authType = MCOAuthTypeSASLPlain;
    smtpSession.connectionType = MCOConnectionTypeTLS;
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *username = [settings objectForKey:@"Name"];
    NSString *userEmail = [settings objectForKey:@"Email"];
    NSString *timeStamp = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSDictionary *recordDic = @{@"UserName":username,@"UserEmail":userEmail,@"TimeStamp":timeStamp,@"Destination":dest};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:recordDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *mailContent = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    MCOAddress *from = [MCOAddress addressWithDisplayName:@"Haverford_Form"
                                                  mailbox:@"thsformvi@gmail.com"];
    MCOAddress *to = [MCOAddress addressWithDisplayName:nil
                                                mailbox:@"thsformvi@gmail.com"];
    [[builder header] setFrom:from];
    [[builder header] setTo:@[to]];
    [[builder header] setSubject:[NSString stringWithFormat:@"%@ check-out to %@", username,dest]];
    [builder setHTMLBody:mailContent];
    NSData * checkinEmaildata = [builder data];
    
    MCOSMTPSendOperation *sendOperation =
    [smtpSession sendOperationWithData:checkinEmaildata];
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"Error sending email: %@", error);
        } else {
            NSLog(@"Successfully sent email!");
        }
    }];
}

@end
