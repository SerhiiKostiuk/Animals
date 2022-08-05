//
//  AnimalCategoryView.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import SwiftUI
import Kingfisher

struct AnimalCategoryView: View {

    //MARK: - Private Property
    private let model: AnimalDTO

    //MARK: - Initializer
    init(model: AnimalDTO) {
        self.model = model
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            KFImage(URL(string: model.imageUrl))
                .fade(duration: 0.25)
                .placeholder {
                    Image("placeholder_image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 121, height: 90)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 121, height: 90)
                .clipped()
                .padding(.vertical, 5)

            VStack(alignment: .leading, spacing: 0) {
                Text(model.title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)

                Text(model.description)
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.5))

                if model.contentType == .paid {
                    Spacer()
                    HStack(spacing: 4) {
                        Image("lock")
                        Text("Premium")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.031, green: 0.227, blue: 0.921, opacity: 1))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top], 10)
            .padding(.bottom, 7)

        }
        .padding(.leading, 10)
        .padding(.trailing, 3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .background {
            Color.white
        }
        .overlay {
            if model.contentType == .comingSoon {
                ZStack(alignment: .trailing) {
                    Color.black.opacity(0.6)
                    Image("coming_soon")
                }
            }
        }
    }
}

struct AnimalCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalCategoryView(model: AnimalDTO(title: "some", description: "descrip", imageUrl: "fff", status: AnimalDTOStatus.paid, order: 2, facts: nil))
    }
}


