//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import RoomieRadarCoreData
import Styleguide
import SwiftUI
import UIComponents

struct WGSearcherProfileScreen: View {
  let wgSearcher: WGSearcher

  var body: some View {
    NavigationView {
      List {
        genericTextFields
        generalInfo
        bottomButton
      }
      .navigationTitle("Profil")
    }
  }

  private var genericTextFields: some View {
    Group {
      createGenericTextFieldSection(
        sectionHeader: "Name",
        placeholder: "Wie heißt du?",
        binding: Binding(
          get: { wgSearcher.name },
          set: { newValue in wgSearcher.name = newValue }
        )
      )
      createGenericTextFieldSection(
        sectionHeader: "Beschreibung",
        placeholder: "Wie beschreibst du dich?",
        binding: Binding(
          get: { wgSearcher.ownDescription },
          set: { newValue in wgSearcher.ownDescription = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Hobbys",
        placeholder: "Was sind deine Hobbys?",
        binding: Binding(
          get: { wgSearcher.hobbies },
          set: { newValue in wgSearcher.hobbies = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Kontaktinfo",
        placeholder: "Wie kann man dich kontaktieren?",
        binding: Binding(
          get: { wgSearcher.contactInfo },
          set: { newValue in wgSearcher.contactInfo = newValue }
        )
      )
    }
  }

  private var generalInfo: some View {
    Section("Allgemeine Infos") {
      HStack(spacing: 20) {
        TextField("Alter", text: Binding(
          get: { wgSearcher.age },
          set: { newValue in wgSearcher.age = newValue }
        ))
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .keyboardType(.numberPad)

        TextField("Geschlecht", text: Binding(
          get: { wgSearcher.gender },
          set: { newValue in wgSearcher.gender = newValue }
        ))
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      .listRowInsets(.init())
      .listRowBackground(Color.clear)
    }
  }

  private var bottomButton: some View {
    HStack {
      Spacer()
      Button {
        try? CoreDataStack.shared.mainContext.save()
      } label: {
        Text("Speichern")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle())
      Spacer()
    }
    .listRowBackground(Color.clear)
  }

  private func createGenericTextFieldSection(
    sectionHeader: String,
    placeholder: String,
    binding: Binding<String>
  ) -> some View {
    Section(sectionHeader) {
      TextField(placeholder, text: binding, axis: .vertical)
        .lineLimit(1 ... 5)
    }
  }
}
