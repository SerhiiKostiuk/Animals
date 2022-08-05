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

    //MARK: - @StateObject
    @ObservedObject private var viewModel = AnimalFactsViewModel()

    @State var selectionIndex = 0
    private let facts: [FactDTO]

    init(facts: [FactDTO]) {
        self.facts = facts
    }

    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $selectionIndex) {
                ForEach(0..<facts.count , id: \.self) { index in
                    let fact = facts[index]

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
                            .disabled(selectionIndex == facts.count - 1 )
                            .opacity(selectionIndex == facts.count - 1 ? 0.5: 1)

                        }

                    }
                    .id(index)
                    .background {
                        RoundedRectangle(cornerRadius: 6).fill(Color.white)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }.padding(.horizontal, 20)
        }

        .background {
            Color.purple.ignoresSafeArea()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    VStack {
                        Image("navigate_back")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 40, height: 40)
                    .padding(.leading, -10)
                }
                .padding(.leading, 0)
            }
        }

    }
}
//
//struct AnimalFactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimalFactsView(facts: nil)
//    }
//}
