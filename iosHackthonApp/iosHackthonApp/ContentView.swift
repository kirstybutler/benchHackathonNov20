import SwiftUI
import shared

struct ContentView: View {
	@ObservedObject private(set) var viewModel: ViewModel

	var body: some View {
		NavigationView {
			listView()
				.navigationBarTitle("Meals")
				.navigationBarItems(leading:
															Button("Add Meal") {

																//TODO: MOVE THIS TO ADD POST SCREEN
																let sdk = PostMealApi()
																let meal = Meal(id: "\(sdk.getUUID())",
																								name: "Pizza",
																								quantity: 2,
																								availableFromDate: "Tuesday",
																								expiryDate: "Saturday",
																								info: "Meat",
																								hot: false,
																								locationLat: 51.509865,
																								locationLong:  -0.118092)

																sdk.postMeal(meal: meal, completionHandler: { response,test  in
																	print("Response \(response)")

																})
															},
														trailing:
															Button("Reload") {
																self.viewModel.loadMeals(forceReload: true)
															})

		}
	}

	private func listView() -> AnyView {
		switch viewModel.meals {
		case .loading:
			return AnyView(Text("Loading...").multilineTextAlignment(.center))
		case .result(let meals):
			return AnyView(List(meals) { meal in
				MealRow(meal: meal)
			})
		case .error(let description):
			return AnyView(Text(description).multilineTextAlignment(.center))
		}
	}
}

extension ContentView {
	enum LoadableMeals {
		case loading
		case result([Meal])
		case error(String)
	}

	class ViewModel: ObservableObject {
		let sdk: MealsSDK
		@Published var meals = LoadableMeals.loading

		init(sdk: MealsSDK) {
			self.sdk = sdk
			self.loadMeals(forceReload: false)
		}

		func loadMeals(forceReload: Bool) {
			self.meals = .loading
			sdk.getMeals(forceReload: forceReload, completionHandler: { launches, error in
				print(launches)
				if let launches = launches {
					self.meals = .result(launches)
				} else {
					self.meals = .error(error?.localizedDescription ?? "error")
				}
			})
			print("UUID example call: \(sdk.getUUID())")
		}
	}
}

struct MealRow: View {

	var meal: Meal
	var body: some View {
		HStack() {
			VStack(alignment: .leading, spacing: 10.0) {
				Text("Name: \(meal.name)")
				Text("Description: \(meal.info)")
				Text("Temperature: \(meal.hot ? "Hot" : "Cold")")
				Text("Available from: \(meal.availableFromDate)")
				Text("Expires: \(meal.expiryDate)")
				Text("Lat, Lon: [\(meal.locationLat), \(meal.locationLong)]")
				Text("Pick up code test: \(String(meal.id.suffix(4)))")
			}
			Spacer()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(viewModel: ContentView.ViewModel(sdk: MealsSDK()))
	}
}

extension Meal: Identifiable { }
