//
//  NHChatController.swift
//  Child
//
//  Created by Noah on 2018/3/8.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit
import TimedSilver

class NHChatController: NHTableViewController {

    var messages = [NHChat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        tableView.estimatedRowHeight = 65
        tableView.ts_registerCellNib(NHChatCell.self)
        tableView.tableFooterView = UIView()
        for i in 0..<6 {
            let chat = NHChat()
            chat.username = "Annatar"
            chat.userid = "\(i)"
            chat.usericon = "default_icon"
            chat.unreadnum = i
            var lastMessage = LMessage()
            lastMessage.data = "hello_word".data(using: .utf8)
            lastMessage.date = Date()
            lastMessage.type = .Word
            
            chat.lastmessage = lastMessage
            
            messages.append(chat)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NHChatCell = tableView.ts_dequeueReusableCell(NHChatCell.self)
        cell.setCellContnet(self.messages[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
