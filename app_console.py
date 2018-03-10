import math
from _01_TaskListCat import *
from _03_GradeCat import *
from _04_SchoolYears import *
from _05_Departments import *
from _10_Generations import *

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


# _10_Generations
dt1 = datetime.now()
output = Generations.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Generations: ' + str(sec) + ' sec. ' + str(output))
