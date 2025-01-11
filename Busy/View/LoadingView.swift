import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    @State private var pieces: [Piece] = []
    @State private var isDispersing = false
    @State private var showText = false

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
           
            if !isDispersing {
                Image("Bees")
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        generatePieces()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            startDispersing() // Запуск анимации рассеивания
                        }
                    }
            } else {
                ZStack {
                    ForEach(pieces) { piece in
                        piece.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: piece.size, height: piece.size)
                            .clipped()
                            .position(piece.position)
                            .offset(piece.offset)
                            .opacity(piece.opacity)
                            .animation(.easeOut(duration: 3), value: piece.offset) // Анимация для каждого фрагмента
                    }
                }
            }
            
                        if showText {
                            Text("Busy as bees")
                                .font(.system(size: 40))
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .opacity(showText ? 1 : 0) // Анимация появления
                                .transition(.opacity)
                                .animation(.easeIn(duration: 3), value: showText)
                        }
        }
    }
    
    func generatePieces() {
        pieces.removeAll()
        let gridSize = 50
        let pieceSize = UIScreen.main.bounds.width / CGFloat(gridSize)
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2

        for x in 0..<gridSize {
            for y in 0..<gridSize {
                let position = CGPoint(
                    x: centerX - (UIScreen.main.bounds.width / 2) + CGFloat(x) * pieceSize + pieceSize / 2,
                    y: centerY - (UIScreen.main.bounds.height / 2) + CGFloat(y) * pieceSize + pieceSize / 2
                )

                let piece = Piece(
                    id: UUID(),
                    position: position,
                    size: pieceSize,
                    offset: CGSize.zero,
                    opacity: 1,
                    image: Image("Bees")
                )
                pieces.append(piece)
            }
        }
    }
    
    func startDispersing() {
        isDispersing = true
        for i in pieces.indices {
            withAnimation(.easeOut(duration: 2)) {
                pieces[i].offset = CGSize(
                    width: CGFloat.random(in: -300...300),
                    height: CGFloat.random(in: -300...300)
                )
                pieces[i].opacity = 0
            }
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    withAnimation {
                        showText = true
                    }
                }
        // Переход на следующий экран после завершения анимации
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}

struct Piece: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var offset: CGSize
    var opacity: Double
    var image: Image
}

