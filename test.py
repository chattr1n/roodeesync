from driver import Driver
import pandas as pd

print('--------------------> mongo test')
mongo = Driver.get_mongo()
print(mongo)


results = mongo['users'].find({})

for result in results:
    print(result['_id'])
    
print('--------------------> mssql test')
df = Driver.get_mssql('exec spTest 5')
print(df)

