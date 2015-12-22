//
//  ProfileTableViewCell.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import <UIColor+BFPaperColors/UIColor+BFPaperColors.h>

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.keyTextLabel.textColor = [UIColor paperColorRed900];
        self.keyTextLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
        self.valueTextLabel.textColor = [UIColor paperColorRed900];
        self.valueTextLabel.font = [UIFont fontWithName:@"Noteworthy-Light " size:17.0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
