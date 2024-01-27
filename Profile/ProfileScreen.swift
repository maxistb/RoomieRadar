//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import NukeUI
import PhotosUI
import RoomieRadarCoreData
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
        if let wgSearcher = viewModel.wgSearcher {
          wgSearcherTextFields
          wgSearcherGeneralInfo
        } else if let wgOfferer = viewModel.wgOfferer {
          wgOffererTextFields
          wgOffererGeneralInfo
        }
        bottomButton
      }
      .navigationTitle("Profil")
      .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {}
      .onAppear {
        print("OFFERER: \(viewModel.wgOfferer)")
        print("SEARCHER: \(viewModel.wgSearcher)")
      }
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
                viewModel.wgSearcher?.imageString = url.absoluteString
                viewModel.wgOfferer?.imageString = url.absoluteString
              case .failure(let failure):
                viewModel.showError = true
                viewModel.errorMessage = failure.localizedDescription
            }
          }

          try? CoreDataStack.shared.mainContext.save()
        } else {
          viewModel.showError = true
          viewModel.errorMessage = L10n.genericError
        }
      }
    }
  }

  private var wgSearcherTextFields: some View {
    Group {
      if let wgSearcher = viewModel.wgSearcher {
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
  }

  private var wgSearcherGeneralInfo: some View {
    Group {
      if let wgSearcher = viewModel.wgSearcher {
        generalInfo(
          placeholder1: "Alter",
          placeHolder2: "Geschlecht",
          binding1: Binding(
            get: { wgSearcher.age },
            set: { newValue in wgSearcher.age = newValue }
          ),
          binding2: Binding(
            get: { wgSearcher.gender },
            set: { newValue in wgSearcher.gender = newValue }
          )
        )
      }
    }
  }

  private var wgOffererGeneralInfo: some View {
    Group {
      if let wgOfferer = viewModel.wgOfferer {
        generalInfo(
          placeholder1: "Preis",
          placeHolder2: "Größe",
          binding1: Binding(
            get: { wgOfferer.wgPrice },
            set: { newValue in wgOfferer.wgPrice = newValue }
          ),
          binding2: Binding(
            get: { wgOfferer.wgSize },
            set: { newValue in wgOfferer.wgSize = newValue }
          )
        )
      }
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
      if let wgOfferer = viewModel.wgOfferer {
        createGenericTextFieldSection(
          sectionHeader: "Name",
          placeholder: "Wie heißt ihr?",
          binding: Binding(
            get: { wgOfferer.name },
            set: { newValue in wgOfferer.name = newValue }
          )
        )

        createGenericTextFieldSection(
          sectionHeader: "Beschreibung",
          placeholder: "Wie beschreibt ihr eure WG?",
          binding: Binding(
            get: { wgOfferer.wgDescription },
            set: { newValue in wgOfferer.wgDescription = newValue }
          )
        )

        createGenericTextFieldSection(
          sectionHeader: "Adresse",
          placeholder: "Ich wohne in der ...",
          binding: Binding(
            get: { wgOfferer.address },
            set: { newValue in wgOfferer.address = newValue }
          )
        )

        createGenericTextFieldSection(
          sectionHeader: "Mitbewohner",
          placeholder: "Unser neuer Mitbewohner sollte ...",
          binding: Binding(
            get: { wgOfferer.idealRoommate },
            set: { newValue in wgOfferer.idealRoommate = newValue }
          )
        )

        createGenericTextFieldSection(
          sectionHeader: "Kontaktinfo",
          placeholder: "Man kann uns erreichen unter ...",
          binding: Binding(
            get: { wgOfferer.contactInfo },
            set: { newValue in wgOfferer.contactInfo = newValue }
          )
        )
      }
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
