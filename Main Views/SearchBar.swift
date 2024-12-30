import SwiftUI
import Combine
import SwiftSpinner

struct SearchBar: View {
    @Binding var text: String
    @ObservedObject var viewModel: AutocompleteViewModel
    @State private var showSuggestions = false
    @State private var selectedSuggestion: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Enter City Name", text: $text, onEditingChanged: { isEditing in
                    showSuggestions = isEditing
                }, onCommit: {
                    showSuggestions = false
                })
                .onChange(of: text) { newValue in
                    viewModel.fetchSuggestions(for: newValue)
                }
                .textFieldStyle(PlainTextFieldStyle())

            }
            .padding(8)
            .padding(.bottom, 5)
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                Group {
            if showSuggestions && !viewModel.suggestions.isEmpty {
                SuggestionsList(
                    suggestions: viewModel.suggestions,
                    text: $text,
                    onSuggestionTap: { suggestion in
                        text = suggestion
                        showSuggestions = false
                        selectedSuggestion = suggestion
                        // Showing SwiftSpinner
                        let cityName = suggestion.split(separator: ",").first?.trimmingCharacters(in: .whitespaces) ?? "Unknown City"

                        SwiftSpinner.show("Fetching Weather Details for \(cityName)...")
                                               
                                               
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            SwiftSpinner.hide()
                            
                            
                            viewModel.fetchCoordinates(for: suggestion){ coordinates in
                                guard let coordinates = coordinates else {
                                    print("Failed to fetch coordinates for \(suggestion)")
                                    return
                                }
                                
                                print("Coordinates for \(suggestion): \(coordinates.latitude), \(coordinates.longitude)")
                            }
                        }

                    }
                )
                .frame(maxHeight: 300)
                .padding(.top, 50)
            }

            NavigationLink(
                destination: Group {
                    if let weatherViewModel = viewModel.selectedCityWeatherViewModel {
                        SearchView(viewModel: weatherViewModel)
                    } else {
                        EmptyView()
                    }
                },
                isActive: Binding(
                    get: { viewModel.selectedCityWeatherViewModel != nil },
                    set: { if !$0 { viewModel.selectedCityWeatherViewModel = nil } }
                )
            ) {
                EmptyView()
            }
                },
                                            alignment: .topLeading
                                        )

        }
    }
}

struct SuggestionsList: View {
    let suggestions: [String]
    @Binding var text: String 
    let onSuggestionTap: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(suggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.9))
                    .onTapGesture {
                        onSuggestionTap(suggestion)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                               text = ""
                           }
                    }
            }
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 4)
    }
}
