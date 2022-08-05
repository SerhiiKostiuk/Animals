//
//  AnimalsCategoriesList.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import SwiftUI

struct AnimalsCategoriesListView: View {

    //MARK: - @StateObject
    @ObservedObject private var viewModel = AnimalCategoriesListViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.models, id: \.order) { model in
                            NavigationLink {
                                AnimalFactsView(facts: model.facts ?? [])
                            } label: {
                                AnimalCategoryView(model: model)
                                    .id(model.order)
                                    .cornerRadius(6)
                            }
                            
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background {
                Color.purple.ignoresSafeArea()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getList()
        }
        
    }
}

struct AnimalsCategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        AnimalsCategoriesListView()
    }
}
