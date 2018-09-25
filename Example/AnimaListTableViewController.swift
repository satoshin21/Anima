//
//  AnimaListTableViewController.swift
//  AnimaExample
//
//  Created by Satoshi Nagasaka on 2017/03/21.
//  Copyright © 2017年 satoshin21. All rights reserved.
//

import UIKit
import Anima

class AnimaListTableViewController: UITableViewController {
    
    private enum Menu {
        case move
        case scale
        case movePath
        case cornerAndLine
        case pauseResume
    }

    private var menus: [Menu] = [
        .move,
        .scale,
        .movePath,
        .cornerAndLine,
        .pauseResume
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menus.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch menus[indexPath.row] {
        case .move:
           cell.textLabel?.text = "Move"
        case .scale:
            cell.textLabel?.text = "Size & AnchorPoint & Rotate"
        case .movePath:
            cell.textLabel?.text = "Move Path"
        case .cornerAndLine:
            cell.textLabel?.text = "Corner and Line"
        case .pauseResume:
            cell.textLabel?.text = "Pause and Resume"
            break;
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch menus[indexPath.row] {
        case .move:
            performSegue(withIdentifier: "segueMove", sender: nil)
        case .scale:
            performSegue(withIdentifier: "segueSize", sender: nil)
        case .movePath:
            performSegue(withIdentifier: "seguePath", sender: nil)
        case .cornerAndLine:
            performSegue(withIdentifier: "segueCornerLine", sender: nil)
        case .pauseResume:
            performSegue(withIdentifier: "seguePauseResume", sender: nil)
        }
    }
}
