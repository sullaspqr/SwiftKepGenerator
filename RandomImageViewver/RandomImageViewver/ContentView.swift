//
//  ContentView.swift
//  RandomImageViewver
//
//  Created by Rendszergazda on 2024. 09. 25..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ImageViewScreen()
                .tabItem {
                    Label("Képmegjelenítő", systemImage: "photo")
                }

            AboutUsView()
                .tabItem {
                    Label("Rólunk", systemImage: "info.circle")
                }

            ContactView()
                .tabItem {
                    Label("Kapcsolat", systemImage: "phone")
                }
        }
    }
}
struct ImageViewScreen: View {
    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 150)
            } else {
                Text("Töltsd be a véletlen képet!")
                    .frame(width: 500, height: 150)
                    .background(Color.gray.opacity(0.5))
            }

            Button(action: {
                loadRandomImage()
            }) {
                Text("Véletlen Kép Betöltése")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    func loadRandomImage() {
        let urlString = "https://random.imagecdn.app/500/150"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
struct AboutUsView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.3.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()

            Text("Rólunk: Egy dinamikus csapat vagyunk, akik különféle projekteken dolgoznak.")
                .padding()
        }
    }
}
struct ContactView: View {
    var body: some View {
        VStack {
            Image(systemName: "phone.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()

            Text("Kapcsolat: +36 1 234 5678")
                .padding()

            Text("Email: info@example.com")
                .padding()
        }
    }
}

