//Created by Yusif Aliyev
//March 10, 2018

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var item_name: UILabel!
    @IBOutlet weak var star_image: UIImageView!
    
    func configureCell(_ item: Item){
        item_name.text = item.item_name
        if item.is_favorite == true {
            star_image.image = #imageLiteral(resourceName: "fav")
        } else {
            star_image.image = #imageLiteral(resourceName: "not-fav")
        }
    }
    
}
