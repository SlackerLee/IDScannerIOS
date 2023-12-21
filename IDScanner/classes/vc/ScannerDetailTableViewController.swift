//
//  ScannerDetailTableViewController.swift
//  IDScanner
//
//  Created by iOS Team on 13/7/2021.
//

import UIKit

class ScannerDetailTableViewController: UITableViewController {
    @IBOutlet weak var ivResultImage: UIImageView!
    var imageInfoList:  [[String: Any]]?

    var resultImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivResultImage.image = resultImage
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageInfoList?.count ?? 0
    }
    
    func loadData() {
        self.tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoIdentifier", for: indexPath)

        cell.textLabel?.text = imageInfoList?[indexPath.row].first?.key
        if let value = imageInfoList?[indexPath.row].first?.value, let valueString = value as? String {
            cell.detailTextLabel?.text = valueString.isEmpty ? " ": valueString
        }
        
        return cell
    }
}
