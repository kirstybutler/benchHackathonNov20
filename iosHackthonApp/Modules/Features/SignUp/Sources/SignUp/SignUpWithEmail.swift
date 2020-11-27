//
//  SignUpWithEmail.swift
//  iosHackthonApp
//
//  Created by Raynelle Francisca on 18/11/2020.
//  Copyright © 2020 orgName. All rights reserved.
//

import SwiftUI
import Strings
import Components
import shared

struct SignUpWithEmail: View {
	@State private var email: String = ""
	@State private var moveToNextScreen: Bool = false

	var body: some View {
		VStack(alignment: .leading) {
			SignUpInfoView(title: Strings.SignUp.signUpWithEmailTitle, description: Strings.SignUp.signUpWithEmailInfo)

			Spacer().frame(maxHeight: .infinity)
			
			GeometryReader { geometry in
				let viewModel = SignUpUserEntryViewModel(
					isSignupWithEmail: true,
					textFieldPlaceholder: Strings.SignUp.signUpWithEmailPlaceHolder,
					buttonTitle: Strings.SignUp.signUpWithEmailButtonTitle,
					width: geometry.size.width,
					entryField: $email,
					signUp: self.signUp,
					moveToNextScreen: $moveToNextScreen,
					isLoading: .constant(false))
				
				let signupViewModel = SignUpViewModel(email: self.email ,firebase: FirebaseAuthenticationStore(), authorizationStore: AuthorizationStore(cache: UserDefaults.standard))

				SignUpUserEntryView(viewModel: viewModel, destinationView: SignUpWithPassword(viewModel: signupViewModel))
			}
		}.padding()
	}
}

struct SignUpWithEmail_Previews: PreviewProvider {
    static var previews: some View {
        SignUpWithEmail()
    }
}

//MARK:- Functions
private extension SignUpWithEmail {
	func signUp() {
		self.moveToNextScreen = true
	}
}
