//
//  DetailViewController.m
//  TableAppleWatchDemo
//
//  Created by Mohamed on 11/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

- (IBAction)openInBrowserButtonAction:(id)sender;
- (void)_configureView;
@end

@implementation DetailViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _configureView];
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

#pragma mark - Private Methods
- (void)_configureView {
    if (self.detailItem) {
        NSString *title = [self.detailItem valueForKey:@"title"];
        if (title) {
            self.titleLabel.text = title;
        }
        
        NSString *content = [self.detailItem valueForKey:@"content"];
        if (content) {
            [self.webView loadHTMLString:content baseURL:[NSURL URLWithString:@"http://www.raywenderlich.com/"]];
        }
    }
}

#pragma mark - Actions
- (void)openInBrowserButtonAction:(id)sender {
    if (self.detailItem) {
        NSString *link = [self.detailItem valueForKey:@"link"];
        if (link) {
            NSURL *url = [NSURL URLWithString:link];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
