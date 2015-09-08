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
    
    
    /******************************************
    *  MARK: SERIALIZE APPLICATION CONSTANTS  *
    ******************************************/
    let DEFAULT_TABLE_CELL_HEIGHT: CGFloat = 60;
    let DEFAULT_ITEMS_PER_PAGE: UInt = 25;
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
        let tmpStr = "NSCoding is not currently supported at this time";
        fatalError(tmpStr);
    }
    
    
    
    /***************************************
    *  MARK: OBJECT FUNCTIONALITY/METHODS  *
    ***************************************/
    override func viewDidLoad() {
        
        super.viewDidLoad();
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
        
        return cell;
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
    
    
    
 
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
