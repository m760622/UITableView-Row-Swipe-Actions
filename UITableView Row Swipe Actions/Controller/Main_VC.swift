//Created by Yusif Aliyev
//March 10, 2018

import UIKit

class Main_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.delegate = self
        table_view.dataSource = self
    }
    
    @IBAction func refresh_button_pressed(_ sender: Any) {
    }
}
