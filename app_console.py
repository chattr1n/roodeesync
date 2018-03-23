import math

from _01_TaskListCat import *
from _02_PeriodList import *
from _03_GradeCat import *
from _04_SchoolYears import *
from _05_Departments import *
from _06_Subjects import *
from _07_Classes import *
from _08_ClassPeriods import *
from _09_Teachers import *
from _10_ClassTeachers import *
from _11_Generations import *
from _12_Students import *
from _13_Parents import *
from _14_StudentParents import *
from _15_ClassStudents import *
from _16_Attendances import *
from _17_Grades import *

from datetime import datetime

start_dt = datetime.now()

'''
#  _01_TaskListCat
dt1 = datetime.now()
output = TaskListCat.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> TaskListCat: ' + str(sec) + ' sec. ' + str(output))

# _02_PeriodList
dt1 = datetime.now()
output = PeriodList.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> PeriodList: ' + str(sec) + ' sec. ' + str(output))

# _03_GradeCat
dt1 = datetime.now()
output = GradeCat.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> GradeCat: ' + str(sec) + ' sec. ' + str(output))

# _04_SchoolYears
dt1 = datetime.now()
output = SchoolYears.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> SchoolYears: ' + str(sec) + ' sec. ' + str(output))

# _05_Departments
dt1 = datetime.now()
output = Departments.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Departments: ' + str(sec) + ' sec. ' + str(output))

# _06_Subjects
dt1 = datetime.now()
output = Subjects.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Subjects: ' + str(sec) + ' sec. ' + str(output))

# _07_Classes
dt1 = datetime.now()
output = Classes.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Classes: ' + str(sec) + ' sec. ' + str(output))

# _08_ClassPeriods
dt1 = datetime.now()
output = ClassPeriods.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> ClassPeriods: ' + str(sec) + ' sec. ' + str(output))

# _09_Teachers
dt1 = datetime.now()
output = Teachers.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Teachers: ' + str(sec) + ' sec. ' + str(output))

# _10_ClassTeachers
dt1 = datetime.now()
output = ClassTeachers.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> ClassTeachers: ' + str(sec) + ' sec. ' + str(output))

# _11_Generations
dt1 = datetime.now()
output = Generations.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Generations: ' + str(sec) + ' sec. ' + str(output))

# _12_Students
dt1 = datetime.now()
output = Students.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Students: ' + str(sec) + ' sec. ' + str(output))

# _13_Parents
dt1 = datetime.now()
output = Parents.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Parents: ' + str(sec) + ' sec. ' + str(output))

# _14_StudentParents
dt1 = datetime.now()
output = StudentParents.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> StudentParents: ' + str(sec) + ' sec. ' + str(output))

# _15_ClassStudents
dt1 = datetime.now()
output = ClassStudents.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> ClassStudents: ' + str(sec) + ' sec. ' + str(output))

# _16_Attendances
dt1 = datetime.now()
output = Attendances.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Attendances: ' + str(sec) + ' sec. ' + str(output))
'''
# _17_Grades
dt1 = datetime.now()
output = Grades.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Grades: ' + str(sec) + ' sec. ' + str(output))



stop_dt = datetime.now()
sec = math.ceil((stop_dt - start_dt).total_seconds())
print('Total: ' + str(sec) + ' sec.')
