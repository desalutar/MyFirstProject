import UIKit

class tabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // чтоб убрать кнопку назад
        self.navigationItem.hidesBackButton = true
    }
}
