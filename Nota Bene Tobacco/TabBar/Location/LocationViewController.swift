import UIKit
import YandexMapsMobile
import CoreLocation


class LocationViewController: UIViewController{
    
    @IBOutlet weak var mapView: YMKMapView!
    
    let TARGET_LOCATION = YMKPoint(latitude: 55.74221875688048, longitude: 37.625262117721455)
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // вызываем функцию которая проверяет подключены ли службы геолокации
        backgraundTask()
        
        // Тут подгружаем яндекс карты
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: TARGET_LOCATION, zoom: 2, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    
    }
    
    // MARK: - многопоточность
    func backgraundTask() {
        DispatchQueue.global(qos: .background).async {
            // тут я вызываю проверку алерта
            if CLLocationManager.locationServicesEnabled() {
                self.setupManager()
            } else {
                let alert = UIAlertController(title: "У вас не включена геолокация",
                                              message: "Хотите включить?",
                                              preferredStyle: .alert)

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
        // переходит на другой поток и как я понял
        DispatchQueue.main.async {
            self.mainTask()
        }
    }
    
    func mainTask() {
        setupManager()
    }
    
    // хуй пойми зачем но надо
    func setupManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}


extension LocationViewController:CLLocationManagerDelegate{
    // MARK: - вывод алерта на запрос к службам геолокациии
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let userLocation = YMKPoint(latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude)
            mapView.mapWindow.map.move(
                with: YMKCameraPosition.init(target: userLocation, zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                cameraCallback: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Геопозиция не разрешена",
                                          message: "Вы можете разрешить использование геопозиции в настройках",
                                          preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) {(alert) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
