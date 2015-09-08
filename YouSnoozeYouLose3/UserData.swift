//
//  UserData.swift
//  YouSnoozeYouLose
//
//  Created by Tyler hostager on 7/22/15.
//  Copyright © 2015 Tyler hostager. All rights reserved.
//

import Foundation

class UserData {
    
    /**
    *   MARK: SERIALIZE LOCAL VARS
    */
    
    var userData: [String]!
    var parsedDataStr: String! = "";
    var readData: NSArray?
    var writeData: Bool!
    var resourcePath: String!
    var writePath: String = "";
    
    let DEFAULT_FILE_NAME: String = "UserSavedAlarms.txt";
    let DEFAULT_FILE_PATH: String! = "";    //TODO figure out file path
    
    
    /************************
    *   MARK: CONSTRUCTORS  *
    ************************/
    
    ///
    /// Default constructor/initializer allows for the construction of a user data
    /// save file without sending specified data to be written.
    ///
    /// - Parameters: none
    /// - Returns: nil
    ///
    init() {
        setDataPath(DEFAULT_FILE_NAME);
        /*
        do {
        try setDataArr(nil);
        } catch {
        print("> ERROR: Unable to initialize object\n> See InitialViewController.swift for details");
        }
        */
    }
    
    init(newUserData: [String]!) {
        do {
            try saveArrValsToFile(newUserData);
        } catch {
            print("> ERROR: Unable to initialize object\n> See InitialViewController.swift for details");
        }
    }
    
    private func saveArrValsToFile(newUserData: [String]!) throws -> Void {
        print("> Saving user data");
        do {
            print("> Attempting to convert data array to type: \'String\'...");
            try setDataArr(newUserData);
            print("> Conversion succeeded!");
        } catch {
            print("> ERROR: Unable to convert user data to string value\n> Try parsing the data instead");
        }
    }
    
    
    private func setDataArr(newUserData: [String]?) throws -> Void {
        if (newUserData!.isEmpty || newUserData == nil) {
            userData = nil;
            return;
        }
        userData = newUserData;
    }
    
    
    
    ///
    /// DataParser takes the current user data and converts it into a String
    /// in order to be read/written to the save file properly.
    ///
    /// - Parameters: none
    /// - Returns: Void
    ///
    private func dataParser() throws -> Void {
        print("> ERROR: Data array must be converted to a string before saving");
        if (!userData.isEmpty) {
            print("> Parsing data...");
            parsedDataStr = userData.description;
            print("> Data successfully parsed!\n> Allocating placeholder for user data in RAM\n> User data not yet saved to resource file");
            return;
        } else {
            print("> ERROR: Unable to parse data array\n>Please ensure that the data in the array can be converted to type: \'String\'");
        }
    }
    
    func parseDataFromResourceTitle(filePath: String) throws -> Void {
        readData = NSArray(contentsOfFile: filePath);
    }
    
    
    func readDataFromDefaultSaveFile() throws -> Void {
        do {
            try parseDataFromResourceTitle(DEFAULT_FILE_PATH);
        } catch {
            print("> ERROR: No default save file found\n> Make sure you are specifying the correct file path")
        }
    }
    
    
    func setDataPath(fileName: String!) -> Void {
        let resourceDocs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0];
        writePath = resourceDocs.stringByAppendingPathComponent("UserSavedAlarms.txt");
    }
    
    
    
    /**
    *   MARK: CLASS FUNCTORS
    */
    class Exists {
        func atSpecifiedPath(filePath: String) -> Bool {
            return NSFileManager().fileExistsAtPath(filePath);
        }
    }
    
    //class Read {
    
    func readFileData(filePath: String, fileEncoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if (UserData.Exists().atSpecifiedPath(filePath)) {     //Search for file in resources
            return String (
                CString: filePath,
                encoding: fileEncoding
            );
        }
        return nil; // File not found
    }
    // }
    
    
    
    // class Write {
    func writeDataToTxtFile(filePath: String, fileData: String, fileEncoding: NSStringEncoding = NSUTF8StringEncoding) -> Void {//Bool {
        /*
        let filePathStr: String = "\'\(filePath)\'"
        print("> Attempting to save user data to resource file at path: \" ");
        do {
        try fileData.writeToFile(filePath, atomically: true, encoding: fileEncoding);
        print("> User data successfully saved to resource file at index path: \(filePathStr)");
        } catch {
        print("> ERROR: Unable to write data to the file requested at the requested path: \(filePathStr)\n> File not found in the local resources folder\n> Make sure the file exists at the specified path");
        }
        */
        //return fileData.writeToFile(filePath, atomically: true, encoding: fileEncoding);
        do {
            try fileData.writeToFile(filePath, atomically: true, encoding: fileEncoding);
        } catch {
            print("> ERROR: Unable to locate file in the default resource folder\n> Make sure it is set correctly");
        }
    }
    // }
    
    func saveDataToTxtFile() -> Void {
        //let tstReadFile: String? = UserData.Read.readFileData(writePath));
        let tstReadFile: String? = readFileData(writePath);
        print(">\n> TEST: Reading data from txt file...");
        print(tstReadFile);
        
        //let tstWriteFile: Bool = writeDataToTxtFile(writePath, fileData: parsedDataStr);
        writeDataToTxtFile(writePath, fileData: parsedDataStr);
        print(">\n> TEST: Data files written to txt file...");
        print(readFileData(writePath));
    }
    
    
    
    
    
    internal func updateFileData(newUserData: [String]) -> Void {
        if (newUserData.isEmpty) {
            print("> ERROR: Nil data... that's no good!");
            return;
        }
        userData = newUserData;
    }
    
    private func setUserData(newUserData: [String]!) -> Void {
        
        if (!newUserData.isEmpty) {
            userData = newUserData;
        }
    }
    
}