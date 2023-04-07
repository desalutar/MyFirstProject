
import UIKit
import CoreLocation

class alertLocationViewController: UITabBarController {
    func checkLocaion()  {
        // тут я вызываю проверку алерта
        if CLLocationManager.locationServicesEnabled() {
            self.setupManager()
        } else {
            let alert = UIAlertController(title: "У вас не включена геолокация", message: "Хотите включить?", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) {(alert) in
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
        }
}
