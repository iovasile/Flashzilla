//
//  CardView.swift
//  Flashzilla
//
//  Created by Ionut Vasile on 19.02.2022.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let removeCard: () -> Void
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
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
        .opacity(2 - Double(abs(offset.width / 250)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 250 {
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
