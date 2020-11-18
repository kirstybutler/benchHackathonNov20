//
//  SignUpInfoView.swift
//  iosHackthonApp
//
//  Created by Raynelle Francisca on 18/11/2020.
//  Copyright © 2020 orgName. All rights reserved.
//

import SwiftUI

public struct SignUpInfoView: View {
	var title: String
	var description: String
	public init(title: String,
				description: String) {
		self.title = title
		self.description = description
	}
	
	public var body: some View {
		Text(title)
			.fontWeight(.bold)
			.font(.largeTitle)
		Spacer()
		Text(description)
			.fontWeight(.bold)
			.font(.subheadline)
	}
}
