import UIKit
import YandexMapsMobile
import MapKit

protocol YMKAnnotation {
    var coordimate: YMKMapCoordinate { get }
    func title() -> String!
    func subTitle() -> String!
}

typealias YMKMapCoordinate = YMKPoint

class MapVc: InternetStateVC, PickPointDelegate{
    var mapView: YMKMapView!
    lazy var map: YMKMap = {
        return mapView.mapWindow.map!
    }()
    lazy var mapWindow: YMKMapWindow = {
        return mapView.mapWindow
    }()
    lazy var mapObject: YMKMapObjectCollection = {
        return map.mapObjects!
    }
    var center: YMKPoint {
        return map.cameraPosition.target
    }
}
