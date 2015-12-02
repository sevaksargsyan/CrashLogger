//
//  DetailViewController.h
//  CrashLogger
//
//  Created by SS on 12/1/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

