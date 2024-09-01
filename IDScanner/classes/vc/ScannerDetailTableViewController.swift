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

    @IBOutlet weak var textView: UITextView!
    var resultImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivResultImage.image = resultImage
        
        var resultString = "";
        imageInfoList?.forEach({ imageInfo in
            if let value = imageInfo.first?.value, let valueString = value as? String {
                resultString += valueString.isEmpty ? " ": valueString
            }
        })
        self.textView.isScrollEnabled = false
        textView.text = resultString
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

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
        NotificationCenter.default.removeObserver(self)
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
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            tableView.setBottomInset(to: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")
        tableView.setBottomInset(to: 0.0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoIdentifier", for: indexPath)
        cell.textLabel?.text = "Result"
        return cell
    }
}
extension UITableView {

    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}
