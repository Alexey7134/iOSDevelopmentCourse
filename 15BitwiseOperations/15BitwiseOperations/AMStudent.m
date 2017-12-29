//
//  AMStudent.m
//  15BitwiseOperations
//
//  Created by Admin on 06.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

@implementation AMStudent

- (NSString*) valueSubjectType:(AMStudentSubjectType)type {
    return self.subjectType & type ? @"Yes" : @"No";
}

- (NSString *)description {

    return [NSString stringWithFormat:@"\nStudent studies:\n"
                                        "Math - %@ "
                                        "RussianLanguage - %@ "
                                        "Literature - %@ "
                                        "Programming - %@ "
                                        "Physics - %@ "
                                        "Chemistry - %@ "
                                        "Biology - %@ "
                                        "Art - %@",
                                        [self valueSubjectType:AMStudentSubjectTypeMath],
                                        [self valueSubjectType:AMStudentSubjectTypeRussianLanguage],
                                        [self valueSubjectType:AMStudentSubjectTypeRassianLiterature],
                                        [self valueSubjectType:AMStudentSubjectTypeProgramming],
                                        [self valueSubjectType:AMStudentSubjectTypePhysics],
                                        [self valueSubjectType:AMStudentSubjectTypeChemistry],
                                        [self valueSubjectType:AMStudentSubjectTypeBiology],
                                        [self valueSubjectType:AMStudentSubjectTypeArt]];
}

@end
