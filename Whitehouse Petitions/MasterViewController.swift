//
//  MasterViewController.swift
//  Whitehouse Petitions
//
//  Created by Yohannes Wijaya on 8/13/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = Array<Dictionary<String, String>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String = self.navigationController?.tabBarItem.tag == 0 ? "https://api.whitehouse.gov/v1/petitions.json?limit=100" : "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&amp;limit=100"

        guard let petitionsUrl = NSURL(string: urlString) else {
            self.showError()
            return
        }
        guard let data = try? NSData(contentsOfURL: petitionsUrl, options: []) else {
            self.showError()
            return
        }
        let json = JSON(data: data)
        guard json["metadata"]["responseInfo"]["status"].intValue == 200 else {
            self.showError()
            return
        }
        self.parseJSON(json)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Methods
    
    func parseJSON(jsonData: JSON) {
        for jsonResult in jsonData["results"].arrayValue {
            let petitionTitle = jsonResult["title"].stringValue
            let petitionBody = jsonResult["body"].stringValue
            let petitionSignatures = jsonResult["signatureCount"].stringValue
            let eachPetition = ["title": petitionTitle, "body": petitionBody, "signature": petitionSignatures]
            self.objects.append(eachPetition)
        }
        self.tableView.reloadData()
    }
    
    func showError() {
        let alertController = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }

}

