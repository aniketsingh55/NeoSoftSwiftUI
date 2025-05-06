

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModelWrapper()
    @State private var searchText = ""
    @State private var showStats = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {

                    // Carousel
                    TabView(selection: $viewModel.currentPageIndex) {
                        ForEach(viewModel.viewModel.imageItems.indices, id: \.self) { index in
                            Image(viewModel.viewModel.imageItems[index].imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .padding(.horizontal)
                                .tag(index)
                        }
                    }
                    .frame(height: 200)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .padding(20)
                    .onChange(of: viewModel.currentPageIndex) {
                        viewModel.viewModel.updatePage(index: viewModel.currentPageIndex)
                    }

                    // Search bar
                    Section(header:
                        TextField("Search", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .onChange(of: searchText) {
                                viewModel.viewModel.updateSearch(query: searchText)
                            }
                    ) {
                        // List
                        ForEach(viewModel.filteredItems, id: \.title) { item in
                            HStack(spacing: 12) {
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .fontWeight(.bold)
                                    Text(item.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemTeal).opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }

            // Floating Action Button
            Button(action: {
                showStats = true
            }) {
                Image(systemName: "ellipsis.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                    .padding()
            }
        }
        .sheet(isPresented: $showStats) {
            StatsView(stats: viewModel.viewModel.currentStats())
        }
        .onAppear {
            viewModel.viewModel.loadData()
        }
    }
}

struct StatsView: View {
    let stats: (count: Int, topChars: [(char: Character, count: Int)])

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Item Count: \(stats.count)")
                    .font(.headline)

                Text("Top 3 Characters:")
                    .font(.headline)

                ForEach(stats.topChars, id: \.char) { item in
                    Text("\(String(item.char)) = \(item.count)")
                        .font(.body)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
