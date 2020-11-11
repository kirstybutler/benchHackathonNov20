import SwiftUI
import shared

struct MealListView: View {

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach((0 ..< viewModel.meals.count), id: \.self) {
                    MealRow(meal: viewModel.meals[$0] as! Meal)
                        .padding()
                }
            }
        }
        .navigationBarTitle(Strings.MealListScreen.title)
        .navigationBarItems(trailing:
                                Button("Reload") {
                                    self.viewModel.loadMeals(forceReload: true)
                                })
        .navigationBarBackButtonHidden(true)
    }
}

extension MealListView {

    class ViewModel: ObservableObject {

        let sdk: MealsSDK
        @Published var meals = []
        @Published

        init(sdk: MealsSDK) {
            self.sdk = sdk
            self.loadMeals(forceReload: false)
        }

        func loadMeals(forceReload: Bool) {
            sdk.getMeals(forceReload: forceReload, completionHandler: { meals, error in
                if let meals = meals {
                    self.meals = meals
                }
            })
        }

        func patchMeal(meal: Meal) {
            sdk.patchMeal(meal: meal) { meal, error in
                if let meal = meal {

                }
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView(viewModel: MealListView.ViewModel(sdk: MealsSDK()))
    }
}

extension Meal: Identifiable { }
