import SwiftUI
import QcartTestAppLogic

struct ContentView: View {
    @EnvironmentObject var deeplinkResult: DeeplinkResult

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if deeplinkResult.fullResult.isEmpty {
                        Text("No Qcart data yet")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Text(deeplinkResult.fullResult)
                            .font(.body)
                            .padding()
                            .textSelection(.enabled) // allow copy
                    }
                }
                .padding()
            }
            .navigationTitle("QcartTestAppSwiftUI")
            .background(Color.white)
        }
    }
}