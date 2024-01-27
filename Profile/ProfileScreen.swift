//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import NukeUI
import PhotosUI
import Styleguide
import SwiftUI
import UIComponents

struct ProfileScreen: View {
  @ObservedObject private var viewModel: ProfileScreenViewModel

  init(viewModel: ProfileScreenViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationView {
      List {
        profileImage
        if viewModel.isWGOffererState {
          wgOffererTextFields
          wgOffererGeneralInfo
        } else {
          wgSearcherTextFields
          wgSearcherGeneralInfo
        }
        bottomButton
      }
      .navigationTitle("Profil")
      .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {}
    }
  }

  private var profileImage: some View {
    VStack(alignment: .trailing) {
      HStack {
        Spacer()
        LazyImage(url: viewModel.imageURL) { state in
          if let image = state.image {
            image
              .resizable()
              .clipShape(Circle())
              .frame(width: 200, height: 200)
              .overlay(alignment: .bottomTrailing) {
                PhotosPicker(
                  selection: $viewModel.avatarItem,
                  matching: .images,
                  photoLibrary: .shared()
                ) {
                  Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 30))
                }
                .buttonStyle(.borderless)
                .padding(.leading, -20)
              }
          } else {
            Image(systemName: "person.crop.circle.fill")
              .resizable()
              .frame(width: 200, height: 200)
              .overlay(alignment: .bottomTrailing) {
                PhotosPicker(
                  selection: $viewModel.avatarItem,
                  matching: .images,
                  photoLibrary: .shared()
                ) {
                  Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 30))
                }
                .buttonStyle(.borderless)
                .padding(.leading, -20)
              }
          }
        }
        Spacer()
      }
    }
    .padding(.bottom, -10)
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
    .onChange(of: viewModel.avatarItem) { _ in
      Task {
        if let loaded = try? await viewModel.avatarItem?.loadTransferable(type: Image.self) {
          viewModel.avatarImage = loaded
          viewModel.getURL(item: viewModel.avatarItem) { result in
            switch result {
              case .success(let url):
                WGSearcher.shared.imageString = url.absoluteString
                WGOfferer.shared.imageString = url.absoluteString
              case .failure(let failure):
                viewModel.showError = true
                viewModel.errorMessage = failure.localizedDescription
            }
          }
        } else {
          viewModel.showError = true
          viewModel.errorMessage = L10n.genericError
        }
      }
    }
  }

  private var wgSearcherTextFields: some View {
    Group {
      createGenericTextFieldSection(
        sectionHeader: "Name",
        placeholder: "Wie heißt du?",
        binding: Binding(
          get: { WGSearcher.shared.name },
          set: { newValue in WGSearcher.shared.name = newValue }
        )
      )
      createGenericTextFieldSection(
        sectionHeader: "Beschreibung",
        placeholder: "Wie beschreibst du dich?",
        binding: Binding(
          get: { WGSearcher.shared.ownDescription },
          set: { newValue in WGSearcher.shared.ownDescription = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Hobbys",
        placeholder: "Was sind deine Hobbys?",
        binding: Binding(
          get: { WGSearcher.shared.hobbies },
          set: { newValue in WGSearcher.shared.hobbies = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Kontaktinfo",
        placeholder: "Wie kann man dich kontaktieren?",
        binding: Binding(
          get: { WGSearcher.shared.contactInfo },
          set: { newValue in WGSearcher.shared.contactInfo = newValue }
        )
      )
    }
  }

  private var wgSearcherGeneralInfo: some View {
    Group {
      generalInfo(
        placeholder1: "Alter",
        placeHolder2: "Geschlecht",
        binding1: Binding(
          get: { WGSearcher.shared.age },
          set: { newValue in WGSearcher.shared.age = newValue }
        ),
        binding2: Binding(
          get: { WGSearcher.shared.gender },
          set: { newValue in WGSearcher.shared.gender = newValue }
        )
      )
    }
  }

  private var wgOffererGeneralInfo: some View {
    Group {
      generalInfo(
        placeholder1: "Preis",
        placeHolder2: "Größe",
        binding1: Binding(
          get: { WGOfferer.shared.wgPrice },
          set: { newValue in WGOfferer.shared.wgPrice = newValue }
        ),
        binding2: Binding(
          get: { WGOfferer.shared.wgSize },
          set: { newValue in WGOfferer.shared.wgSize = newValue }
        )
      )
    }
  }

  private func generalInfo(
    placeholder1: String,
    placeHolder2: String,
    binding1: Binding<String>,
    binding2: Binding<String>
  ) -> some View {
    Section("Allgemeine Infos") {
      HStack(spacing: 20) {
        TextField(placeholder1, text: binding1)
          .padding(.horizontal, 20)
          .frame(maxHeight: .infinity)
          .background(Color(uiColor: .secondarySystemGroupedBackground))
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .keyboardType(.numberPad)

        TextField(placeHolder2, text: binding2)
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
        viewModel.saveChanges()
      } label: {
        Text("Speichern")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle())
      Spacer()
    }
    .listRowBackground(Color.clear)
  }

  private var wgOffererTextFields: some View {
    Group {
      createGenericTextFieldSection(
        sectionHeader: "Name",
        placeholder: "Wie heißt ihr?",
        binding: Binding(
          get: { WGOfferer.shared.name },
          set: { newValue in WGOfferer.shared.name = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Beschreibung",
        placeholder: "Wie beschreibt ihr eure WG?",
        binding: Binding(
          get: { WGOfferer.shared.wgDescription },
          set: { newValue in WGOfferer.shared.wgDescription = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Adresse",
        placeholder: "Ich wohne in der ...",
        binding: Binding(
          get: { WGOfferer.shared.address },
          set: { newValue in WGOfferer.shared.address = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Mitbewohner",
        placeholder: "Unser neuer Mitbewohner sollte ...",
        binding: Binding(
          get: { WGOfferer.shared.idealRoommate },
          set: { newValue in WGOfferer.shared.idealRoommate = newValue }
        )
      )

      createGenericTextFieldSection(
        sectionHeader: "Kontaktinfo",
        placeholder: "Man kann uns erreichen unter ...",
        binding: Binding(
          get: { WGOfferer.shared.contactInfo },
          set: { newValue in WGOfferer.shared.contactInfo = newValue }
        )
      )
    }
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
