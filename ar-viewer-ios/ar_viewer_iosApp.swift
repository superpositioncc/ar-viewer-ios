import SwiftUI

@main
struct ar_viewer_iosApp: App {
	@State private var nObjects: Int = 100 // Default number of objects to display
	
    var body: some Scene {
        WindowGroup {
            ContentView(nObjects: $nObjects)
        }
    }
}
