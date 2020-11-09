import SwiftUI
import shared

struct MealListView: View {

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        listView()
            .navigationBarTitle("Meals")
            .navigationBarItems(trailing:
                                    Button("Reload") {
                                        self.viewModel.loadMeals(forceReload: true)
                                    })
            .navigationBarBackButtonHidden(true)
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

extension MealListView {
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
                if let launches = launches {
                    self.meals = .result(launches)
                } else {
                    self.meals = .error(error?.localizedDescription ?? "error")
                }
            })
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

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView(viewModel: MealListView.ViewModel(sdk: MealsSDK()))
    }
}

extension Meal: Identifiable { }
