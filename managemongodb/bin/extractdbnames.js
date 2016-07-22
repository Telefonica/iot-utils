var databases = db.getMongo().getDBNames();

print('{');
for(var i = 0; i < databases.length; i++){
  var name = databases[i];
   print(name);
}
print('}');

