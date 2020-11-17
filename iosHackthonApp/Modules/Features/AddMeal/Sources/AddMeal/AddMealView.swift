//
//  AddMealView.swift
//  iosHackthonApp
//
//  Created by Gareth Miller on 09/11/2020.
//  Copyright © 2020 orgName. All rights reserved.
//

import SwiftUI
import shared
import Strings
import Theming
import Location
import Components

public struct AddMealView: View {

    public init(viewModel: AddMealViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject private var viewModel: AddMealViewModel

    @State private var title: String = ""
    @State private var additionalInfo: String = ""
    @State private var quantity: Int = 0
    @State private var availableFromDate = Date()
    @State private var useByDate = Date()
    @State private var address: String = ""
    @State private var latitude: Float = 0
    @State private var longitude: Float = 0
    @State private var isHot: Bool = true

    var buttonIsDisabled: Bool {
        title.isEmpty || additionalInfo.isEmpty || address.isEmpty || quantity == 0
    }

    public var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        Text(Strings.AddMealScreen.title)
                        TextField(Strings.AddMealScreen.titlePlaceholder, text: $title)
                            .modifier(GreyTextFieldStyle())
                        Text(Strings.AddMealScreen.additionalInfo)
                        TextField(Strings.AddMealScreen.additionalInfoPlaceholder, text: $additionalInfo)
                            .modifier(GreyTextFieldStyle())
                        Text(Strings.AddMealScreen.quantity)
                        TextField(Strings.AddMealScreen.quantityPlaceholder, value: $quantity, formatter: NumberFormatter())
                            .modifier(GreyTextFieldStyle())
                        Text(Strings.AddMealScreen.temperature)

                        HStack {
                            Button(action: {
                                isHot = true
                            }) {
                                let color = self.isHot ? ColorManager.red: ColorManager.gray
                                Image(systemName: Strings.Common.Images.hotFood)
                                    .modifier(IconButtonImageStyle(color: color))
                            }

                            Button(action: {
                                isHot = false
                            }) {
                                let color = self.isHot ? ColorManager.gray: ColorManager.blue
                                Image(systemName: Strings.Common.Images.coldFood)
                                    .modifier(IconButtonImageStyle(color: color))
                            }
                        }
                    }
                    Spacer()
                    Group {
                        DatePicker(Strings.AddMealScreen.availableFrom, selection: $availableFromDate, in: Date()..., displayedComponents: .date)
                        DatePicker(Strings.AddMealScreen.useBy, selection: $useByDate, in: Date()..., displayedComponents: .date)
                    }
                    Spacer()
                    Group {
                        Text(Strings.AddMealScreen.address)
                        HStack {
                            TextField("", text: $address)
                                .modifier(GreyTextFieldStyle())
                                .disabled(true)

                            Spacer(minLength: 10)
                            Button(action: {
                                self.address = "\(self.viewModel.locationManager.address)"
                                self.latitude = Float(self.viewModel.locationManager.userLatitude)
                                self.longitude = Float(self.viewModel.locationManager.userLongitude)
                            }) {
                                Image(systemName: Strings.Common.Images.location)
                                    .font(.title)
                                    .foregroundColor(ColorManager.appPrimary)
                            }
                        }
                    }

                    Spacer()
                    GeometryReader { geometry in
                        Button(action: {
                            let meal = Meal(
                                id: "\(viewModel.sdk.getUUID())",
                                name: "\(self.title)",
                                quantity: Int32(self.quantity),
                                availableFromDate: "\(self.availableFromDate)",
                                expiryDate: "\(self.useByDate)",
                                info: "\(self.additionalInfo)",
                                hot: self.isHot,
                                locationLat: self.latitude,
                                locationLong:  self.longitude)
                            self.viewModel.postMeal(meal: meal)
                        }) {
                            Text(Strings.AddMealScreen.addMeal)
                                .modifier(AddButtonStyle(width: geometry.size.width,
                                                         backgroundColor:
                                                            buttonIsDisabled
                                                            ? ColorManager.gray : ColorManager.appPrimary))
                        }
                        .disabled(buttonIsDisabled)
                    }
                    Spacer()
                }.padding()
            }
            .navigationBarTitle(Strings.AddMealScreen.addMeal)
            .onAppear() {
                address = "\(self.viewModel.locationManager.address)"
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            switch viewModel.activeAlert {
            case .collection:
                return Alert(
                    title: Text(viewModel.code),
                    message: Text(Strings.AddMealScreen.CollectionAlert.message),
                    dismissButton: .default(Text(Strings.Common.ok)))
            default:
                return Alert(
                    title: Text(Strings.Common.sorry),
                    message: Text(Strings.Common.ErrorAlert.message),
                    dismissButton: .default(Text(Strings.Common.ok)))
            }
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(viewModel: AddMealViewModel(sdk: MealsSDK(), locationManager: LocationManager()))
    }
}