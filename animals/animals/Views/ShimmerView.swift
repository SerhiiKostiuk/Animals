//
//  ShimmerView.swift
//  animals
//
//  Created by skostiuk on 05.08.2022.
//

import SwiftUI

    //MARK: - ShimmerView
    public struct ShimmerView: View {

        @Binding var isAnimation: Bool

        //MARK: - State
        @State private var startPoint: UnitPoint
        @State private var endPoint: UnitPoint

        //MARK: - Private Property
        private let configuration: ShimmerConfiguration
        private let fillColor: Color

        //MARK: - Initializer
        init(isAnimation: Binding<Bool>, configuration: ShimmerConfiguration = .default, fillColor: Color = Color.white) {
            self._isAnimation = isAnimation
            self.configuration = configuration
            self.fillColor = fillColor
            _startPoint = .init(wrappedValue: configuration.initialLocation.start)
            _endPoint = .init(wrappedValue: configuration.initialLocation.end)
        }

        //MARK: - Body
        public var body: some View {
            GeometryReader { proxy in
                Rectangle()
                    .fill(fillColor)
                    .frame(width: proxy.size.width, height: proxy.size.height)

                LinearGradient(
                    gradient: configuration.gradient,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .zIndex(2)
                .opacity(configuration.opacity)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .animation(Animation.linear(duration: configuration.duration).repeatForever(autoreverses: false), value: startPoint)
                .opacity(isAnimation ? 1 : 0)
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation {
                            startPoint = configuration.finalLocation.start
                            endPoint = configuration.finalLocation.end
                        }
                    }

                }
            }
        }
    }

//MARK: - ShimmerConfiguration
public struct ShimmerConfiguration {

    //MARK: - Property
    public let gradient: Gradient
    public let initialLocation: (start: UnitPoint, end: UnitPoint)
    public let finalLocation: (start: UnitPoint, end: UnitPoint)
    public let duration: TimeInterval
    public let opacity: Double

    //MARK: - Static
    public static let `default` = ShimmerConfiguration(
        gradient: Gradient(stops: [
            .init(color: .white.opacity(0), location: 0),
            .init(color: Color.gray, location: 0.7),
            .init(color: Color.gray, location: 0.7),
            .init(color: .white.opacity(0), location: 1),
        ]),
        initialLocation: (start: UnitPoint(x: -1, y: 0.5), end: .leading),
        finalLocation: (start: .trailing, end: UnitPoint(x: 2, y: 0.5)),

        duration: 1,
        opacity: 0.2
    )

}
