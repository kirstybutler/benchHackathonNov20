//
//  LocationNeededMessageBox.swift
//  
//
//  Created by Gareth Miller on 17/11/2020.
//

import SwiftUI
import Strings
import Theming

public struct LocationNeededMessageBox: View {

    private let widthRatio: CGFloat = 0.25
    private let cornerRadius: CGFloat = 16
    private let paddingRatio: CGFloat = 10

    private var width: CGFloat
    private var buttonColor: Color
    private var image: String
    private var text: String
    private var buttonText: String
    private var paddingSize: CGFloat

    public init(width: CGFloat,
                buttonColor: Color,
                image: String,
                text: String,
                buttonText: String) {
        self.width = width
        self.buttonColor = buttonColor
        self.image = image
        self.text = text
        self.buttonText = buttonText
        paddingSize = width/paddingRatio
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(ColorManager.appPrimary)
            VStack {
                Spacer()
                Image(systemName: image)
                    .resizable()
                    .frame(width: width * widthRatio, height: width * widthRatio)
                Spacer()
                Text(text)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(buttonText) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
                .foregroundColor(.blue)
            }
            .padding()
        }
        .foregroundColor(.white)
        .padding(.init(top: paddingSize/2, leading: paddingSize, bottom: paddingSize, trailing: paddingSize))
    }
}