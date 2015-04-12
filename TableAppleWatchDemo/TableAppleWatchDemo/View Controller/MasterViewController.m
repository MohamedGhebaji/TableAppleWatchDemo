//
//  MasterViewController.m
//  TableAppleWatchDemo
//
//  Created by Mohamed on 11/04/2015.
//  Copyright (c) 2015 Mohamed. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Post.h"

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320., 600.);
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.splitViewController) {
        NSArray *controllers = self.splitViewController.viewControllers;
        self.detailViewController = (DetailViewController *)[(UINavigationController *)controllers[controllers.count - 1] topViewController];
    }
    
    [self _createFetchResultController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.fetchResultController objectAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:post.timestamp];
    cell.textLabel.text = post.title;
}

- (void)_createFetchResultController {
    if (self.fetchResultController != nil) {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    
    fetchRequest.fetchBatchSize = 20;
    
    NSArray *sortDescriptor = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]];
    
    fetchRequest.sortDescriptors = sortDescriptor;
    
    NSFetchedResultsController *aFetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category" cacheName:@"Master"];
    
    aFetchResultController.delegate = self;
    self.fetchResultController = aFetchResultController;
    
    NSError *error;
    if (![self.fetchResultController performFetch:&error]) {
        abort();
    }
}

#pragma mark - Accesories

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return dateFormatter;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath) {
            NSManagedObject *object = [self.fetchResultController objectAtIndexPath:indexPath];
            DetailViewController *controller = [(UINavigationController *)[segue destinationViewController] viewControllers][0];
            controller.detailItem = object;
            controller.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchResultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchResultController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self _configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchResultController.sections[section];
    if (sectionInfo) {
        return sectionInfo.name;
    }
    
    return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}
@end
