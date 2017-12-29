//
//  AMStudent.h
//  15BitwiseOperations
//
//  Created by Admin on 06.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AMStudentSubjectTypeMath = 1 << 0,
    AMStudentSubjectTypeRussianLanguage = 1 << 1,
    AMStudentSubjectTypeRassianLiterature = 1 << 2,
    AMStudentSubjectTypeProgramming = 1 << 3,
    AMStudentSubjectTypePhysics = 1 << 4,
    AMStudentSubjectTypeChemistry = 1 << 5,
    AMStudentSubjectTypeBiology = 1 << 6,
    AMStudentSubjectTypeArt = 1 << 7,
} AMStudentSubjectType;

@interface AMStudent : NSObject

@property (assign, nonatomic) AMStudentSubjectType subjectType;

@end
