import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("currency") private var currency: String = "USD"

    var body: some View {
        NavigationStack {
            Form {
                Section("Apariencia") {
                    Picker("Tema", selection: $appTheme) {
                        Text("Sistema").tag("system")
                        Text("Claro").tag("light")
                        Text("Oscuro").tag("dark")
                    }
                }

                Section("Moneda") {
                    Picker("Moneda", selection: $currency) {
                        Text("USD ($)").tag("USD")
                        Text("EUR (€)").tag("EUR")
                        Text("MXN ($)").tag("MXN")
                        Text("ARS ($)").tag("ARS")
                        Text("COP ($)").tag("COP")
                    }
                }

                Section("Acerca de") {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Desarrollador")
                        Spacer()
                        Text("DuviAnt")
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Calificar la app")
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}

#Preview {
    SettingsView()
}
