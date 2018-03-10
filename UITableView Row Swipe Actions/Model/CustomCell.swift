//Created by Yusif Aliyev
//March 10, 2018

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var item_name: UILabel!
    
    func configureCell(_ item: Item){
        item_name.text = item.item_name
    }
    
}
