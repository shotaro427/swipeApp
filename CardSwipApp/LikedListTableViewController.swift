//
//  LikedListTableViewController.swift
//  CardSwipApp
//
//  Created by 田内　翔太郎 on 2019/08/10.
//  Copyright © 2019 田内　翔太郎. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {
    
    // 「いいね」された名前の情報の配列
    var likedName: [String] = [] // ViewControllerから情報を受け取る変数

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // セル数(行数)を指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likedName.count // likedNameの配列の要素分
    }

    // セルの操作
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // セルに「いいね」されたカードの名前を表示
        cell.textLabel?.text = likedName[indexPath.row]
        return cell
    }
}
