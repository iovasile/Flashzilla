//
//  CardView.swift
//  Flashzilla
//
//  Created by Ionut Vasile on 19.02.2022.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var isColorBlind
    
    let card: Card
    let removeCard: () -> Void
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white.opacity(isColorBlind ? 1 : 1 - Double(abs(offset.width / 500))))
                .background(
                    isColorBlind ? nil : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                Text(card.answer)
                    .font(.title)
                    .foregroundColor(isShowingAnswer ? .gray : .white)
                
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 15)))
        .offset(x: offset.width, y: 0)
        .opacity(2 - Double(abs(offset.width / 500)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 240 {
                        if offset.width < 0 {
                            feedback.notificationOccurred(.error)
                        }
                        removeCard()
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
        .onTapGesture { isShowingAnswer.toggle() }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example) { }
    }
}
