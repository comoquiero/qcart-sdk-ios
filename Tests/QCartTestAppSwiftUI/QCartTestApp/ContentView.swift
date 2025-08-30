import SwiftUI

struct ContentView: View {
    @EnvironmentObject var deeplinkData: DeeplinkData

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if deeplinkData.skus.isEmpty {
                        Text("No SKUs yet")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(deeplinkData.skus, id: \.0) { sku, qty in
                            Text("\(sku): \(qty)")
                                .font(.title2)
                                .padding(2)
                        }
                    }
                }
                .padding()
            }
            .background(Color.white)
            .navigationTitle("QCartTestAppSwiftUI")
        }
    }
}