public with sharing class convertCSVtoJSON {
    @AuraEnabled
    public static String getCSVFile(Id contentVersionId){
        try {
            ContentVersion cv = [SELECT ID ,VersionData FROM CONTENTVERSION WHERE Id = :contentVersionId LIMIT 1];
            String CSV = cv.VersionData.toString();
            String cell = '';
			List<String> row = new List<String>();
            List<List<String>> listedCSV = new List<List<String>>();
            Integer headerIndex = 0;
            Integer rowIndex = 0;
            Boolean InsideDoubleQuotes = false;
            Integer countOfDoubleQuotesInsideDoubleQuote = 0;
            Integer countOfNewLineInsideDoubleQuote = 0;
            Integer countOfCommaInsideDoubleQuote = 0;
            // Need logic to split string into lines
            for(Integer index = 0; index < csv.length(); index++) {
                String character = CSV.substring(index, index+1);
				if (character == '"') {
                        if(InsideDoubleQuotes == false) {
                            InsideDoubleQuotes = true;
                            countOfDoubleQuotesInsideDoubleQuote += 1;
                            cell += character;
                        } else {
                            countOfDoubleQuotesInsideDoubleQuote += 1;
                            cell += character;
                        }
                    } 
                else if(character == ',') {
                        if(countOfDoubleQuotesInsideDoubleQuote > 0 && math.mod(countOfDoubleQuotesInsideDoubleQuote,2) == 0) {
                            InsideDoubleQuotes = false;
                        }
                        if(InsideDoubleQuotes == false) {
                            String unescapedCSV = cell.unescapeCsv();
                            row.add(unescapedCSV);
                            cell = '';
                            headerIndex += 1;
                            countOfCommaInsideDoubleQuote = 0;
                        } else {
                            cell += character;
                            countOfCommaInsideDoubleQuote += 1;

                        }
                    }
                else if (character == '\n') {
                        if(countOfDoubleQuotesInsideDoubleQuote > 0 && math.mod(countOfDoubleQuotesInsideDoubleQuote,2) == 0) {
                            InsideDoubleQuotes = false;
                        }
                        if(InsideDoubleQuotes == false) {
                            String unescapedCSV = cell.unescapeCsv();
                            row.add(unescapedCSV);
                            cell = '';
                            listedCSV.add(new List<String>(row));
                            row.clear();
                            rowIndex += 1;
                            countOfNewLineInsideDoubleQuote = 0;
                    } else {
                            cell += character;
                            countOfNewLineInsideDoubleQuote += 1;
                        }
                    } 
                else {
                    cell += character;
                }
            }
            // Build JSON String
			String JSONString = '[';
            try{
            for(Integer i = 1; i < listedCSV.size(); i++){
                List<String> rowValues = listedCSV[i];
                JSONString = JSONString + '{';
                for(Integer j = 0; j < rowValues.size(); j++) {
                    // This is the money, double calling escapeJava
                    JSONString = JSONString +'"' + listedCSV[0][j].escapeJava().escapeJava() + '"' + ':' + '"' + listedCSV[i][j].escapeJava().escapeJava() + '"' + ',';     
                }
                JSONString = JSONString.removeEnd(',');
                JSONString = JSONString  + '},';    
            }} catch (Exception e) {System.debug('Error');}
            JSONString = JSONString.removeEnd(',');
            JSONString = JSONString + ']';
            return JSONString;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
