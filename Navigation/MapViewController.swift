//
//  MapViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 03.02.2026.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - UI Elements
    private var mapView: MKMapView!
    private var routeButton: UIButton!
    private var clearButton: UIButton!
    private var statusLabel: UILabel!
    private var locationButton: UIButton!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var destinationCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkLocationAuthorization()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Карта"
        
        // Настраиваем навигационную панель
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupMapView()
        setupButtons()
        setupLocationButton()
        setupStatusLabel()
    }
    
    private func setupMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка внешнего вида карты
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = false
        mapView.showsBuildings = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        
        view.addSubview(mapView)
        
        // Констрейнты для карты
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Центрируем на Москве по умолчанию
        let moscowCoordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        let region = MKCoordinateRegion(
            center: moscowCoordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        mapView.setRegion(region, animated: false)
    }
    
    private func setupButtons() {
        // Контейнер для кнопок
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = .systemBackground
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Кнопка "Построить маршрут"
        routeButton = UIButton(type: .system)
        routeButton.setTitle("Построить маршрут", for: .normal)
        routeButton.backgroundColor = .systemBlue
        routeButton.setTitleColor(.white, for: .normal)
        routeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        routeButton.layer.cornerRadius = 10
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        routeButton.isEnabled = false
        
        // Кнопка "Очистить"
        clearButton = UIButton(type: .system)
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.backgroundColor = .systemGray
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        clearButton.layer.cornerRadius = 10
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        // Добавляем кнопки в контейнер
        buttonContainer.addSubview(routeButton)
        buttonContainer.addSubview(clearButton)
        view.addSubview(buttonContainer)
        
        // Констрейнты для контейнера и кнопок
        NSLayoutConstraint.activate([
            // Контейнер
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 80),
            
            // Кнопки внутри контейнера
            routeButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 20),
            routeButton.trailingAnchor.constraint(equalTo: buttonContainer.centerXAnchor, constant: -10),
            routeButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            routeButton.heightAnchor.constraint(equalToConstant: 50),
            
            clearButton.leadingAnchor.constraint(equalTo: buttonContainer.centerXAnchor, constant: 10),
            clearButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -20),
            clearButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLocationButton() {
        locationButton = UIButton(type: .system)
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.tintColor = .white
        locationButton.backgroundColor = .systemBlue
        locationButton.layer.cornerRadius = 25
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        
        view.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            locationButton.widthAnchor.constraint(equalToConstant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupStatusLabel() {
        statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 2
        statusLabel.text = "Нажмите и удерживайте для выбора точки"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            statusLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func checkLocationAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            // Запрашиваем разрешение
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.locationManager.requestWhenInUseAuthorization()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            showStatus("Определяем ваше местоположение...")
        case .denied, .restricted:
            showStatus("Доступ к геолокации запрещен")
            showLocationAlert()
        @unknown default:
            break
        }
    }
    
    private func setupGestures() {
        // Долгое нажатие для добавления точки
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Actions
    
    @objc private func routeButtonTapped() {
        guard let userLocation = userLocation,
              let destination = destinationCoordinate else {
            showStatus("Не выбрана точка назначения")
            return
        }
        
        showStatus("Строим маршрут...")
        calculateRoute(from: userLocation, to: destination)
    }
    
    @objc private func clearButtonTapped() {
        clearMap()
        showStatus("Карта очищена")
    }
    
    @objc private func locationButtonTapped() {
        if let userLocation = userLocation {
            let region = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
            showStatus("Центрируем на вашем местоположении")
        } else {
            checkLocationAuthorization()
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addPin(at: coordinate)
            destinationCoordinate = coordinate
            routeButton.isEnabled = true
            
            showStatus("Точка выбрана")
            reverseGeocode(coordinate: coordinate)
        }
    }
    
    // MARK: - Map Methods
    
    private func addPin(at coordinate: CLLocationCoordinate2D) {
        // Удаляем старые пины (кроме пользовательского)
        let annotationsToRemove = mapView.annotations.filter {
            !($0 is MKUserLocation)
        }
        mapView.removeAnnotations(annotationsToRemove)
        
        // Добавляем новую аннотацию
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Точка назначения"
        
        mapView.addAnnotation(annotation)
        
        // Центрируем карту на новой точке
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func calculateRoute(from source: CLLocationCoordinate2D,
                               to destination: CLLocationCoordinate2D) {
        // Удаляем старые маршруты
        mapView.removeOverlays(mapView.overlays)
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        directionRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка построения маршрута: \(error.localizedDescription)")
                self.showStatus("Ошибка построения маршрута")
                return
            }
            
            guard let response = response, let route = response.routes.first else {
                self.showStatus("Маршрут не найден")
                return
            }
            
            // Отображаем маршрут на карте
            self.mapView.addOverlay(route.polyline)
            
            // Показываем весь маршрут на карте
            self.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 120, right: 40),
                animated: true
            )
            
            // Показываем информацию о маршруте
            let distance = String(format: "%.1f", route.distance / 1000)
            let time = String(format: "%.0f", route.expectedTravelTime / 60)
            
            self.showStatus("Маршрут: \(distance) км, \(time) мин")
        }
    }
    
    private func clearMap() {
        // Удаляем все аннотации (кроме пользовательской)
        let annotationsToRemove = mapView.annotations.filter {
            !($0 is MKUserLocation)
        }
        mapView.removeAnnotations(annotationsToRemove)
        
        // Удаляем все маршруты
        mapView.removeOverlays(mapView.overlays)
        
        // Сбрасываем состояние
        destinationCoordinate = nil
        routeButton.isEnabled = false
    }
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude,
                                longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка геокодирования: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let address = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality
                ].compactMap { $0 }.joined(separator: ", ")
                
                // Обновляем аннотацию с адресом
                if let annotation = self.mapView.annotations.first(where: {
                    $0.coordinate.latitude == coordinate.latitude &&
                    $0.coordinate.longitude == coordinate.longitude
                }) {
                    (annotation as? MKPointAnnotation)?.subtitle = address.isEmpty ? "Адрес не найден" : address
                }
            }
        }
    }
    
    private func showStatus(_ message: String) {
        statusLabel.text = message
        statusLabel.textColor = .label
        
        // Сбрасываем через 3 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.statusLabel.text == message {
                self.statusLabel.text = "Нажмите и удерживайте для выбора точки"
                self.statusLabel.textColor = .secondaryLabel
            }
        }
    }
    
    private func showLocationAlert() {
        let alert = UIAlertController(
            title: "Геолокация отключена",
            message: "Включите геолокацию в настройках для построения маршрутов от вашего местоположения",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        userLocation = location.coordinate
        
        // При первом получении местоположения центрируем карту
        if mapView.annotations.filter({ $0 is MKUserLocation }).isEmpty {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
            showStatus("Ваше местоположение определено")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
                self.showStatus("Доступ к геолокации разрешен")
            case .denied, .restricted:
                self.showStatus("Доступ к геолокации запрещен")
                self.userLocation = nil
            case .notDetermined:
                self.showStatus("Запрашиваем разрешение...")
            @unknown default:
                break
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            renderer.alpha = 0.7
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView,
                viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Не изменяем вид пользовательской аннотации
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "DestinationPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation,
                                                  reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Настройка внешнего вида пина
            if let markerView = annotationView as? MKMarkerAnnotationView {
                markerView.markerTintColor = .systemRed
                markerView.glyphImage = UIImage(systemName: "flag.fill")
                markerView.glyphTintColor = .white
                
                // Кнопка информации
                let infoButton = UIButton(type: .detailDisclosure)
                infoButton.tintColor = .systemBlue
                markerView.rightCalloutAccessoryView = infoButton
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                annotationView view: MKAnnotationView,
                calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = view.annotation?.coordinate else { return }
        
        let alert = UIAlertController(
            title: "Точка назначения",
            message: "Выберите действие",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Построить маршрут", style: .default) { _ in
            guard let userLocation = self.userLocation else {
                self.showStatus("Сначала разрешите доступ к геолокации")
                return
            }
            self.destinationCoordinate = coordinate
            self.calculateRoute(from: userLocation, to: coordinate)
        })
        
        alert.addAction(UIAlertAction(title: "Удалить точку", style: .destructive) { _ in
            mapView.removeAnnotation(view.annotation!)
            self.destinationCoordinate = nil
            self.routeButton.isEnabled = false
            self.showStatus("Точка удалена")
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        // Для iPad нужно указать источник
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = view.bounds
        }
        
        present(alert, animated: true)
    }
}
