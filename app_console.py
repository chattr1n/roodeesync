import math
from _01_TaskListCat import *
from _03_GradeCat import *
from _04_SchoolYears import *
from _06_Subjects import *
from _05_Departments import *
from _10_Generations import *

start_dt = datetime.now()

#  _01_TaskListCat
dt1 = datetime.now()
output = TaskListCat.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> TaskListCat: ' + str(sec) + ' sec. ' + str(output))

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

# _10_Generations
dt1 = datetime.now()
output = Generations.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Generations: ' + str(sec) + ' sec. ' + str(output))





stop_dt = datetime.now()
sec = math.ceil((stop_dt - start_dt).total_seconds())
print('Total: ' + str(sec) + ' sec.')
