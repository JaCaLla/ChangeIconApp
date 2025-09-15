import SwiftUI

struct ContentView: View {
    @AppStorage("useAltIcon") private var useAltIcon: Bool = false
    @State private var statusMsg: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: useAltIcon ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 56))
                .symbolRenderingMode(.hierarchical)

            Toggle("Use alternative icon", isOn: $useAltIcon)
                .onChange(of: useAltIcon) { _, newValue in
                    AppIconManager.setAppIcon(newValue ? .dark : .primary) { err in
                        if let err = err {
                            statusMsg = "It was not possible replacie icon: \(err.localizedDescription)"
                            // revertir el toggle si algo falla
                            useAltIcon.toggle()
                        } else {
                            statusMsg = newValue ? "Alternative icon activated." : "Default icon restored."
                        }
                    }
                }
                .disabled(!AppIconManager.supportsAlternateIcons)
                .padding(.horizontal)

            if !AppIconManager.supportsAlternateIcons {
                Text("This device does not support alternative icons.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if let current = AppIconManager.currentAlternateIconName {
                Text("Current icon: \(current)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text("Curent icon: default")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if !statusMsg.isEmpty {
                Text(statusMsg)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            let shouldBeAlt = useAltIcon
            AppIconManager.setAppIcon(shouldBeAlt ? .dark : .primary) { _ in }
        }
    }
}
