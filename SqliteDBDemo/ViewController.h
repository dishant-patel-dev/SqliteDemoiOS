//
//  ViewController.h
//  SqliteDBDemo
//
//  Created by Dishant on 30/04/16.
//  Copyright © 2016 dishant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *EmployeeInfo;

@property (weak, nonatomic) IBOutlet UITextField *employeeID;
@property (weak, nonatomic) IBOutlet UITextField *employeeName;
@property (weak, nonatomic) IBOutlet UITextField *employeeEmail;
@property (weak, nonatomic) IBOutlet UITextField *employeeMobile;

- (IBAction)Find:(id)sender;
- (IBAction)Save:(id)sender;

@end

