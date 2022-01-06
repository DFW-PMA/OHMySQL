//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

@import Foundation;

#import "OHListViewController.h"
#import "OHEditViewController.h"

#import "OHMySQL.h"
#import "AppDelegate.h"
#import "OHTasksFacade.h"

#import "OHTask.h"

#import "OHTaskTableViewCell.h"

@interface OHListViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray<OHTask *> *listOfTasks;
@property (nonatomic, strong) NSMutableArray<OHTask *> *filteredTasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *allItemsController;

@end

@implementation OHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureResultsController];

	[self performSegueWithIdentifier:@"settings" sender:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
    [self refresh:nil];
}

- (void)configureResultsController {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([OHTask class])];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:mysql_key(taskId) ascending:NO]];
    self.allItemsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:appDelegate.managedObjectContext
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:nil];
    self.allItemsController.delegate = self;
}

- (IBAction)refresh:(__unused id)sender {
    [self.tableView reloadData];
}

- (IBAction)addButtonPressed:(__unused UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    OHTask *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([OHTask class])
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    task.name = @"Something important"; 
    task.taskDescription = [@"Do something important: " stringByAppendingFormat:@"%@", [NSDate date]];
    task.status = @(rand() % 2);
	task.taskData = [UIDevice.currentDevice.identifierForVendor.UUIDString dataUsingEncoding:NSUTF8StringEncoding];

    [OHTasksFacade addTask:task :nil failure:^{
        // Handle
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return self.allItemsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OHTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OHTaskCellIdentifier" forIndexPath:indexPath];
    [cell configureWithTask:self.allItemsController.fetchedObjects[indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(__unused UITableView *)tableView canEditRowAtIndexPath:(__unused NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(__unused UITableView *)tableView didSelectRowAtIndexPath:(__unused NSIndexPath *)indexPath {
    OHEditViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OHEditViewController"];
    viewController.task = self.allItemsController.fetchedObjects[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(__unused UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OHTask *task = self.allItemsController.fetchedObjects[indexPath.row];
        [OHTasksFacade deleteTask:task :nil failure:^{
            // Handle
        }];
    }
}

#pragma mark - NSFetchedResultsController

- (void)controllerWillChangeContent:(__unused NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(__unused NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(__unused NSFetchedResultsController *)controller didChangeSection:(__unused id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [NSException raise:@"Not implemented" format:@"NSFetchedResultsChangeMove is not implemented for sections on screen %@", [self class]];
            break;
        }
    }
}

- (void)controller:(__unused NSFetchedResultsController *)controller didChangeObject:(__unused id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    // Fix for iOS8. Xcode 7 has a bug with FRC.
    if ([indexPath isEqual:newIndexPath]) {
        return ;
    }
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove: {
            //[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}

@end
