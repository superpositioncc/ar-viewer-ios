import SwiftUI

@main
struct ar_viewer_ios_app_clipApp: App {
	@State private var nObjects: Int = 100 // Default number of objects to display
	
    var body: some Scene {
        WindowGroup {
			ContentView(nObjects: $nObjects)
			
			ZStack {}
				.onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
					guard let result = userActivity.webpageURL?.absoluteString else {
						return
					}
					
					if (result.starts(with: "https://ar-viewer.sprps.dev/?nObjects=")) {
						let index = result.index(result.startIndex, offsetBy: "https://ar-viewer.sprps.dev/?nObjects=".count)
						nObjects = Int(result[index...]) ?? 100
					}
				}
        }
    }
}
