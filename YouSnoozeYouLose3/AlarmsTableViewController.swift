//
//  AlarmsTableViewController.swift
//  YouSnoozeYouLose3
//
//  Created by Tyler hostager on 8/3/15.
//  Copyright © 2015 Tyler hostager. All rights reserved.
//

import UIKit

class AlarmsTableViewController: PFQueryTableViewController {
    
    
    /**********************************************
    *  MARK: ALLOCATE VARIABLE STORAGE IN MEMORY  *
    **********************************************/
    var errorMsg: String! = "";
    var cellIdentifier: String!
    var query: PFQuery!
    var tableCellNib: UINib!
    var cellNibTitle: String!
    var cellNibBundle: NSBundle!
    var tableData: [AlarmsTableViewCell?]!
    
    
    /******************************************
    *  MARK: SERIALIZE APPLICATION CONSTANTS  *
    ******************************************/
    let DEFAULT_TABLE_CELL_HEIGHT: CGFloat = 80;
    let DEFAULT_ITEMS_PER_PAGE: UInt = 15;
    let DEFAULT_REFRESH_STATE: Bool = true;
    let DEFAULT_PAGINATION_STATE: Bool = false;
    let DEFAULT_SELECTION_PERMISSIONS: Bool = false;
    let DEFAULT_UITABLECELL_BUNDLE: NSBundle! = nil;
    let DEFAULT_CELL_IDENTIFIER: String = "alarmsTableCell";
    let DEFAULT_UITABLECELL_NIB_TITLE: String = "AlarmsTableViewCell";
    let DEFAULT_CELL_STYLE: UITableViewCellStyle = UITableViewCellStyle.Default;
    let DEFAULT_USER_CACHE_POLICY: PFCachePolicy = PFCachePolicy.CacheThenNetwork;

    
    
    
    /************************************
    *  MARK: TABLE OBJECT CONSTRUCTORS  *
    ************************************/
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className);
        initTableViewDefaults(className);
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(style: UITableViewStyle.Plain, className: "Alarm");
        initTableViewDefaults("Alarm");
        
        //let tmpStr = "NSCoding is not currently supported at this time";
        //fatalError(tmpStr);
    }
    
    
    
    /***************************************
    *  MARK: OBJECT FUNCTIONALITY/METHODS  *
    ***************************************/
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        //self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        //self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell: AlarmsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AlarmsTableViewCell;
        
        
        if (cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed(
                DEFAULT_UITABLECELL_NIB_TITLE,
                owner: self,
                options: nil
            ) [0] as? AlarmsTableViewCell
        }
        
        if let pfObject = object {
            cell?.alarmTitleLabel?.text = pfObject["Title"] as? String;
            var days: [String] = (pfObject["Days"] as? [String])!;
            
            if (days.isEmpty) { days = ["M", "T", "W", "R", "F"]; }
            cell?.alarmDaysLabel?.text = "\(days)";
            
            var hours: Int! = pfObject["Hour"] as? Int;
            if (hours < 01 || hours > 12) {
                hours = 01;
                print(
                    "> ERROR: Invalid hours set by user\n" +
                    ">\tUnable to display data or set the alarm"
                );
            } else {
                cell?.alarmHoursLabel?.text = "\(hours)";
            }
            
            var minutes: Int! = pfObject["Minutes"] as? Int;
            if (minutes > 59) { minutes = 0; }
            else { cell?.alarmMinutesLabel?.text = "\(minutes)"; }
            
            cell?.alarmIsEnabledSwitch?.enabled = (pfObject["isEnabled"] as? Bool)!;
        }
        
        /*///TEST
        print("> Attempting to localize saved alarms from the cloud/database");
        if (cell != nil) {
            tableData! += [cell];
            print(">\tData successfully saved");
        } else {
            print(">ERROR: Unable to save user cloud data\n\tCheck the implementation " +
                "method: \"tableView\" in \"FirstViewController.swift\" for further troubleshooting");
        }
        *///////
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print("> Button pressed -> \'Delete\'\n> Removing alarm at index \'\(indexPath.row)\'...");
            tableData.removeAtIndex(indexPath.row);
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left);
            print("> Alarm successfully deleted");
            printTableData();
        }
    }
    
    
    ///
    /// queryForTable: TODO fill in.....
    ///
    /// - Parameters: none.
    /// - Returns: The PFQuery query object to be referenced, which is
    /// dependent upon the current state of the table.
    ///
    override func queryForTable() -> PFQuery {
        query = PFQuery(className: getCurrentClassName()!);
        
        //if (objects?.count == 0) {
            //setUserCachePolicy(DEFAULT_USER_CACHE_POLICY);
//query.cachePolicy = PFCachePolicy.CacheThenNetwork;
        //}
        
        query.orderByAscending("Title");
        return query;
    }
    
    
    func setUserCachePolicy(newCachePolicy: PFCachePolicy) -> Void {
        query.cachePolicy = newCachePolicy;
    }
    
    
    func getUserCachePolicy() -> PFCachePolicy {
        return query.cachePolicy;
    }
    
    
    func getTableRowHeight() -> CGFloat {
        return tableView.rowHeight;
    }
    
    
    func setTableRowHeight(newRowHeight: CGFloat) -> Void {
        tableView.rowHeight = newRowHeight;
    }
    
    
    func initTableViewDefaults() -> Void {
        setSeparators();
        setTitleAttributes();
        init_navBarPrefs();
        
        setPullToRefreshState(DEFAULT_REFRESH_STATE);
        setPaginationState(DEFAULT_PAGINATION_STATE);
        setNumObjectsPerPage(DEFAULT_ITEMS_PER_PAGE);
        setCustomCellIdentifier(DEFAULT_CELL_IDENTIFIER);
        setSelectionEnabled(DEFAULT_SELECTION_PERMISSIONS);
        setTableRowHeight(DEFAULT_TABLE_CELL_HEIGHT);
        
        setCustomTableCellNib(
            DEFAULT_UITABLECELL_NIB_TITLE,
            newBundle: DEFAULT_UITABLECELL_BUNDLE
        );
        
        registerNibFromBundle();
    }
    
    
    func init_navBarPrefs() -> Void {
        /*
        let navBar: UINavigationBar! =  self.navigationController?.navigationBar;
        navBar.titleVerticalPositionAdjustmentForBarMetrics(UIBarMetrics.CompactPrompt);
        
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Roboto-Thin", size: 42)!
        ];
        
        navBar.translucent = true;
        self.navigationController!.navigationBar.layer.shadowOpacity = 0.6;
        //navBar.opaque = false;
        */

        /*
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
        */

        /*      TODO Add this once the edit button is placed
        editButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(
                name: "Roboto-Thin",
                size: 24
                )!],
            forState: UIControlState.Normal
        );
        */
    }
    
    
    func setSeparators() -> Void {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
        tableView.separatorColor = UIColor.grayColor();
    }
    
    
    func setTitleAttributes() -> Void {
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Roboto-Thin", size: 30)!
        ]
        tabBarController?.navigationController?.navigationBar.titleTextAttributes = attributes;
        //self.navigationController?.navigationBar.titleTextAttributes = attributes;
    }
    
    
    func registerNibFromBundle() -> Void {
        if (tableCellNib == nil) { return; }
        tableView.registerNib(tableCellNib, forCellReuseIdentifier: cellIdentifier);
    }
    
    
    func registerNibFromBundle(newNibTitle: String, newBundle: NSBundle!) -> Void {
        if (newNibTitle.isEmpty) { return; }
        let tmp = UINib(nibName: newNibTitle, bundle: newBundle);
        tableView.registerNib(tmp, forCellReuseIdentifier: cellIdentifier);
    }
    
    
    func registerNibFromBundle(newNibTitle: String, newBundle: NSBundle!, newCellIdentifier: String) -> Void {
        if (newNibTitle.isEmpty || newCellIdentifier.isEmpty) { return; }
        let tmp = UINib(nibName: newNibTitle, bundle: newBundle);
        tableView.registerNib(tmp, forCellReuseIdentifier: newCellIdentifier);
    }
    
    
    func setCustomTableCellNib(newNibTitle: String, newBundle: NSBundle!) -> Void {
        if (newNibTitle.isEmpty) { return; }

        setTableCellNibTitle(newNibTitle);
        setTableCellNibBundle(newBundle);
        
        tableCellNib = UINib(
            nibName: newNibTitle,
            bundle: newBundle
        );
    }
    
    
    func setTableCellNibTitle(newNibTitle: String) -> Void {
        if (!newNibTitle.isEmpty) {
            cellNibTitle = newNibTitle;
        }
    }
    
    
    func getTableCellNibTitle() -> String {
        return cellNibTitle;
    }
    
    
    func setTableCellNibBundle(newNibBundle: NSBundle!) -> Void {
        cellNibBundle = newNibBundle;
    }
    
    
    func getTableCellNibBundle() -> NSBundle? {
        return cellNibBundle;
    }

    
    func getTableCellNib() -> UINib? {
        return tableCellNib;
    }
    
    
    func enableTableCellSelection() -> Void {
        if (tableView.allowsSelection) { return; }
        setSelectionEnabled(true);
    }
    
    
    func disableTableCellSelection() -> Void {
        if (!tableView.allowsSelection) { return; }
        setSelectionEnabled(false);
    }
    
    
    func setSelectionEnabled(newAllowSelection: Bool) -> Void {
        tableView.allowsSelection = newAllowSelection;
    }
    
    
    func initTableViewDefaults(newClassName: String!) -> Void {
        initTableViewDefaults();
        setDefaultClassName(newClassName);
    }
    
    
    func getCurrentClassName() -> String? {
        return parseClassName;
    }
    
    
    func setCustomCellIdentifier(newCellIdentifier: String) -> Void {
        if (!newCellIdentifier.isEmpty) {
            cellIdentifier = newCellIdentifier;
        }
    }
    
    
    func getCurrentCellIdentifier() -> String {
        if (cellIdentifier.isEmpty) { return ""; }
        return cellIdentifier;
    }
    
    
    func setDefaultClassName(newClassName: String!) -> Void {
        if (newClassName.isEmpty) {
            displayUserError(
                "> ERROR: Empty class name submitted\n>\tSetting to "
                + " default value of \"AlarmsTableViewController\""
            );
            return;
        }
        
        parseClassName = newClassName;
    }
    
    
    func setNumObjectsPerPage(newNumObjects: UInt) -> Void {
        if (objectsPerPage < 0) {
            print("> ERROR: Invalid number of objects\n>\tMake sure you have entered a valid option and double check the method calls in file \"AlarmsTableViewController\">\tAssigning to the default value of \'\(DEFAULT_ITEMS_PER_PAGE)\'");
            setNumObjectsPerPage(DEFAULT_ITEMS_PER_PAGE);
        } else {
            print("> Attempting to assign a value of \"\(newNumObjects)\" items per page");
            objectsPerPage = newNumObjects;
            print(">\tInteger value successfully assigned");
        }
    }
    
    
    func getNumObjectsPerPage() -> UInt {
        if (objectsPerPage < 0) {
            setNumObjectsPerPage(
                DEFAULT_ITEMS_PER_PAGE
            );
        }
        return objectsPerPage;
    }
    
    
    func printUserErrorToConsole() -> Void {
        if (errorMsg.isEmpty) { return; }
        print(errorMsg);
    }
    
    
    func getCurrentUserError() -> String {
        if (errorMsg.isEmpty) { return ""; }
        return errorMsg;
    }
    
    
    func displayUserError(newUserError: String) -> Void {
        if (newUserError.isEmpty) { return; }
        errorMsg = newUserError;
        printUserErrorToConsole();
    }
    
    
    func enablePullToRefresh() -> Void {
        if (pullToRefreshEnabled) { return; }
        setPullToRefreshState(true);
    }
    
    
    func disablePullToRefresh() -> Void {
        if (!pullToRefreshEnabled) { return; }
        setPullToRefreshState(false);
    }
    
    
    func setPullToRefreshState(newRefreshState: Bool) -> Void {
        pullToRefreshEnabled = newRefreshState;
    }
    
    
    func enablePagination() -> Void {
        if (paginationEnabled) { return; }
        setPaginationState(true);
    }
    
    
    func disablePagination() -> Void {
        if (!paginationEnabled) { return; }
        setPaginationState(false);
    }
    
    
    func setPaginationState(newPaginationState: Bool) -> Void {
        paginationEnabled = newPaginationState;
    }
    
    private func printTableData() {
        print(">\n> Displaying user's saved alarms...");
        dump(tableData);
        print(">");
    }
    
 
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}




/*
if (cell == nil) {
cell = PFTableViewCell(
style: DEFAULT_CELL_STYLE,
reuseIdentifier: cellIdentifier
);
}

if let pfObject = object {
cell?.textLabel?.text = pfObject["name"] as? String;
}
*/
