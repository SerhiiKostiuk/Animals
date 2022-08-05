//
//  AnimalsCategoriesList.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import SwiftUI

struct AnimalsCategoriesListView: View {
    
    //MARK: - @StateObject
    @StateObject private var viewModel = AnimalCategoriesListViewModel()
    
    //MARK: - @State
    @State private var isShowPaidAlert = false
    @State private var isShowComingSoonAlert = false
    @State private var isShowLoader = false
    @State private var isPushView = false
    
    //MARK: - Static property
    private static let backgroundColor = Color(red: 0.577, green: 0.358, blue: 0.749)
    
    //MARK: - Initializer
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(AnimalsCategoriesListView.backgroundColor)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                NavigationLink(isActive: $isPushView) {
                    if let model = viewModel.selectedModel {
                        AnimalFactsView(model: model)
                            .id("AnimalFactsView\(model.id)")
                    } else {
                        EmptyView()
                    }
                } label: {
                    EmptyView().hidden()
                }.opacity(0.0)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        if viewModel.models.isEmpty {
                            ForEach(0...2, id: \.self) { _ in
                                ShimmerView(isAnimation: $viewModel.inProgress)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                                    .cornerRadius(6)
                            }
                            
                        } else {
                            ForEach(viewModel.models, id: \.order) { model in
                                Button {
                                    viewModel.selectedModel = model
                                    
                                    switch model.contentType {
                                    case .comingSoon: isShowComingSoonAlert.toggle()
                                    case .paid: isShowPaidAlert.toggle()
                                    case .free: isPushView.toggle()
                                    }
                                } label: {
                                    AnimalCategoryView(model: model)
                                        .cornerRadius(6)
                                }.id(model.id)
                            }
                        }
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background {
                AnimalsCategoriesListView.backgroundColor.ignoresSafeArea()
            }
            .alert(isPresented: $isShowComingSoonAlert, content: {
                Alert(title: Text(viewModel.selectedModel?.title ?? ""), dismissButton: .default(Text("Ok")) )
            })
        }
        .alert(isPresented: $isShowPaidAlert, content: {
            Alert(title: Text("Watch Ad to continue"),
                  primaryButton: .default(Text("Show Ad"), action: {
                isShowLoader.toggle()
            }),
                  secondaryButton: .cancel())
        })
        .overlay(content: {
            if isShowLoader {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isShowLoader.toggle()
                        isPushView.toggle()
                    }
                }
            }
        })
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getList()
        }
        .onDisappear {
            viewModel.invalidate()
        }
    }
}

struct AnimalsCategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        AnimalsCategoriesListView()
    }
}
