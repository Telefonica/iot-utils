print('{');
db.getCollectionNames().forEach(function(collName) {
  print(collName);
});
print('}');

