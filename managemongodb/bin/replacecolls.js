print("WARN: Doing changes in database <" + dbname + ">");

var arraycollsfind = collsfind.split(" ");
var arraycollsreplace = collsreplace.split(" ");

try {
  db = db.getSiblingDB('admin');
}
catch (err) {
  print("ERROR: Database error");
  quit(11);
}

var errorcount = 0;

for (var collidx = 0; collidx < arraycollsfind.length; collidx++) {
  print("REN " + (collidx+1) + " \"" + dbname + "." + arraycollsfind[collidx] + "\" => \"" + dbname + "." + arraycollsreplace[collidx] + "\"");
  collnamefind = dbname + "." + arraycollsfind[collidx];
  collnamereplace = dbname + "." + arraycollsreplace[collidx];
  var res = db.runCommand({renameCollection: collnamefind, to: collnamereplace});
  if (! res.ok) {
    print("ERROR: " + tojson(res));
    errorcount++;
  }
}

if (errorcount == 0) {
  print("INFO: Total colls to rename <" + arraycollsfind.length + "> Total colls error <" + errorcount + ">");
  print("INFO: Renaming successul");
}
else {
  print("INFO: Total colls to rename <" + arraycollsfind.length + "> Total colls error <" + errorcount + ">");
  print("ERROR: Renaming unsuccessul");
  quit(12);
}

