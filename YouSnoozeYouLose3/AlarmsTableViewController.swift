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
    
    
    
    /******************************************
    *  MARK: SERIALIZE APPLICATION CONSTANTS  *
    ******************************************/
    let DEFAULT_ITEMS_PER_PAGE: UInt = 25;
    let DEFAULT_REFRESH_STATE: Bool = true;
    let DEFAULT_PAGINATION_STATE: Bool = false;
    let DEFAULT_CELL_IDENTIFIER: String = "alarmsTableCell";
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
        var cell: PFTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell;
        
        if (cell == nil) {
            cell = PFTableViewCell(
                style: DEFAULT_CELL_STYLE,
                reuseIdentifier: cellIdentifier
            );
        }
        
        if let pfObject = object {
            cell?.textLabel?.text = pfObject["name"] as? String
        }
        
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
        
        query.orderByAscending("name");
        return query;
    }
    
    
    func setUserCachePolicy(newCachePolicy: PFCachePolicy) -> Void {
        query.cachePolicy = newCachePolicy;
    }
    
    
    func getUserCachePolicy() -> PFCachePolicy {
        return query.cachePolicy;
    }
    
    
    
    func initTableViewDefaults() -> Void {
        setPullToRefreshState(DEFAULT_REFRESH_STATE);
        setPaginationState(DEFAULT_PAGINATION_STATE);
        setNumObjectsPerPage(DEFAULT_ITEMS_PER_PAGE);
        setCustomCellIdentifier(DEFAULT_CELL_IDENTIFIER);
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
