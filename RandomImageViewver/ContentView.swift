import SwiftUI
import MessageUI

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
                    Label("Kapcsolat", systemImage: "message")
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
    @State private var userName: String = ""
    @State private var contactAddress: String = ""
    @State private var messageBody: String = ""
    @State private var showMessageComposer = false
    @State private var showMailComposer = false
    
    var body: some View {
        VStack {
            Image(systemName: "message.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()

            Text("Kapcsolat: +36 70 719 1515")
                .padding()

            Text("Email: nemethb@kkszki.hu")
                .padding()
            
            // Szövegbevitel a névhez
            TextField("Írd be a neved", text: $userName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            //Szövegbevitel kapcsolathoz
            TextField("Írd be a telefonszámod / email címed", text: $contactAddress)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Szövegbevitel az üzenethez
            TextEditor(text: $messageBody)
                .frame(height: 150)
                .border(Color.gray, width: 1)
                .padding()

            // iMessage küldése gomb
            Button(action: {
                showMessageComposer = true
            }) {
                Text("Üzenet küldése iMessage-ben")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showMessageComposer) {
                MessageComposerView(recipients: ["sulla.spqr78@gmail.com"], body: "Név: \(userName)\nTelefon/Email: \(contactAddress)\nÜzenet: \(messageBody)")
            }

            // Email küldése gomb
            Button(action: {
                showMailComposer = true
            }) {
                Text("Üzenet küldése Emailben")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showMailComposer) {
                MailComposerView(recipients: ["nemethb@kkszki.hu"], subject: "Kapcsolatfelvétel", body: "Név: \(userName)\nTelefon/Email: \(contactAddress)\nÜzenet: \(messageBody)")
            }
        }
        .padding()
    }
}

// iMessage küldése
struct MessageComposerView: UIViewControllerRepresentable {
    var recipients: [String] = []
    var body: String = ""

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposerView

        init(parent: MessageComposerView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.recipients = recipients
        controller.body = body
        controller.messageComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}

// Email küldése
struct MailComposerView: UIViewControllerRepresentable {
    var recipients: [String] = []
    var subject: String = ""
    var body: String = ""

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposerView

        init(parent: MailComposerView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setToRecipients(recipients)
        controller.setSubject(subject)
        controller.setMessageBody(body, isHTML: false)
        controller.mailComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
