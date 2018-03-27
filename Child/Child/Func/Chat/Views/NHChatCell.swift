//
//  NHChatCell.swift
//  Child
//
//  Created by Noah on 2018/3/27.
//  Copyright © 2018年 NH. All rights reserved.
//

import UIKit

class NHChatCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var unreadNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width / 2 / 180 * 30
        
        self.unreadNumberLabel.layer.masksToBounds = true
        self.unreadNumberLabel.layer.cornerRadius = self.unreadNumberLabel.bounds.size.height / 2.0
    }
    
    func setCellContnet(_ model: NHChat) {
        self.avatarImageView.image = UIImage.init(imageLiteralResourceName: model.usericon!)
        self.unreadNumberLabel.text = model.unreadnum > 99 ? "99+" : String(model.unreadnum)
        self.unreadNumberLabel.isHidden = (model.unreadnum == 0)
        let message = model.lastmessage!
        self.lastMessageLabel.text = String.init(data: message.data, encoding: .utf8)
        
        //date -> string
        let myFormatter = DateFormatter()
        //这里有很多默认的日期格式
        myFormatter.dateStyle = .short
        //默认的时间格式
        myFormatter.timeStyle = .short
        let dateStr = myFormatter.string(from: message.date)
        
        self.dateLabel.text = dateStr
        self.nameLabel.text = model.username!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
