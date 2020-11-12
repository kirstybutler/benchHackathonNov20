//
//  TabAppView.swift
//  iosHackthonApp
//
//  Created by Raynelle Francisca on 11/11/2020.
//  Copyright © 2020 orgName. All rights reserved.
//


import SwiftUI
import shared

struct TabAppView: View {
	private let sdk = MealsSDK()
	private let locationManager = LocationManager()
	@State var selectedView = 0

	var body: some View {
		TabView(selection: $selectedView, content: {
			NavigationView {
				AddMealView(viewModel: .init(sdk: self.sdk, locationManager: self.locationManager))
			}
			.navigationBarHidden(true)
			.tabItem {
				Image(systemName: Strings.LandingScreen.Images.plus)
				Text(Strings.LandingScreen.plusButtonText)
			}.tag(0)

			NavigationView {
				MealListView(viewModel: .init(sdk: self.sdk))
			}
			.navigationBarHidden(true)
			.tabItem {
				Image(systemName: Strings.LandingScreen.Images.find)
				Text(Strings.LandingScreen.findButtonText)
			}.tag(1)
		})
		
	}
}

struct TabAppView_Previews: PreviewProvider {
	static var previews: some View {
		TabAppView()
	}
}
