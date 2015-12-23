//
//  ProfileViewController.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "ProfileViewController.h"
#import <BFPaperButton/BFPaperButton.h>
#import "UIColor+Haverford.h"
#import "ProfileTableViewCell.h"
#import "UserInformation.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet BFPaperButton *signinButton;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet BFPaperButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIView *topContentView;


@property (strong,nonatomic)NSArray *tableViewHeaderArray;
@property (strong,nonatomic)NSDictionary *tableViewContentKeyArray;

@end

static NSString *identifier = @"ProfileTableViewCellIdentifier";

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewHeaderArray = @[@"Basic", @"Other"];
    self.tableViewContentKeyArray = @{@"Basic":@[@"Name",@"Email"],
                                      @"Other":@[@"Address",@"Phone"]};
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor haverfordMainBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    self.topContentView.backgroundColor = [UIColor haverfordMainRedColor];
    self.userNameLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    self.userNameLabel.textColor = [UIColor haverfordUtilLightGoldColor];
    
    //Google signin
    [GIDSignIn sharedInstance].uiDelegate = self;
    [self.signinButton setTitle:@"Sign In With Haverford" forState:UIControlStateNormal];
    self.signinButton.backgroundColor = [UIColor haverfordUtilDarkGoldColor];
    [self.signinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.logoutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    self.logoutButton.backgroundColor = [UIColor haverfordUtilDarkGoldColor];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView) name:@"GoogleDidSignInNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:@"Name"]) {
        self.userNameLabel.hidden = NO;
        self.signinButton.hidden = YES;
        self.userNameLabel.text =[settings objectForKey:@"Name"];
        self.logoutButton.hidden = NO;
    } else {
        self.userNameLabel.hidden = YES;
        self.signinButton.hidden = NO;
        //sign in button
        self.signinButton.isRaised = YES;
        self.logoutButton.hidden = YES;
    }
    
    //User Image
    self.profileImageView.layer.cornerRadius = 60;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.image = [UIImage imageNamed:@"Logo.jpg"];
    
    if ([settings objectForKey:@"UserImageURL"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:[settings objectForKey:@"UserImageURL"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImageView.image = image;
            });
        });
    }
    [self.tableView reloadData];
}

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions
- (IBAction)signInButtonClicked:(id)sender
{
    [[GIDSignIn sharedInstance]signIn];
}


- (IBAction)logoutButtonClick:(id)sender {
    [[GIDSignIn sharedInstance]signOut];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UserId"];
    [settings removeObjectForKey:@"Name"];
    [settings removeObjectForKey:@"Email"];
    [settings removeObjectForKey:@"UserImageURL"];
    [settings removeObjectForKey:@"Address"];
    [settings removeObjectForKey:@"Phone"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)reloadView
{
    [self.tableView reloadData];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    self.userNameLabel.hidden = NO;
    self.signinButton.hidden = YES;
    self.userNameLabel.text =[settings objectForKey:@"Name"];
    self.logoutButton.hidden = NO;
    NSURL *url = [NSURL URLWithString:[settings objectForKey:@"UserImageURL"]];
    NSLog(@"imageurlstring --> %@",url);
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.profileImageView.image = image;
    
}


#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewHeaderArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *header = [self.tableViewHeaderArray objectAtIndex:section];
    return [[self.tableViewContentKeyArray objectForKey:header] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProfileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *header = [self.tableViewHeaderArray objectAtIndex:section];
    NSString *keyString = [[self.tableViewContentKeyArray objectForKey:header] objectAtIndex:row];
    cell.keyTextLabel.text = keyString;
    cell.keyTextLabel.textColor = [UIColor haverfordMainRedColor];
    cell.keyTextLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:keyString]) {
        cell.valueTextLabel.text = [settings objectForKey:keyString];
    } else {
        cell.valueTextLabel.text = @"";
    }
    cell.valueTextLabel.textColor = [UIColor haverfordMainRedColor];
    cell.valueTextLabel.font = [UIFont fontWithName:@"Noteworthy-Light " size:17.0];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableViewHeaderArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    }
    return 20.0;
}



@end
