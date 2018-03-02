from driver import Driver

mongo = Driver.get_mongo()

print(mongo)


results = mongo['users'].find({})

for result in results:
    print(result['_id'])
    
    
    
Driver.get_mssql('select top 10 * from sysobjects')