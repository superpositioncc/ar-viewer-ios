import SwiftUI

struct ContentView: View {
	@Binding var nObjects: Int
	
    var body: some View {
        ARViewIndicator(nObjects: $nObjects)
			.edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView(nObjects: .constant(100))
}
