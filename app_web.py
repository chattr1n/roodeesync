import math

from flask import Flask

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
from _18_StudentGrades import *

from datetime import datetime

app = Flask(__name__)

@app.route('/<SchoolName>')
def index(SchoolName):
    
    if SchoolName == 'favicon.ico':
        return ''
    
    start_dt = datetime.now()
    return_str = ''

    #  _01_TaskListCat
    dt1 = datetime.now()
    output = TaskListCat.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> TaskListCat: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _02_PeriodList
    dt1 = datetime.now()
    output = PeriodList.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> PeriodList: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _03_GradeCat
    dt1 = datetime.now()
    output = GradeCat.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> GradeCat: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _04_SchoolYears
    dt1 = datetime.now()
    output = SchoolYears.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> SchoolYears: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _05_Departments
    dt1 = datetime.now()
    output = Departments.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Departments: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _06_Subjects
    dt1 = datetime.now()
    output = Subjects.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Subjects: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _07_Classes
    dt1 = datetime.now()
    output = Classes.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Classes: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _08_ClassPeriods
    dt1 = datetime.now()
    output = ClassPeriods.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> ClassPeriods: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _09_Teachers
    dt1 = datetime.now()
    output = Teachers.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Teachers: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _10_ClassTeachers
    dt1 = datetime.now()
    output = ClassTeachers.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> ClassTeachers: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _11_Generations
    dt1 = datetime.now()
    output = Generations.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Generations: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _12_Students
    dt1 = datetime.now()
    output = Students.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Students: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _13_Parents
    dt1 = datetime.now()
    output = Parents.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Parents: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _14_StudentParents
    dt1 = datetime.now()
    output = StudentParents.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> StudentParents: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _15_ClassStudents
    dt1 = datetime.now()
    output = ClassStudents.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> ClassStudents: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _16_Attendances
    dt1 = datetime.now()
    output = Attendances.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Attendances: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _17_Grades
    dt1 = datetime.now()
    output = Grades.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> Grades: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    # _18_StudentGrades
    dt1 = datetime.now()
    output = StudentGrades.run(SchoolName)
    dt2 = datetime.now()
    sec = math.ceil((dt2 - dt1).total_seconds())
    return_str += '--------------> StudentGrades: ' + str(sec) + ' sec. ' + str(output) + '\r\n'
    
    stop_dt = datetime.now()
    sec = math.ceil((stop_dt - start_dt).total_seconds())
    return_str += 'Total: ' + str(sec) + ' sec.'
    
    return return_str

if __name__ == "__main__":    
    app.run(host='0.0.0.0', port=8081, debug=False)