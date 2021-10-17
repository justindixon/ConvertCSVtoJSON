# Convert An Upload Salesforce CSV File to JSON String

The money is in double calling escapeJava().

JSONString = JSONString +'"' + listedCSV[0][j].escapeJava().escapeJava() + '"' + ':' + '"' + listedCSV[i][j].escapeJava().escapeJava() + '"' + ',';

Dealing with "" , and \n is hard.
