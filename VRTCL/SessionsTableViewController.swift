//
//  SessionsTableViewController.swift
//  VRTCL
//
//  Created by Lindemann on 09.06.17.
//  Copyright © 2017 Lindemann. All rights reserved.
//

import UIKit

class SessionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.register(SessionsHeadingTableviewCell.self, forCellReuseIdentifier: SessionsHeadingTableviewCell.nibNameAndReuseIdentifier)
		
		tableView.rowHeight = 90
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print(SessionsHeadingTableviewCell.nibNameAndReuseIdentifier)
		let cell = tableView.dequeueReusableCell(withIdentifier: SessionsHeadingTableviewCell.nibNameAndReuseIdentifier, for: indexPath) as! SessionsHeadingTableviewCell

        // Configure the cell...

        return cell
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class SessionsHeadingTableviewCell: UITableViewCell {
	
	static let nibNameAndReuseIdentifier = String(describing: SessionsHeadingTableviewCell.self)
	var headingLabel = UILabel()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		headingLabel.text = "Start Session"
		headingLabel.frame = contentView.frame
		headingLabel.textAlignment = .center
		contentView.addSubview(headingLabel)
		
		headingLabel.backgroundColor = UIColor.lightGray
		contentView.backgroundColor = UIColor.yellow
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class SessionsButtonTableviewCell: UITableViewCell {
	
}
