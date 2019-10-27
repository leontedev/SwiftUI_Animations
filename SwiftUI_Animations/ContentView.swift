//
//  ContentView.swift
//  SwiftUI_Animations
//
//  Created by Mihai Leonte on 10/27/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius:10))
            .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation }
                .onEnded { _ in
                    withAnimation(.spring()) { // explicit animation: animate only the release
                        self.dragAmount = .zero
                    }
                }
        )
        //.animation(.spring()) // implicit animation: this will animate both dragging and releasing
    }
}

struct HelloView: View {
    let letters = Array("Debit Card")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(self.letters[num]))
                .padding(5)
                    .font(.title)
                    .background(self.enabled ? Color.blue : Color.red)
                    .offset(self.dragAmount)
                    .animation(Animation.default.delay(Double(num) / 20))
                
            }
        }.gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation }
                .onEnded { _ in
                    self.dragAmount = .zero
                    self.enabled.toggle()
            }
        )
    }
}

struct ButtonView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button(isShowingRed ? "Remove Card" : "New Card") {
                withAnimation {
                    self.isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                CardView().transition(.asymmetric(insertion: .pivot, removal: .scale))
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack {
            ButtonView()
            
            ZStack {
                CardView()
                HelloView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
