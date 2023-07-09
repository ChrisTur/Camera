import SwiftUI

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        VStack {
            Button(action: {
                isShowingCamera = true
            }) {
                Text("Open Camera")
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraView { image in
                capturedImage = image
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
