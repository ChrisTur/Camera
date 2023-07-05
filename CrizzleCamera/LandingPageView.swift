import SwiftUI
import UIKit
import Vision
import UniformTypeIdentifiers

struct LandingPageView: View {
    @State private var showCameraView = false
    @State private var detectedPeople: [CGRect] = []
    
    var body: some View {
        ZStack {
            Image("Landing") // Replace "Landing" with the name of your image asset
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Button(action: {
                    showCameraView = true
                }) {
                    Text("Access Camera")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .offset(y: -20)
            }
        }
        .sheet(isPresented: $showCameraView) {
            CameraView(mediaTypes: [UTType.image.identifier]) { image in
                detectPeople(in: image)
            }
        }
    }
    
    func detectPeople(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNDetectHumanRectanglesRequest { request, error in
            guard let observations = request.results as? [VNHumanObservation] else { return }
            
            DispatchQueue.main.async {
                detectedPeople = observations.map { $0.boundingBox }
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error: \(error)")
        }
    }
}
