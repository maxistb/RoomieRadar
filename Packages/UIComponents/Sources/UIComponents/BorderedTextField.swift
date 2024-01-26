//
//  SwiftUIView.swift
//
//
//  Created by Maximillian Stabe on 21.01.24.
//

import Styleguide
import SwiftUI

public struct BorderedTextField: View {
  @Environment(\.colorScheme) var colorScheme
  @FocusState private var isTextFieldFocus
  @State private var passwordVisible = false

  @Binding var textInput: String
  let placeholder: String
  let isPasswordField: Bool

  public init(textInput: Binding<String>, placeholder: String, isPasswordField: Bool) {
    self._textInput = textInput
    self.placeholder = placeholder
    self.isPasswordField = isPasswordField
  }

  public var body: some View {
    ZStack {
      colorScheme == .light ? Color.white : Asset.Color.darkSecondary.swiftUIColor

      HStack {
        ZStack(alignment: .trailing) {
          textField
        }
        trailingImage
          .foregroundStyle(Color.gray)
      }
      .frame(minHeight: 24)
      .padding()
      .cornerRadius(6)
      .padding(3)
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color.gray)
      )
    }
    .frame(maxHeight: 60)
  }

  private var textField: some View {
    Group {
      if passwordVisible {
        SecureField(placeholder, text: $textInput)
          .id("TEXTFIELD")
          .focused($isTextFieldFocus)
      } else {
        TextField(placeholder, text: $textInput)
          .id("TEXTFIELD")
          .focused($isTextFieldFocus)
      }
    }
  }

  private var trailingImage: some View {
    Button {
      if !isPasswordField {
        textInput = ""
      } else {
        passwordVisible.toggle()
      }
    } label: {
      if isTextFieldFocus || !textInput.isEmpty {
        imageForTextFieldFocus
      }
    }
    .focused($isTextFieldFocus)
  }

  private var imageForTextFieldFocus: Image {
    if isPasswordField {
      Image(systemName: passwordVisible ? "eye.slash.fill" : "eye.fill")
    } else {
      Image(systemName: "xmark.circle")
    }
  }
}
