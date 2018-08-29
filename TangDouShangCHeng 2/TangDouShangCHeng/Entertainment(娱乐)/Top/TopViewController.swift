//
//  TopViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/12.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class TopViewController: UITableViewController {
    @IBOutlet weak var showTableView: UITableView!
    
    @IBOutlet var topHeaderView: UIView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "排行榜"
        let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        leftItemControl.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        let back = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        back.image = UIImage(named: "new_back")
        leftItemControl.addSubview(back)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
      topHeaderView.width *= kWidth/375.0
      topHeaderView.height *= kWidth/375.0
      self.tableView.tableHeaderView = topHeaderView
        
      self.showTableView.register(UINib(nibName:"ShowTopCell", bundle: nil), forCellReuseIdentifier: "topCell")
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == showTableView {
            return 10
        }else{
            return 0
        }
       
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == showTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath) as! ShowTopCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
