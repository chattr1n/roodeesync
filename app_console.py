import math
from _04_SchoolYears import *
from _05_Departments import *

dt1 = datetime.now()
output = SchoolYears.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> SchoolYears: ' + str(sec) + ' sec. ' + str(output))

dt1 = datetime.now()
output = Departments.run()
dt2 = datetime.now()
sec = math.ceil((dt2 - dt1).total_seconds())
print('--------------> Departments: ' + str(sec) + ' sec. ' + str(output))
