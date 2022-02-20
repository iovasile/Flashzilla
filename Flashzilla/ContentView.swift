//
//  ContentView.swift
//  Flashzilla
//
//  Created by Ionut Vasile on 17.02.2022.
//

import SwiftUI

struct ContentView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.accessibilityDifferentiateWithoutColor) var isColorBlind
    @Environment(\.scenePhase) var scenePhase
    
    @State private var timerIsActive = true
    @State private var cards = [Card].init(repeating: Card.example, count: 10)
    @State private var timeRemaining = 90
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) { withAnimation { removeCard(at: index) } }
                        .stacked(at: index, in: cards.count)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Restart", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            if isColorBlind {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard timerIsActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                if !cards.isEmpty {
                    timerIsActive = true
                }
            } else {
                timerIsActive = false
            }
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
        if cards.isEmpty { timerIsActive = false }
    }
    
    func resetCards() {
        cards = [Card].init(repeating: Card.example, count: 10)
        timeRemaining = 90
        timerIsActive = true
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
