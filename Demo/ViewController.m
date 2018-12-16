//
//  ViewController.m
//  Demo
//
//  Created by 橙晓侯 on 2018/12/15.
//  Copyright © 2018 橙晓侯. All rights reserved.
//

#import "ViewController.h"
#import "ReportVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self push:nil];
}

- (IBAction)push:(id)sender {
    
    [self.navigationController pushViewController:[ReportVC new] animated:0];
}

@end
