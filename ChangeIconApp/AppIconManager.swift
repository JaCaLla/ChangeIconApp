import UIKit

enum AppIconName: String {
    case primary = ""          // Default icon
    case dark = "AppIconB"     // exact name for the alternative icon (no extension)
}

enum AppIconManager {
    static var supportsAlternateIcons: Bool {
        UIApplication.shared.supportsAlternateIcons
    }

    static var currentAlternateIconName: String? {
        UIApplication.shared.alternateIconName
    }

    static func setAppIcon(_ icon: AppIconName, completion: ((Error?) -> Void)? = nil) {
        guard supportsAlternateIcons else {
            completion?(NSError(domain: "AppIcon", code: -1, userInfo: [NSLocalizedDescriptionKey: "This device does not support alternative icons"]))
            return
        }

        let nameToSet: String? = (icon == .primary) ? nil : icon.rawValue

        if UIApplication.shared.alternateIconName == nameToSet {
            completion?(nil)
            return
        }

        UIApplication.shared.setAlternateIconName(nameToSet) { error in
            completion?(error)
        }
    }
}
