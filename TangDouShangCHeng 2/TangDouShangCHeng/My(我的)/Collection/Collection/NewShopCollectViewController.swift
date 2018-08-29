//
//  NewShopCollectViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/28.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopCollectViewController: BaseTableViewController {

    var goodModels:[HomeGoodModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收藏"
//         [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        self.goodModels = DataManager().fetchAllData()
        self.tableView.register(UINib(nibName: "RecommendedCell", bundle: nil), forCellReuseIdentifier: "collectCell")

        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectCell", for: indexPath) as! RecommendedCell
        cell.buyNowBtn.setTitle("领券购买", for: .normal)
        cell.buyNowBtn.whenTapped({
           
            let vc = GoodDetailViewController(tableViewStyle: .grouped)
            vc?.goodModel = self.goodModels[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
//            let magicMove = MagicMoveTransition()
//            self.navigationController?.pushViewController(vc, animated: true, transition: magicMove)
            
        })
        cell.goodModel = self.goodModels[indexPath.row] 
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
}
