//
//  FirstViewController.swift
//  YouSnoozeYouLose3
//
//  Created by Tyler hostager on 8/4/15.
//  Copyright © 2015 Tyler hostager. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /***************************
    *  MARK: INITIALIZE ENUMS  *
    ***************************/
    // Create exceptions for null pointers/error handling
    enum NullReferenceException: ErrorType {
        case Default;
        case ResourceNotFound;
        case NullPointerException;
        case FileNotFound;
    }
    
    // Generate parsing errors (for reading file)
    enum ParseError: ErrorType {
        case ParseException;
        case InvalidDataException;
        case DataMismatchException;
    }

    
    /// TODO: Figure out how to write saved alarms to the parse database 
    ///       along with caching locally to a *.plist file so that you don't
    ///       need to write to a *.txt file any longer.
    
    
    
    /*******************************************************
    *  MARK: INSTANCE VAR SERIALIZATION & DATA ALLOCATION  *
    *******************************************************/
    // Instantiate local IBOutlet connections
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var addAlarmButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // Init cell identifier for referencing corresponding UI object
    let cellIdentifier = "alarmsTableCell";
    
    // Allocate storage in memory for mutable table data array
    var tableData = [String]();
    
    // Init number of table sections
    var numTableSections: Int?
    var errorMsg: String = "";
    var userFontSize: CGFloat!
    var userFontTitle: String!
    var currentSelection: String? = nil;
    var editingIsEnabled: Bool!
    var numUserAlarms: Int!
    var userData: UserData!
    
    
    
    
    /************************************************
    *  MARK: INSTANTIATE GLOBAL DEFAULTS/CONSTANTS  *
    ************************************************/
    // Init constant vars
    let DEFAULT_NUM_SECTIONS: Int = 1
    let DEFAULT_FONT_SIZE: Int = 24;
    let DEFAULT_EDITOR_PERMISSIONS: Bool = false;
    let DEFAULT_COMPLETION_TITLE: String = "Done";
    let DEFAULT_EDITOR_TITLE: String = "Edit";
    
    var DEBUG_TABLE_DATA = [
        "0", "1", "2", "3", "4", "5", "test"
        //, "8", "9", "10", "11", "12", "13", "14", "15"
    ];
    
    
    
    /********************************************
    *  MARK: OBJECT-SPECIFIC FUNCTIONS/METHODS  *
    ********************************************/
    override func viewDidLoad() {       // Executes after the view controller is initialized
        super.viewDidLoad();
        tableView.delegate = self;
        tableView.dataSource = self;
        userData = UserData();
        setNumTableSections(DEFAULT_NUM_SECTIONS);
        init_NavBarPrefs();
        enableEditor();

        ///TEST
        debug_renderExampleData();
        ///
        
        printTableData();
    }

    
    internal func debug_renderExampleData() -> Void {
        setTableDataArr(DEBUG_TABLE_DATA);
    }
    
    
    ///
    /// Assigns the current table data array to the new array's contents when called.
    ///
    /// - Parameter newTableDataArr: the new data for the current table.
    /// - Returns: Void
    ///
    internal func setTableDataArr(newTableDataArr: [String]) -> Void {
        if (newTableDataArr.isEmpty) {
            errorMsg = "> ERROR: Empty data table array. Please ensure the "
                + "table data array is being correctly initialized and "
                + "double check where you initialize and assign the data values.";
            print(errorMsg);
            return;
        }
        
        tableData = newTableDataArr;
    }
    
    
    
    internal func setEditorDefaults() -> Void {
        editingIsEnabled = DEFAULT_EDITOR_PERMISSIONS;
    }
    
    
    
    private func updateCurrentEditorSettings() -> Void {
        
        if editingIsEnabled == true {
            editButton.title = DEFAULT_COMPLETION_TITLE;
            disableEditor();
            return;
        }
        
        editButton.title = DEFAULT_EDITOR_TITLE;
        enableEditor();
    }
    
    
    
    internal func editorIsEnabled() -> Bool {
        if editingIsEnabled == nil { return false; }
        return editingIsEnabled;
    }
    
    
    internal func enableEditor() -> Void {
        if !editorIsEnabled() {
            setEditorStatus(true);
        } else {
            errorMsg = "> ERROR: Invalid method call. Please make sure you only enable "
                + "the editor if it has previously been disabled.";
            print(errorMsg);
            return;
        }
    }
    
    
    internal func disableEditor() -> Void {
        if editorIsEnabled() {
            setEditorStatus(false);
        } else {
            errorMsg = "> ERROR: Invalid method call. Please make sure you only disable "
                + "the editor if it has previously been enabled.";
            print(errorMsg);
        }
    }
    
    
    private func setEditorStatus(newEditorStatus: Bool) -> Void {
        editingIsEnabled = newEditorStatus;
    }
    
    
    
    @IBAction func addAlarmButtonPressed(sender: UIBarButtonItem) -> Void {
        print("Button pressed -> \'Add Alarm\'");  //         <-- Depricated
        // Triggers scene change in Main.storyboard file
        
        //TODO add more functionality if necessary
    }
    
    
    
    ///
    /// editAlarmButtonPressed function changes the rendered text for the
    /// edit button to either display 'Edit' or 'Done', depending on if the
    /// button has already been selected or not.
    ///
    /// This function also logs each 'edit' button press for debugging purposes
    ///
    /// - Parameter sender: The UIBarButtonItem which triggers the different
    ///                     editing modes, as well as render their respective icons.
    /// - Returns: nil
    ///
    @IBAction func editAlarmButtonPressed(sender: UIBarButtonItem) -> Void {
        var tmpTitle: String = editButton.title!;
        
        if tmpTitle == DEFAULT_COMPLETION_TITLE {
            print("> Button pressed -> \'Done\'");
            tmpTitle = DEFAULT_EDITOR_TITLE;
            addAlarmButton.enabled = true;
            tableView.setEditing(false, animated: true);
        } else if tmpTitle == DEFAULT_EDITOR_TITLE {
            print("> Button pressed -> \'Edit\'");
            tmpTitle = DEFAULT_COMPLETION_TITLE;
            addAlarmButton.enabled = false;
            tableView.setEditing(true, animated: true);
        } else {
            errorMsg = "> ERROR: Nil object reference.\n\t* Please ensure the "
                + "correct setter methods have been called before "
                + "attempting to change the name.";
            print(errorMsg);
        }
        
        editButton.title = tmpTitle;
        updateCurrentEditorSettings();
        userData.saveDataToTxtFile();
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print("> Button pressed -> \'Delete\'\n> Removing alarm at index \'\(indexPath.row)\'...");
            tableData.removeAtIndex(indexPath.row);
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left);
            print("> Alarm successfully deleted");
            printTableData();
        }
    }
    
    
    /*
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    
    if tableView.editing { return UITableViewCellEditingStyle.Delete; }
    return UITableViewCellEditingStyle.None;
    }
    */
    
    
    private func setWhiteBackground() {
        self.view.backgroundColor = UIColor.whiteColor()
        preferredStatusBarStyle();
        setNeedsStatusBarAppearanceUpdate();
        
    }
    
    
    private func printTableData() {
        print(">\n> Displaying user's saved alarms...");
        dump(tableData);
        print(">");
    }
    
    
    
    
    
    
    
    /*---<  MARK: DELEGATE OBJECT FUNCTIONS  >---*/
    
    
    
    /**
    *
    *
    * @return
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath);
        let row = indexPath.row;
        
        userFontTitle = "Roboto";
        
        cell.textLabel?.text = tableData[row];
        cell.textLabel?.font = UIFont(name: userFontTitle, size: 20);
        
        //print("> Testing table view functionality...");
        
        ///*
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.clearColor();
            //cell.backgroundColor = UIColor.blackColor();
        } else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2);
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0);
        }
        //*/
        
        return cell;
    }
    
    
    /**
    *
    *
    * @return
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count;
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let row = indexPath.row;
        print("Selecting item: \(tableData[row])");
        currentSelection = tableData[row];
    }
    
    
    /*
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
    return UIStatusBarAnimation.Fade;
    }*/
    
    
    
    
    private func alwaysShowStatusBar() {
        print("> Updating status bar to custom configurations...");
        setNeedsStatusBarAppearanceUpdate();
        print("> Update success.");
    }
    
    
    
    internal func setUserFontSize(newSize: CGFloat?) -> Void {
        var tmp: CGFloat;
        
        if newSize < 10 || newSize > 36 {
            errorMsg = "> ERROR: The specified font size is out of range." +
            "\n> Using default size value instead.";
            print(errorMsg);
            tmp = CGFloat(DEFAULT_FONT_SIZE);
        } else { tmp = newSize!; }
        
        print("> Setting user font size to \(tmp.description).");
        self.userFontSize = tmp;
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    
    private func customFontLoader(fontName: String, size: CGFloat) throws -> UIFont {
        setUserFontSize(size);
        guard let font = UIFont(name: fontName, size: userFontSize) else {
            throw NullReferenceException.ResourceNotFound;
        }
        
        return font;
    }
    
    
    
    private func init_statusBarPrefs() -> Void {
        let addStatusBar = UIView();
        addStatusBar.frame = CGRectMake(0, 0, 320, 20);
        addStatusBar.backgroundColor = UIColor(red: 50, green: 65, blue: 154, alpha: 1);
        self.view.window?.rootViewController?.view .addSubview(addStatusBar);
    }
    
    
    private func init_tabBarPrefs() -> Void {
        let tabBar: UITabBar! = self.tabBarController!.tabBar;
        tabBar.translucent = true;
        //tabBar.alpha = 1.0;
        tabBar.alpha = 0.6;
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light));
        //let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark));
        blur.tintColor = UIColor.whiteColor();
        //blur.alpha = 0.8;  //         <-- Potentially creates error/broken images
        blur.frame = self.tabBarController!.tabBar.frame;
        tabBar.addSubview(blur);
        
    }
    
    
    
    
    
    
    /**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @
    @  TODO This is super clunky! Slim dat dang thang down!!!
    @
    @   |   |   |   |   |   |   |   |   |   |   |   |
    @   V   V   V   V   V   V   V   V   V   V   V   V
    @
    @   - Note: Still runs in T(N) = O(log(N)) running time though!
    @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
    
    ///
    /// init_NavBarPrefs: Initializes custom navigation bar preferences to adjust font,
    /// color, transparency, etc.
    ///
    /// - Parameters: None
    /// - Returns: Void
    ///
    private func init_NavBarPrefs() -> Void {
        let navBar: UINavigationBar! =  self.navigationController?.navigationBar;
        navBar.titleVerticalPositionAdjustmentForBarMetrics(UIBarMetrics.CompactPrompt);
        
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Roboto-Thin", size: 42)!
        ];
        
        navBar.translucent = true;
        self.navigationController!.navigationBar.layer.shadowOpacity = 0.6;
        //navBar.opaque = false;
        
        ///*
        navBar.alpha = 0.90;
        let blur: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark));
        blur.tintColor = UIColor.whiteColor();
        //blur.alpha = 0.25;  //         <-- Potentially creates error/broken images
        blur.frame = navBar.frame;
        self.navigationController!.navigationBar.layer.addSublayer(CALayer(layer: blur));
        self.navigationController!.navigationBar.layer.shadowRadius = 2;
        self.navigationController!.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
        self.navigationController!.navigationBar.layer.shadowOpacity = 0.5;
        self.navigationController!.navigationBar.layer.shadowColor = UIColor.grayColor().CGColor;
        let barAppearance = UINavigationBar.appearance();
        barAppearance.shadowImage = UIImage();
        barAppearance.opaque = false;
        barAppearance.translucent = true;
        barAppearance.alpha = 0.25;
        tabBarItem.title = "Alarms";
        
        editButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(
                name: "Roboto-Thin",
                size: 24
                )!],
            forState: UIControlState.Normal
        );
        
    }
    
    
    
    /**
    * Retrieves the number of sections in the table view when called.
    *
    * @return   the total section count.
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if numTableSections == nil {
            return DEFAULT_NUM_SECTIONS;
        } else {
            return numTableSections!;
        }
    }
    
    
    
    ///
    /// setNumTableSections: Assigns the number of sections in which the
    /// table should be divided into.
    /// - Parameter newNumTableSections: The new number of sections in the table.
    /// - Returns: void
    ///
    /// - Note: May be bypassed using self.numTableSections = *'example'*
    ///
    func setNumTableSections(newNumTableSections: Int!) -> Void {
        if newNumTableSections >= 0 {
            self.numTableSections = newNumTableSections;
        } else {
            errorMsg = "ERROR: Unable to create a negative amount of sections in the table." +
            "\nSetting the number of sections to a default value of zero.";
            print(errorMsg);
            self.numTableSections = 0;
            return self.destroyCurrentContext();
        }
    }
    
    
    
    ///
    /// setCurrentTableView: Assigns the table view variable to the current table instance. This function
    /// also provides the ability for other classes to modify the table instance data
    /// set, which allows QuestionTypeDelegate to be more dynamic within it's context.
    ///
    /// - Parameter currentTableView: The table view reference in the current
    /// - Returns: void
    ///
    internal func setCurrentTableView(currentTableView: UITableView) -> Void {
        self.tableView = currentTableView;
    }
    
    
    
    ///
    /// getCurrentTableView: Retrieves the current UITableView object from the current context
    /// - Returns:   the instance of the table view object.
    ///
    internal func getCurrentTableView() -> UITableView! {
        return self.tableView;
    }
    
    
    
    ///
    /// destroyCurrentContext: Breaks any function that has a void return type,
    /// which is useful when you want to prevent further code from executed from
    /// within its function
    ///
    /// - Parameters: none
    /// - Returns: Void
    ///
    private func destroyCurrentContext() -> Void {
        return;
    }
    
    
    

    
    
    

}
