//
//  ViewController.m
//  30UITableViewDynamic
//
//  Created by Admin on 08.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"
#import "AMColor.h"
#import "AMStudent.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray* students;
@property (strong, nonatomic) NSArray* countStudentsInGroups;
@property (strong, nonatomic) NSArray* colors;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
    
    NSArray* firstNames = [[NSArray alloc] initWithObjects: @"Anna", @"Max", @"Alex",@"Mia",
                                                            @"Natalia", @"Nikita", @"Ivan", @"Sergey",
                                                            @"Denis", @"Pavel", @"Irina", @"Sofia", nil];
  
    NSArray* lastNames = [[NSArray alloc] initWithObjects:  @"Loginov", @"Potapov", @"Sidorov",@"Alekseev",
                                                            @"Shikin", @"Shapkin", @"Rusetskiy", @"Akimov",
                                                            @"Kniga", @"Drozd", @"Lis", @"Volk", nil];

    NSMutableArray* array = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i++) {
        [array addObject:[self createStudentWithName:[firstNames objectAtIndex:arc4random() % 12] lastName:[lastNames objectAtIndex:arc4random() % 12]]];
    }
    
    self.students = array;
    
    [self classifyLevelStudents];
    
    [self sortStudents];
    
    self.countStudentsInGroups = [self calculateCountStudentsInGroups];
    
    NSMutableArray* colors = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i++) {
        
        AMColor* color = [[AMColor alloc] init];
        CGFloat red = (float) (arc4random() % 256) / 255.f;
        CGFloat green = (float) (arc4random() % 256) / 255.f;
        CGFloat blue = (float) (arc4random() % 256) / 255.f;
        color.color = [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
        color.nameRGB = [NSString stringWithFormat:@"RGB (%f, %f, %f)", red, green, blue];
        [colors addObject:color];
        
    }
    self.colors = colors;
  
}

#pragma mark - Private Metods

- (AMStudent*) createStudentWithName:(NSString*)name lastName:(NSString*)lastName {
    
    CGFloat averageScore = (float)(arc4random() % 30 + 20) / 10.f;  //averageScore 2.0 - 5.0
    
    AMStudent* student = [[AMStudent alloc] initWithName:name lastName:lastName averageScore:averageScore];
    
    return student;
    
}

-(void) classifyLevelStudents {
    
    for (NSInteger i = 0; i < [self.students count]; i++) {
        
        AMStudent* student = [self.students objectAtIndex:i];
        if (student.averageScore <= 3.f) {
            student.level = AMLevelLow;
        } else if (student.averageScore <= 4.f) {
                    student.level = AMLevelNormal;
                } else if (student.averageScore < 4.8f) {
                            student.level = AMLevelGood;
                        } else {
                            student.level = AMLevelExcellent;
                        }
        
    }
    
}

- (void) sortStudents {

    self.students = [self.students sortedArrayUsingComparator:^NSComparisonResult(AMStudent* student1, AMStudent* student2) {
        if (student1.level < student2.level) {
            return NSOrderedAscending;
        } else if (student1.level > student2.level) {
                    return NSOrderedDescending;
                } else {
                    return [student1.lastName compare:student2.lastName];
                }
    }];
}

- (NSArray*) calculateCountStudentsInGroups {

    NSMutableArray* array = [NSMutableArray array];
    
    NSInteger countStudents = 1;
    AMStudent* student = [self.students objectAtIndex:0];
    AMLevel level = student.level;
    for (NSInteger i = 1; i < [self.students count]; i++) {
        student = [self.students objectAtIndex:i];
        if (level != student.level) {
            level = student.level;
            [array addObject:[NSNumber numberWithInteger:countStudents]];
            countStudents = 1;
        } else {
            countStudents++;
        }
    }
    
    return array;
}

- (NSString*) titleHeaderForSection:(NSInteger)section {
    
    NSInteger index = 0;
    for (NSInteger i = 0; i < section; i++) {
        index += [[self.countStudentsInGroups objectAtIndex:i] integerValue];
    }
    AMStudent* student = [self.students objectAtIndex:index];
    switch (student.level) {
        case 0:
            return @"Level undefined";
        case 1:
            return @"Level low";
        case 2:
            return @"Level normal";
        case 3:
            return @"Level good";
        case 4:
            return @"Level excellent";
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.countStudentsInGroups count] + 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section < [self.countStudentsInGroups count]) {
        return [self titleHeaderForSection:section];
    } else {
        return @"Colors";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < [self.countStudentsInGroups count]) {
        return [[self.countStudentsInGroups objectAtIndex:section] integerValue];
    } else {
        return [self.colors count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger index = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        index += [[self.countStudentsInGroups objectAtIndex:i] integerValue];
    }
    index += indexPath.row;
    
    NSString* identifier;
    UITableViewCell* cell;

    if (indexPath.section < [self.countStudentsInGroups count]) {
        
        identifier = @"Student";
        
        AMStudent* student = [self.students objectAtIndex:index];
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
        if (student.level == AMLevelLow) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", student.averageScore];
        
    } else {
        
        identifier = @"Color";
        
        AMColor* color = [self.colors objectAtIndex:indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = color.nameRGB;
        cell.backgroundColor = color.color;
        
    }
    
    return cell;
    
}

@end
