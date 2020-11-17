//
//  MealListViewModel.swift
//  iosHackthonApp
//
//  Created by Gareth Miller on 11/11/2020.
//  Copyright © 2020 orgName. All rights reserved.
//

import shared
import MapKit
import Location
import Components
import Strings

public final class MealListViewModel: ObservableObject {

    let sdk: MealsSDK
    let locationManager: LocationManager

    @Published var meals = [MealWithDistance]()
    @Published var code = ""
    @Published var showingAlert = false
    @Published var activeAlert: ActiveAlert = .unavailable
    @Published var locations = [MKPointAnnotation]()
    @Published var showMap = 0
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var selectedPlace: MKPointAnnotation?

    public init(sdk: MealsSDK, locationManager: LocationManager) {
        self.sdk = sdk
        self.locationManager = locationManager
        self.loadMeals(forceReload: false)
    }

    func loadMeals(forceReload: Bool) {
        sdk.getMeals(forceReload: forceReload, completionHandler: { meals, error in
            guard
                let meals = meals,
                error == nil else { return }
            self.meals = meals
                .filter { self.mealNotExpired($0.expiryDate) }
                .map { MealWithDistance(meal: $0, distance: self.locationManager.userDistanceFrom($0.locationLat, $0.locationLong)) }
                .sorted(by: { $0.distance < $1.distance })

            for meal in meals {
                let mapAnnotation = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: Double(meal.locationLat), longitude: Double(meal.locationLong))
                mapAnnotation.coordinate = location
                mapAnnotation.title = meal.name
                mapAnnotation.subtitle = self.getQuantityText(Int(meal.quantity))
                self.locations.append(mapAnnotation)
            }
        })
    }

    private func getQuantityText(_ quantity: Int) -> String {
        if quantity > 1 {
            return "\(quantity) \(Strings.MealListScreen.portions)"
        } else if quantity == 1 {
            return "\(quantity) \(Strings.MealListScreen.portion)"
        }
        return "\(Strings.MealListScreen.Map.reserved)"
    }

    private func mealNotExpired(_ expiry: String) -> Bool {
        Date() < Date.dateFrom(dateString: expiry)
    }

    func patchMeal(meal: Meal) {
        sdk.getMeal(id: meal.id) { updatedMeal, error in

            guard
                let updatedMeal = updatedMeal,
                error == nil else {
                self.activeAlert = .error
                self.showingAlert.toggle()
                self.loadMeals(forceReload: true)
                return
            }
            if updatedMeal.quantity > 0 {
                self.sdk.patchMeal(id: updatedMeal.id, quantity: updatedMeal.quantity - 1) { meal, error in
                    guard let meal = meal else {
                        self.activeAlert = .error
                        self.showingAlert.toggle()
                        self.loadMeals(forceReload: true)
                        return
                    }
                    self.code = meal.id.last4Chars()
                    self.activeAlert = .collection
                    self.showingAlert.toggle()
                    self.loadMeals(forceReload: true)
                }
            } else {
                self.activeAlert = .unavailable
                self.showingAlert.toggle()
                self.loadMeals(forceReload: true)
            }
        }
    }
}