@IsTest
private with sharing class convertCSVtoJSONTest {
    // Create a csv file and upload it.
    @IsTest
    static void TestgetCSVFile() {
        // CSV File
        Blob csv = Blob.valueOf('Bobsaget, Hello \n 1,0  \n  2,3');
        ContentVersion  cv = new ContentVersion();
        // ContentVerion object requires Title, VersionData, and PathOnClient
        cv.Title = 'Test CSV';
        cv.VersionData = csv;
        cv.PathOnClient = 'hello.csv'; // required but does not need to be a real path...
        insert cv;
        Test.startTest();
        String testResult = convertCSVtoJSON.getCSVFile(cv.Id);
        Test.stopTest();
        System.assert(testResult.length() > 0, 'getProjects did not return any CSVs');
    }


}