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
  @ObservedObject var viewModel: ProfileScreenViewModel
  var path: Binding<[ProfileNavigation]>

  var body: some View {
    NavigationStack(path: path) {
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
      .fullScreenCover(isPresented: $viewModel.showImagePicker, onDismiss: nil) {
        ImagePicker(image: $viewModel.avatarImage)
          .ignoresSafeArea()
      }
    }
  }

  private var profileImage: some View {
    VStack(alignment: .trailing) {
      HStack {
        Spacer()
        LazyImage(url: viewModel.avatarImage != nil ? nil : viewModel.imageURL) { state in
          let image = state.image ?? viewModel.avatarImage.map { Image(uiImage: $0) }
          imageOverlayView(image: image ?? Image(systemName: "person.crop.circle.fill")) {
            viewModel.showImagePicker = true
          }
        }
        Spacer()
      }
    }
    .padding(.bottom, -10)
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
    .onChange(of: viewModel.avatarImage) { _ in
      viewModel.persistImageToStorage()
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
          get: { WGOfferer.shared.ownDescription },
          set: { newValue in WGOfferer.shared.ownDescription = newValue }
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

  private func imageOverlayView(image: Image?, action: @escaping () -> Void) -> some View {
    image?
      .resizable()
      .clipShape(Circle())
      .frame(width: 150, height: 150)
      .overlay(alignment: .bottomTrailing) {
        Button(action: action) {
          Image(systemName: "pencil.circle.fill")
            .font(.system(size: 30))
        }
        .buttonStyle(.borderless)
        .padding(.leading, -20)
      }
  }
}

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?

  private let controller = UIImagePickerController()

  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let parent: ImagePicker

    init(parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      parent.image = info[.originalImage] as? UIImage
      picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }

  func makeUIViewController(context: Context) -> some UIViewController {
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
