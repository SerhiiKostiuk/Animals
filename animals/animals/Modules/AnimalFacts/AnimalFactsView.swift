//
//  AnimalFactsView.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import SwiftUI
import Kingfisher

struct AnimalFactsView: View {

    // MARK: - @Environment
    @Environment(\.presentationMode) var presentationMode

    //MARK: - @State
    @State var selectionIndex = 0

    //MARK: _ Private Property
    private let model: AnimalDTO
    private static let backgroundColor = Color(red: 0.577, green: 0.358, blue: 0.749)

    //MARK: Initializer
    init(model: AnimalDTO) {
        self.model = model
    }

    //MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 50) {
                topView
                    .frame(width: proxy.size.width, alignment: .leading)
                    .padding(.bottom, 18)
                    .background(AnimalFactsView.backgroundColor.shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4))

                TabView(selection: $selectionIndex) {
                    ForEach(0..<(model.facts?.count ?? 0) , id: \.self) { index in
                        if let fact = model.facts?[index] {
                            contentView(with: fact)
                                .id(index)
                                .background {
                                    RoundedRectangle(cornerRadius: 6).fill(Color.white)
                                }
                                .padding(.horizontal, 20)
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                }.padding(.horizontal, 20)
            }
        }
        .background {
            AnimalFactsView.backgroundColor.ignoresSafeArea()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    private var topView: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image("navigate_back")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                .frame(width: 40, height: 40)
            }

            Text(model.title)
                .font(.system(size: 17))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.trailing, 40)
        }
    }

    @ViewBuilder private func contentView(with fact: FactDTO) -> some View {
        VStack(spacing: 20) {
            KFImage(URL(string: fact.imageUrl))
                .fade(duration: 0.25)
                .placeholder {
                    Image("placeholder_image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 292, height: 234)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 292, height: 292)
                .padding(.vertical, 14)
                .padding(.horizontal, 23)

            Text(fact.fact)
                .padding(.horizontal, 23)
                .font(.system(size: 18))
                .foregroundColor(.black)

            HStack {
                Button {
                    withAnimation {
                        selectionIndex -= 1
                    }

                } label: {
                    Image("back")
                        .resizable()
                        .frame(width: 52, height: 52, alignment: .leading)
                        .padding(.leading, 22)
                        .padding(.bottom, 20)

                }
                .disabled(selectionIndex == 0)
                .opacity(selectionIndex == 0 ? 0.5: 1)
                Spacer()
                Button {
                    withAnimation {
                        selectionIndex += 1
                    }

                } label: {
                    Image("next")
                        .resizable()
                        .frame(width: 52, height: 52, alignment: .trailing)
                        .padding(.trailing, 22)
                        .padding(.bottom, 20)
                }
                .disabled(selectionIndex == (model.facts?.count ?? 0) - 1)
                .opacity(selectionIndex == (model.facts?.count ?? 0) - 1 ? 0.5: 1)

            }

        }
    }
}
