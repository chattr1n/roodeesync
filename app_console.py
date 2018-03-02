from driver import Driver

print('--------------------> mongo test')
mongo = Driver.get_mongo()
print(mongo)


results = mongo['users'].find({})

for result in results:
    print(result['_id'])
    
print('--------------------> mssql test')
conn = Driver.get_mssql()
cursor = conn.cursor()
cursor.execute('exec spTest 5')

for row in cursor:
    print(row[0])

conn.close()

