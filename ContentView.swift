//
//  ContentView.swift
//  Tiny Adventures Shop
//
//  Created by Sofia on 4/13/26.
//

import SwiftUI
import Combine

// MARK: - Theme

extension Color {
    static let taCream = Color(red: 0.98, green: 0.98, blue: 0.96)
    static let taCard = Color.white
    static let taSoftGreen = Color(red: 0.89, green: 0.95, blue: 0.89)
    static let taSoftBlue = Color(red: 0.89, green: 0.94, blue: 0.98)
    static let taSoftPink = Color(red: 0.98, green: 0.90, blue: 0.92)
    static let taNeutral = Color(red: 0.95, green: 0.94, blue: 0.92)
    static let taLeaf = Color(red: 0.38, green: 0.56, blue: 0.41)
    static let taText = Color(red: 0.18, green: 0.22, blue: 0.18)
    static let taBrown = Color(red: 0.35, green: 0.27, blue: 0.18)
    static let taError = Color.red
    static let taBorder = Color.black.opacity(0.08)
}

// MARK: - Models

enum ProductCategory: String, CaseIterable, Identifiable, Hashable {
    case all = "All"
    case clothing = "Clothing"
    case nursery = "Nursery"
    case toddlerKids = "Toddler & Kids"
    case toys = "Toys"
    case accessories = "Accessories"
    case essentials = "Essentials"

    var id: String { rawValue }
}

enum ExploreCategory: String, CaseIterable, Identifiable, Hashable {
    case girls = "Girls"
    case boys = "Boys"
    case unisex = "Unisex"
    case mommyAndMe = "Mommy & Me"
    case nursery = "Nursery"
    case toddlerKids = "Toddler & Kids"
    case toys = "Toys"

    var id: String { rawValue }
}

enum ShopStyle: String, CaseIterable, Identifiable, Hashable {
    case footies = "Footies"
    case rompers = "Rompers"
    case bodysuits = "Bodysuits"
    case accessories = "Accessories"
    case dresses = "Dresses"
    case matchingSets = "Matching Sets"
    case pajamas = "Pajamas"

    var id: String { rawValue }
}

enum FeaturedCollection: String, CaseIterable, Identifiable, Hashable {
    case organicMuslin = "Organic Muslin"
    case vintageSoccer = "Vintage Soccer"
    case flora = "Flora"
    case babyAnimals = "Baby Animals"
    case honeyBunny = "Honey Bunny"
    case essentials = "Essentials"

    var id: String { rawValue }
}

enum CollectionsSection: String, CaseIterable, Identifiable, Hashable {
    case newCollections = "New Collections"
    case baby = "Baby"
    case toddlerKids = "Toddler & Kids"
    case momDad = "Mom & Dad"

    var id: String { rawValue }
}

enum SortOption: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case relevance = "Relevance"
    case justLaunched = "Just Launched"
    case bestSelling = "Best Selling"
    case priceHighToLow = "Price High to Low"
    case priceLowToHigh = "Price Low to High"
    case alphabeticalAZ = "Alphabetically A-Z"
    case alphabeticalZA = "Alphabetically Z-A"

    var id: String { rawValue }
}

enum PolicyPage: String, CaseIterable, Identifiable {
    case privacyPolicy = "Privacy Policy"
    case termsOfService = "Terms of Service"
    case shippingPolicy = "Shipping Policy"
    case refundPolicy = "Refund Policy"
    case sizing = "Sizing"
    case faq = "Frequently Asked Questions"

    var id: String { rawValue }
}

struct ProductFilters {
    var genders: Set<String> = []
    var categories: Set<String> = []
    var styles: Set<String> = []
    var ageRanges: Set<String> = []
    var sizes: Set<String> = []
    var availability: Set<String> = []
    var colors: Set<String> = []
    var collections: Set<String> = []
    var minPrice: Double = 0
    var maxPrice: Double = 120

    static let `default` = ProductFilters()
}

struct Review: Identifiable, Hashable {
    let id = UUID()
    let author: String
    let rating: Int
    let title: String
    let comment: String
    let date: String
}

struct AddressBookEntry: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let address: String
}

struct RewardInfo: Hashable {
    var points: Int
    var tier: String
}

struct UserAccount: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let countryCode: String
    let phoneNumber: String
    let email: String
    let password: String
    var addressBook: [AddressBookEntry]
    var orderHistory: [String]
    var rewards: RewardInfo
}

struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: ProductCategory
    let exploreCategory: ExploreCategory
    let style: ShopStyle?
    let featuredCollection: FeaturedCollection?
    let collectionsSection: CollectionsSection
    let price: Double
    let imageName: String
    let subtitle: String
    let description: String
    let isOrganic: Bool
    let isNonToxic: Bool
    let isTrending: Bool
    let isJustLaunched: Bool
    let isBestSelling: Bool
    let genderLabel: String
    let filterCategoryLabel: String
    let filterStyleLabel: String
    let ageRangeLabel: String
    let availabilityLabel: String
    let colorLabels: [String]
    let collectionLabel: String
    let availableColors: [String]
    let availableSizes: [String]
    let reviews: [Review]
    let colorImageMap: [String: [String]]
}

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let product: Product
    var quantity: Int
    var selectedColor: String
    var selectedSize: String
}

// MARK: - View Model

final class ShopViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var wishlist: Set<UUID> = []
    @Published var searchText: String = ""
    @Published var accounts: [UserAccount] = []
    @Published var signedInUser: UserAccount? = nil

    func addToCart(_ product: Product, color: String, size: String, quantity: Int) {
        if let index = cartItems.firstIndex(where: {
            $0.product.id == product.id &&
            $0.selectedColor == color &&
            $0.selectedSize == size
        }) {
            cartItems[index].quantity += quantity
        } else {
            cartItems.append(
                CartItem(
                    product: product,
                    quantity: quantity,
                    selectedColor: color,
                    selectedSize: size
                )
            )
        }
    }

    func increaseQuantity(for item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        cartItems[index].quantity += 1
    }

    func decreaseQuantity(for item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        if cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
        } else {
            cartItems.remove(at: index)
        }
    }

    func removeItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }

    func toggleWishlist(for product: Product) {
        if wishlist.contains(product.id) {
            wishlist.remove(product.id)
        } else {
            wishlist.insert(product.id)
        }
    }

    func isWishlisted(_ product: Product) -> Bool {
        wishlist.contains(product.id)
    }

    var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var shipping: Double {
        cartItems.isEmpty ? 0 : 8.99
    }

    var total: Double {
        subtotal + shipping
    }

    var totalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    func createAccount(
        name: String,
        countryCode: String,
        phoneNumber: String,
        email: String,
        password: String
    ) -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !countryCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else { return false }

        guard !accounts.contains(where: { $0.email.lowercased() == email.lowercased() }) else { return false }

        let newAccount = UserAccount(
            name: name,
            countryCode: countryCode,
            phoneNumber: phoneNumber,
            email: email,
            password: password,
            addressBook: [
                AddressBookEntry(label: "Home", address: "No saved address yet.")
            ],
            orderHistory: [],
            rewards: RewardInfo(points: 100, tier: "Starter")
        )

        accounts.append(newAccount)
        signedInUser = newAccount
        return true
    }

    func signIn(email: String, password: String) -> Bool {
        guard let account = accounts.first(where: {
            $0.email.lowercased() == email.lowercased() && $0.password == password
        }) else {
            return false
        }
        signedInUser = account
        return true
    }

    func signOut() {
        signedInUser = nil
    }

    func changePassword(newPassword: String) -> Bool {
        guard let current = signedInUser, !newPassword.isEmpty else { return false }
        guard let idx = accounts.firstIndex(where: { $0.id == current.id }) else { return false }

        let existing = accounts[idx]
        accounts[idx] = UserAccount(
            name: existing.name,
            countryCode: existing.countryCode,
            phoneNumber: existing.phoneNumber,
            email: existing.email,
            password: newPassword,
            addressBook: existing.addressBook,
            orderHistory: existing.orderHistory,
            rewards: existing.rewards
        )
        signedInUser = accounts[idx]
        return true
    }
}

// MARK: - App Entry

struct ContentView: View {
    @StateObject private var vm = ShopViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .environmentObject(vm)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                CollectionsView()
                    .environmentObject(vm)
            }
            .tabItem {
                Label("Collections", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                TrendingView()
                    .environmentObject(vm)
            }
            .tabItem {
                Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationStack {
                AccountView()
                    .environmentObject(vm)
            }
            .tabItem {
                Label("Account", systemImage: "person")
            }
        }
        .tint(Color.taLeaf)
    }
}

// MARK: - Sticky Top Bar Shell

struct StickyTopContainer<Content: View>: View {
    @EnvironmentObject var vm: ShopViewModel
    let title: String
    let showsBackButton: Bool
    let content: Content

    init(title: String, showsBackButton: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.showsBackButton = showsBackButton
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.taCream.ignoresSafeArea()
            content
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            AppTopBar(title: title, showsBackButton: showsBackButton)
                .environmentObject(vm)
                .background(Color.taCream)
                .overlay(
                    Rectangle()
                        .fill(Color.taBorder)
                        .frame(height: 0.5),
                    alignment: .bottom
                )
        }
    }
}

struct AppTopBar: View {
    @EnvironmentObject var vm: ShopViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showSearch = false
    @State private var showWishlist = false
    @State private var showCart = false

    let title: String
    let showsBackButton: Bool

    var body: some View {
        HStack(spacing: 14) {
            if showsBackButton {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.taText)
                        .frame(width: 36, height: 36)
                        .background(Color.taCard)
                        .clipShape(Circle())
                }
            }

            Text(title)
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(Color.taText)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                Button {
                    showSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundStyle(Color.taText)
                }

                Button {
                    showWishlist = true
                } label: {
                    Image(systemName: "heart")
                        .font(.title3)
                        .foregroundStyle(Color.taText)
                }

                ZStack(alignment: .topTrailing) {
                    Button {
                        showCart = true
                    } label: {
                        Image(systemName: "cart")
                            .font(.title3)
                            .foregroundStyle(Color.taText)
                    }

                    if vm.totalItems > 0 {
                        Text("\(vm.totalItems)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(5)
                            .background(Color.taLeaf)
                            .clipShape(Circle())
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .sheet(isPresented: $showSearch) {
            SearchSheetView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showWishlist) {
            WishlistView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showCart) {
            NavigationStack {
                CartView()
                    .environmentObject(vm)
            }
        }
    }
}

// MARK: - Home

struct HomeView: View {
    private let exploreCards: [(ExploreCategory, String, Color)] = [
        (.girls, "girls_collection", .taSoftPink),
        (.boys, "boys_collection", .taSoftBlue),
        (.unisex, "unisex_collection", .taNeutral),
        (.mommyAndMe, "mommy_me_collection", .taSoftPink),
        (.nursery, "nursery_collection", .taSoftGreen),
        (.toddlerKids, "toddler_kids_collection", .taNeutral)
    ]

    private let styleCards: [(ShopStyle, String, Color)] = [
        (.footies, "style_footies", .taSoftGreen),
        (.rompers, "style_rompers", .taSoftBlue),
        (.bodysuits, "style_bodysuits", .taNeutral),
        (.accessories, "style_accessories", .taSoftPink),
        (.dresses, "style_dresses", .taSoftPink),
        (.matchingSets, "style_matching_sets", .taSoftGreen),
        (.pajamas, "style_pajamas", .taSoftBlue)
    ]

    var body: some View {
        StickyTopContainer(title: "Tiny Adventures") {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    HomeHeroCard()
                        .padding(.top, 10)

                    SectionHeader(title: "Explore Tiny Adventures")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 18) {
                            ForEach(exploreCards, id: \.0) { item in
                                NavigationLink {
                                    ExploreCategoryProductsView(category: item.0)
                                } label: {
                                    CategoryCard(title: item.0.rawValue, imageName: item.1, background: item.2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    SectionHeader(title: "Shop by Style")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 18) {
                            ForEach(styleCards, id: \.0) { item in
                                NavigationLink {
                                    StyleProductsView(style: item.0)
                                } label: {
                                    CategoryCard(title: item.0.rawValue, imageName: item.1, background: item.2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    BetterForBabySection()
                }
                .padding(.bottom, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct HomeHeroCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    LinearGradient(
                        colors: [.taSoftGreen, .taSoftBlue, .taSoftPink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 280)

            VStack(alignment: .leading, spacing: 10) {
                Text("Organic, non-toxic essentials for every little adventure")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(Color.taText)

                Text("Soft clothing, dreamy nursery pieces, toys, toddler favorites, and matching family moments.")
                    .font(.subheadline)
                    .foregroundStyle(Color.taText.opacity(0.85))
            }
            .padding(24)
        }
        .padding(.horizontal)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .bold, design: .serif))
            .foregroundStyle(Color.taText)
            .padding(.horizontal)
    }
}

struct CategoryCard: View {
    let title: String
    let imageName: String
    let background: Color

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(background)
                    .frame(width: 250, height: 240)

                ProductImageView(imageName: imageName)
                    .frame(width: 210, height: 190)
            }

            Text(title)
                .font(.title3)
                .foregroundStyle(Color.taText)
        }
    }
}

struct BetterForBabySection: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("Better for Baby & Planet")
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(Color.taText)

            Text("Organic cotton is one of the safest and most environmentally-friendly choices for your baby because it is grown without pesticides or insecticides, and is manufactured in a pure and non-toxic way, unlike semi-synthetic fabrics such as bamboo made with the viscose rayon.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Text("We focus on soft, safe, and thoughtfully-made essentials so your little one gets comfort, quality, and a better future.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                BenefitItem(icon: "leaf", title: "Super Soft & Hypoallergenic", subtitle: "for sensitive skin", bg: .taSoftGreen)
                BenefitItem(icon: "sparkles", title: "Toxin-Free Processing", subtitle: "gentle and clean", bg: .taSoftBlue)
                BenefitItem(icon: "drop", title: "Lower Impact", subtitle: "thoughtful materials", bg: .taSoftPink)
                BenefitItem(icon: "heart", title: "Made with Care", subtitle: "for growing families", bg: .taNeutral)
            }
        }
        .padding(24)
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(.horizontal)
    }
}

struct BenefitItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let bg: Color

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(bg)
                    .frame(width: 78, height: 78)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.taBrown)
            }

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.taText)

            Text(subtitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Product Pages

struct ExploreCategoryProductsView: View {
    let category: ExploreCategory

    var products: [Product] {
        Product.sampleProducts.filter { $0.exploreCategory == category }
    }

    var body: some View {
        ProductGridPage(title: category.rawValue, products: products)
    }
}

struct StyleProductsView: View {
    let style: ShopStyle

    var products: [Product] {
        Product.sampleProducts.filter { $0.style == style }
    }

    var body: some View {
        ProductGridPage(title: style.rawValue, products: products)
    }
}

struct FeaturedCollectionProductsView: View {
    let collection: FeaturedCollection

    var products: [Product] {
        Product.sampleProducts.filter { $0.featuredCollection == collection }
    }

    var body: some View {
        ProductGridPage(title: collection.rawValue, products: products)
    }
}

struct CollectionsSectionProductsView: View {
    let section: CollectionsSection

    var products: [Product] {
        Product.sampleProducts.filter { $0.collectionsSection == section }
    }

    var body: some View {
        ProductGridPage(title: section.rawValue, products: products)
    }
}

struct ProductGridPage: View {
    @EnvironmentObject var vm: ShopViewModel
    let title: String
    let products: [Product]

    @State private var selectedSort: SortOption = .default
    @State private var appliedFilters: ProductFilters = .default
    @State private var tempFilters: ProductFilters = .default
    @State private var showSortSheet = false
    @State private var showFilterSheet = false

    var processedProducts: [Product] {
        var result = products

        result = result.filter { product in
            let genderMatch = appliedFilters.genders.isEmpty || appliedFilters.genders.contains(product.genderLabel)
            let categoryMatch = appliedFilters.categories.isEmpty || appliedFilters.categories.contains(product.filterCategoryLabel)
            let styleMatch = appliedFilters.styles.isEmpty || appliedFilters.styles.contains(product.filterStyleLabel)
            let ageMatch = appliedFilters.ageRanges.isEmpty || appliedFilters.ageRanges.contains(product.ageRangeLabel)
            let sizeMatch = appliedFilters.sizes.isEmpty || !appliedFilters.sizes.isDisjoint(with: Set(product.availableSizes))
            let availabilityMatch = appliedFilters.availability.isEmpty || appliedFilters.availability.contains(product.availabilityLabel)
            let colorMatch = appliedFilters.colors.isEmpty || !appliedFilters.colors.isDisjoint(with: Set(product.colorLabels))
            let collectionMatch = appliedFilters.collections.isEmpty || appliedFilters.collections.contains(product.collectionLabel)
            let priceMatch = product.price >= appliedFilters.minPrice && product.price <= appliedFilters.maxPrice

            return genderMatch && categoryMatch && styleMatch && ageMatch && sizeMatch && availabilityMatch && colorMatch && collectionMatch && priceMatch
        }

        switch selectedSort {
        case .default:
            return result
        case .relevance:
            return result.sorted {
                if $0.isTrending != $1.isTrending { return $0.isTrending && !$1.isTrending }
                return $0.name < $1.name
            }
        case .justLaunched:
            return result.sorted {
                if $0.isJustLaunched != $1.isJustLaunched { return $0.isJustLaunched && !$1.isJustLaunched }
                return $0.name < $1.name
            }
        case .bestSelling:
            return result.sorted {
                if $0.isBestSelling != $1.isBestSelling { return $0.isBestSelling && !$1.isBestSelling }
                return $0.name < $1.name
            }
        case .priceHighToLow:
            return result.sorted { $0.price > $1.price }
        case .priceLowToHigh:
            return result.sorted { $0.price < $1.price }
        case .alphabeticalAZ:
            return result.sorted { $0.name < $1.name }
        case .alphabeticalZA:
            return result.sorted { $0.name > $1.name }
        }
    }

    var body: some View {
        StickyTopContainer(title: "Tiny Adventures", showsBackButton: true) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(title)
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(Color.taText)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    if processedProducts.isEmpty {
                        EmptyStateCard(message: "No items match your current filters.")
                            .padding(.horizontal)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                            ForEach(processedProducts) { product in
                                NavigationLink {
                                    ProductDetailView(product: product)
                                } label: {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 90)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            HStack(spacing: 12) {
                Button {
                    showSortSheet = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort By")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.taCard)
                    .foregroundStyle(Color.taText)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                Button {
                    tempFilters = appliedFilters
                    showFilterSheet = true
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter By")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.taLeaf)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $showSortSheet) {
            SortSheetView(selectedSort: $selectedSort)
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(
                tempFilters: $tempFilters,
                onCancel: { showFilterSheet = false },
                onApply: {
                    appliedFilters = tempFilters
                    showFilterSheet = false
                }
            )
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct SortSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSort: SortOption

    var body: some View {
        NavigationStack {
            List {
                ForEach(SortOption.allCases) { option in
                    Button {
                        selectedSort = option
                        dismiss()
                    } label: {
                        HStack {
                            Text(option.rawValue)
                                .foregroundStyle(Color.taText)
                            Spacer()
                            if selectedSort == option {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.taLeaf)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sort By")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FilterSheetView: View {
    @Binding var tempFilters: ProductFilters
    let onCancel: () -> Void
    let onApply: () -> Void

    let genderOptions = ["Boys", "Girls", "Men", "Unisex", "Women"]
    let categoryOptions = ["Accessories", "Books", "Bottoms", "Bundles", "Dresses", "Footies", "Lovies", "Nursery", "One-Pieces", "PJs", "Sets", "Tops & Bodysuits", "Toys"]
    let styleOptions = ["Accessories", "Baby Booties", "Bibs", "Blankets", "Bodysuits", "Books", "Bundles", "Cardigans", "Coveralls", "Crib Sheets", "Dresses", "Footies", "Gowns", "Hats", "Headbands", "Holiday Pet Sweaters", "Hoodies", "Leggings", "Lovies", "Nursing Covers", "Overalls", "Pants", "Pet Bandanas", "PJs", "Rompers", "Sets", "Shirts", "Shorts", "Soft Toys", "Sweatshirts", "Tees", "Tote Bags", "Underwear"]
    let ageOptions = ["Infant", "Toddler/Kid", "Adult", "Pet"]
    let sizeOptions = ["One Size", "Preemie-NB", "0-3m", "3-6m", "6-9m", "9-12m", "12-18m", "18-24m", "2T", "3T", "4T", "5", "6", "7", "8", "9", "10", "Pet"]
    let availabilityOptions = ["In-Stock", "Out of stock"]
    let colorOptions = ["Beige", "Black", "Blue", "Brown", "Gray", "Multi", "Orange", "Pink", "Purple", "Red", "White", "Yellow"]
    let collectionOptions = ["Baby Animals", "Clearance", "Cotton Basics", "Cozy Fleece", "Desert Friends", "Flora", "Floral Muslin", "French Terry", "Good Jeans Collection", "Harvest", "Holiday", "Honey Bunny", "I Love Mom", "Brown Bear", "Little Travelers", "Organic Essentials", "Soccer Club", "Under the Sea", "Thermal", "The Neutral Collection", "The Vintage Collection"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        FilterSection(title: "Gender", options: genderOptions, selection: $tempFilters.genders)
                        FilterSection(title: "Category", options: categoryOptions, selection: $tempFilters.categories)
                        FilterSection(title: "Style", options: styleOptions, selection: $tempFilters.styles)
                        FilterSection(title: "Age Range", options: ageOptions, selection: $tempFilters.ageRanges)
                        FilterSection(title: "Size", options: sizeOptions, selection: $tempFilters.sizes)
                        FilterSection(title: "Availability", options: availabilityOptions, selection: $tempFilters.availability)
                        FilterSection(title: "Color", options: colorOptions, selection: $tempFilters.colors)
                        FilterSection(title: "Collection", options: collectionOptions, selection: $tempFilters.collections)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Price")
                                .font(.headline)
                                .foregroundStyle(Color.taText)

                            Text("Selected Range $\(Int(tempFilters.minPrice)) - $\(Int(tempFilters.maxPrice))")
                                .foregroundStyle(.secondary)

                            HStack {
                                Text("Min")
                                    .frame(width: 32, alignment: .leading)
                                Slider(value: $tempFilters.minPrice, in: 0...120, step: 1)
                            }

                            HStack {
                                Text("Max")
                                    .frame(width: 32, alignment: .leading)
                                Slider(value: $tempFilters.maxPrice, in: 0...120, step: 1)
                            }
                        }
                    }
                    .padding()
                }

                HStack(spacing: 12) {
                    Button {
                        onCancel()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.taCard)
                            .foregroundStyle(Color.taText)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.taText.opacity(0.35), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }

                    Button {
                        onApply()
                    } label: {
                        Text("Apply")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.taLeaf)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .background(Color.taCream.ignoresSafeArea())
            .navigationTitle("Filter By")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FilterSection: View {
    let title: String
    let options: [String]
    @Binding var selection: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.taText)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button {
                        if selection.contains(option) {
                            selection.remove(option)
                        } else {
                            selection.insert(option)
                        }
                    } label: {
                        Text(option)
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background(selection.contains(option) ? Color.taLeaf : Color.taCard)
                            .foregroundStyle(selection.contains(option) ? .white : Color.taText)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
        }
    }
}

struct EmptyStateCard: View {
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "shippingbox")
                .font(.largeTitle)
                .foregroundStyle(Color.taLeaf)

            Text(message)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Collections & Trending

struct CollectionsView: View {
    private let collectionCards: [(CollectionsSection, String, Color)] = [
        (.newCollections, "new_collections", .taSoftGreen),
        (.baby, "baby_collection", .taSoftBlue),
        (.toddlerKids, "toddler_kids_collection", .taNeutral),
        (.momDad, "mom_dad_collection", .taSoftPink)
    ]

    var body: some View {
        StickyTopContainer(title: "Tiny Adventures") {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(collectionCards, id: \.0) { item in
                        NavigationLink {
                            CollectionsSectionProductsView(section: item.0)
                        } label: {
                            CollectionBannerCard(title: item.0.rawValue, imageName: item.1, background: item.2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
    }
}

struct CollectionBannerCard: View {
    let title: String
    let imageName: String
    let background: Color

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 28)
                .fill(background)
                .frame(height: 170)

            HStack {
                Text(title)
                    .font(.system(size: 28, weight: .medium, design: .serif))
                    .foregroundStyle(Color.taText)
                    .padding(.leading, 24)

                Spacer()

                ProductImageView(imageName: imageName)
                    .frame(width: 180, height: 140)
                    .padding(.trailing, 18)
            }
        }
        .padding(.horizontal)
    }
}

struct TrendingView: View {
    @State private var selectedFilter: ProductCategory = .all

    private let trendingFilters: [ProductCategory] = [.all, .clothing, .accessories, .essentials, .toys, .nursery, .toddlerKids]

    var filteredProducts: [Product] {
        let trending = Product.sampleProducts.filter { $0.isTrending }
        if selectedFilter == .all { return trending }
        return trending.filter { $0.category == selectedFilter }
    }

    var body: some View {
        StickyTopContainer(title: "Tiny Adventures", showsBackButton: true) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Trending")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(Color.taText)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(trendingFilters) { filter in
                                Button {
                                    selectedFilter = filter
                                } label: {
                                    Text(filter.rawValue)
                                        .font(.subheadline.weight(.semibold))
                                        .frame(width: 118)
                                        .padding(.vertical, 10)
                                        .background(selectedFilter == filter ? Color.taLeaf : Color.taCard)
                                        .foregroundStyle(selectedFilter == filter ? .white : Color.taText)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                        ForEach(filteredProducts) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                ProductCardView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

// MARK: - Account

struct AccountView: View {
    @EnvironmentObject var vm: ShopViewModel
    @State private var showCreate = false
    @State private var showSignIn = false

    var body: some View {
        StickyTopContainer(title: "Tiny Adventures") {
            ScrollView {
                VStack(spacing: 24) {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 34)
                            .fill(
                                LinearGradient(
                                    colors: [.taSoftPink, .taSoftBlue, .taSoftGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 320)

                        ProductImageView(imageName: "account_hero")
                            .frame(height: 250)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    if let user = vm.signedInUser {
                        SignedInProfileCard(user: user)
                            .padding(.horizontal)

                        DetailsSectionCard()
                            .padding(.horizontal)

                        MoreSectionCard()
                            .padding(.horizontal)

                        Button {
                            vm.signOut()
                        } label: {
                            Text("LOG OUT")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.taBrown)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 18) {
                            Text("Welcome")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundStyle(Color.taText)

                            Button {
                                showCreate = true
                            } label: {
                                Text("Create Account")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.taCard)
                                    .foregroundStyle(Color.taText)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color.taText, lineWidth: 1.2)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }

                            Button {
                                showSignIn = true
                            } label: {
                                Text("Sign In")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.taBrown)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                        .padding(24)
                        .background(Color.taCard)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showCreate) {
            CreateAccountView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showSignIn) {
            SignInView()
                .environmentObject(vm)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct SignedInProfileCard: View {
    let user: UserAccount

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(user.name)
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(Color.taText)

            Text(user.email)
                .foregroundStyle(.secondary)

            Text("\(user.countryCode) \(user.phoneNumber)")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

struct DetailsSectionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your details")
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundStyle(Color.taText)

            NavigationLink("Address Book") {
                SimpleInfoPage(title: "Address Book", content: "Save, view, and manage your delivery addresses here.")
            }

            NavigationLink("Order History") {
                SimpleInfoPage(title: "Order History", content: "Track previous orders, order numbers, and purchase history here.")
            }

            NavigationLink("Change Password") {
                ChangePasswordView()
            }

            NavigationLink("Rewards") {
                SimpleInfoPage(title: "Rewards", content: "Earn points, unlock benefits, and view your loyalty details here.")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct MoreSectionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("More")
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundStyle(Color.taText)

            NavigationLink("Privacy Policy") { PolicyDetailView(page: .privacyPolicy) }
            NavigationLink("Terms of Service") { PolicyDetailView(page: .termsOfService) }
            NavigationLink("Shipping Policy") { PolicyDetailView(page: .shippingPolicy) }
            NavigationLink("Refund Policy") { PolicyDetailView(page: .refundPolicy) }
            NavigationLink("Sizing") { PolicyDetailView(page: .sizing) }
            NavigationLink("Frequently Asked Questions") { PolicyDetailView(page: .faq) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Form Views

struct CreateAccountView: View {
    @EnvironmentObject var vm: ShopViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var countryCode = "+1"
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var attemptSubmit = false
    @State private var message = ""

    var fullNameError: Bool { attemptSubmit && fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var phoneError: Bool { attemptSubmit && phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var emailError: Bool { attemptSubmit && email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var passwordError: Bool { attemptSubmit && password.isEmpty }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.taCream.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        FieldLabel(text: "Full name*", isError: fullNameError)
                        LabeledInputField(
                            placeholder: "Enter your full name",
                            text: $fullName,
                            keyboardType: .default,
                            isError: fullNameError
                        )
                        if fullNameError { RequiredErrorText() }

                        FieldLabel(text: "Phone number*", isError: phoneError)
                        HStack(spacing: 12) {
                            Menu {
                                Button("+1") { countryCode = "+1" }
                                Button("+44") { countryCode = "+44" }
                                Button("+58") { countryCode = "+58" }
                                Button("+52") { countryCode = "+52" }
                            } label: {
                                HStack {
                                    Text(countryCode)
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                                .padding()
                                .frame(minWidth: 86)
                                .background(Color.taCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(phoneError ? Color.taError : Color.taBorder, lineWidth: phoneError ? 1.5 : 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }

                            LabeledInputField(
                                placeholder: "Enter your phone number",
                                text: $phoneNumber,
                                keyboardType: .phonePad,
                                isError: phoneError
                            )
                        }
                        if phoneError { RequiredErrorText() }

                        FieldLabel(text: "Email address*", isError: emailError)
                        LabeledInputField(
                            placeholder: "Enter your email address",
                            text: $email,
                            keyboardType: .emailAddress,
                            isError: emailError
                        )
                        if emailError { RequiredErrorText() }

                        FieldLabel(text: "Password*", isError: passwordError)
                        PasswordEntryField(
                            placeholder: "Enter your password",
                            text: $password,
                            showPassword: $showPassword,
                            isError: passwordError
                        )
                        if passwordError { RequiredErrorText() }

                        Button {
                            attemptSubmit = true
                            message = ""

                            guard !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                  !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                  !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                  !password.isEmpty else {
                                message = "Please complete all required steps."
                                return
                            }

                            if vm.createAccount(
                                name: fullName,
                                countryCode: countryCode,
                                phoneNumber: phoneNumber,
                                email: email,
                                password: password
                            ) {
                                dismiss()
                            } else {
                                message = "Unable to create account. This email may already exist."
                            }
                        } label: {
                            Text("Create Account")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.taLeaf)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }

                        if !message.isEmpty {
                            Text(message)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Create Account")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var vm: ShopViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var attemptSubmit = false
    @State private var message = ""
    @State private var showCreate = false

    var emailError: Bool { attemptSubmit && email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var passwordError: Bool { attemptSubmit && password.isEmpty }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.taCream.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        FieldLabel(text: "Email address*", isError: emailError)
                        LabeledInputField(
                            placeholder: "Enter your email address",
                            text: $email,
                            keyboardType: .emailAddress,
                            isError: emailError
                        )
                        if emailError { RequiredErrorText() }

                        FieldLabel(text: "Password*", isError: passwordError)
                        PasswordEntryField(
                            placeholder: "Enter your password",
                            text: $password,
                            showPassword: $showPassword,
                            isError: passwordError
                        )
                        if passwordError { RequiredErrorText() }

                        Button {
                        } label: {
                            Text("FORGOT PASSWORD?")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.taLeaf)
                        }

                        Button {
                            attemptSubmit = true
                            message = ""

                            guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                  !password.isEmpty else {
                                message = "Please complete all required steps."
                                return
                            }

                            if vm.signIn(email: email, password: password) {
                                dismiss()
                            } else {
                                message = "Email or password is incorrect."
                            }
                        } label: {
                            Text("Sign In")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.taBrown)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }

                        Button {
                            showCreate = true
                        } label: {
                            Text("Create Account")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.taCard)
                                .foregroundStyle(Color.taText)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.taText, lineWidth: 1.2)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }

                        if !message.isEmpty {
                            Text(message)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Sign In")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showCreate) {
                CreateAccountView()
                    .environmentObject(vm)
            }
        }
    }
}

struct ChangePasswordView: View {
    @EnvironmentObject var vm: ShopViewModel
    @State private var newPassword = ""
    @State private var showPassword = false
    @State private var message = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Change Password")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(Color.taText)

                FieldLabel(text: "Password*", isError: newPassword.isEmpty && !message.isEmpty)

                PasswordEntryField(
                    placeholder: "Enter your new password",
                    text: $newPassword,
                    showPassword: $showPassword,
                    isError: newPassword.isEmpty && !message.isEmpty
                )

                Button {
                    if vm.changePassword(newPassword: newPassword) {
                        message = "Password updated successfully."
                        newPassword = ""
                    } else {
                        message = "This step is required."
                    }
                } label: {
                    Text("Update Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.taLeaf)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                if !message.isEmpty {
                    Text(message)
                        .foregroundStyle(message.contains("successfully") ? Color.taLeaf : .red)
                }
            }
            .padding()
        }
        .background(Color.taCream.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Form Helpers

struct FieldLabel: View {
    let text: String
    let isError: Bool

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isError ? Color.taError : Color.taText)
    }
}

struct RequiredErrorText: View {
    var body: some View {
        Text("This step is required.")
            .font(.caption)
            .foregroundStyle(Color.taError)
    }
}

struct LabeledInputField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isError: Bool

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding()
            .background(Color.taCard)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isError ? Color.taError : Color.taBorder, lineWidth: isError ? 1.5 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PasswordEntryField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool
    let isError: Bool

    var body: some View {
        HStack {
            Group {
                if showPassword {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.taCard)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isError ? Color.taError : Color.taBorder, lineWidth: isError ? 1.5 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Policy / Search / Wishlist / Cart Helpers

struct PolicyDetailView: View {
    let page: PolicyPage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(page.rawValue)
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(Color.taText)

                Text(policyText(for: page))
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color.taCream.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    func policyText(for page: PolicyPage) -> String {
        switch page {
        case .privacyPolicy:
            return "We value your privacy. Tiny Adventures collects only the information needed to create an account, process orders, save your wishlist, and improve your shopping experience. We do not sell personal information."
        case .termsOfService:
            return "By using Tiny Adventures, you agree to use the app lawfully and respectfully. Product details, pricing, and availability may change. We may update app features and store content over time."
        case .shippingPolicy:
            return "Orders are usually processed within 1–3 business days. Shipping times vary by destination. Tracking should be provided when an order ships."
        case .refundPolicy:
            return "Unused items in original condition may be eligible for return within the store’s return window. Personalized and final-sale items are typically non-refundable."
        case .sizing:
            return "Baby sizing generally ranges from Preemie/NB through 18-24m. Toddler and kids sizing can range from 2T through size 10 depending on the style. Check product size details before ordering."
        case .faq:
            return """
            Q: Are products organic?
            A: Many items are made with organic cotton and non-toxic materials.

            Q: Can I save favorites?
            A: Yes, tap the heart on any product.

            Q: Can I shop by style or collection?
            A: Yes, use Home and Collections.

            Q: Can I create an account?
            A: Yes, from the Account tab.

            Q: Does the app support matching family looks?
            A: Yes, Mommy & Me and Mom & Dad options are included.
            """
        }
    }
}

struct SimpleInfoPage: View {
    let title: String
    let content: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(Color.taText)

                Text(content)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color.taCream.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchSheetView: View {
    @EnvironmentObject var vm: ShopViewModel
    @Environment(\.dismiss) private var dismiss

    var results: [Product] {
        let query = vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty { return Product.sampleProducts }

        return Product.sampleProducts.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.subtitle.localizedCaseInsensitiveContains(query) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(query) ||
            $0.exploreCategory.rawValue.localizedCaseInsensitiveContains(query) ||
            $0.collectionsSection.rawValue.localizedCaseInsensitiveContains(query) ||
            ($0.style?.rawValue.localizedCaseInsensitiveContains(query) ?? false) ||
            ($0.featuredCollection?.rawValue.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.taCream.ignoresSafeArea()

                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.taLeaf)

                        TextField("Search products...", text: $vm.searchText)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                        if !vm.searchText.isEmpty {
                            Button {
                                vm.searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.taCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.taBorder, lineWidth: 1)
                    )
                    .padding(.horizontal)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                            ForEach(results) { product in
                                NavigationLink {
                                    ProductDetailView(product: product)
                                } label: {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct WishlistView: View {
    @EnvironmentObject var vm: ShopViewModel
    @Environment(\.dismiss) private var dismiss

    var wishlistProducts: [Product] {
        Product.sampleProducts.filter { vm.wishlist.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.taCream.ignoresSafeArea()

                if wishlistProducts.isEmpty {
                    ContentUnavailableView(
                        "No saved items yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on any item to save it to your wishlist.")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                            ForEach(wishlistProducts) { product in
                                NavigationLink {
                                    ProductDetailView(product: product)
                                } label: {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Wishlist")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct CartView: View {
    @EnvironmentObject var vm: ShopViewModel

    var body: some View {
        ZStack {
            Color.taCream.ignoresSafeArea()

            if vm.cartItems.isEmpty {
                ContentUnavailableView(
                    "Your cart is empty",
                    systemImage: "cart",
                    description: Text("Add products to your cart to see them here.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(vm.cartItems) { item in
                            CartItemRow(item: item)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Order Summary")
                                .font(.headline)

                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text(vm.subtotal, format: .currency(code: "USD"))
                            }

                            HStack {
                                Text("Shipping")
                                Spacer()
                                Text(vm.shipping, format: .currency(code: "USD"))
                            }

                            Divider()

                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                Text(vm.total, format: .currency(code: "USD"))
                                    .font(.headline)
                                    .foregroundStyle(Color.taLeaf)
                            }

                            Button {
                            } label: {
                                Text("Proceed to Checkout")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.taLeaf)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                        .padding()
                        .background(Color.taCard)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Cart")
    }
}

struct CartItemRow: View {
    @EnvironmentObject var vm: ShopViewModel
    let item: CartItem

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.taNeutral)
                .frame(width: 90, height: 90)
                .overlay(
                    ProductImageView(imageName: item.product.imageName)
                        .padding(6)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.headline)
                    .foregroundStyle(Color.taText)

                Text("Color: \(item.selectedColor)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("Size: \(item.selectedSize)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(item.product.price, format: .currency(code: "USD"))
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.taLeaf)
            }

            Spacer()

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    Button {
                        vm.decreaseQuantity(for: item)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                    }

                    Text("\(item.quantity)")
                        .font(.headline)

                    Button {
                        vm.increaseQuantity(for: item)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
                .foregroundStyle(Color.taLeaf)

                Button("Remove") {
                    vm.removeItem(item)
                }
                .font(.caption)
                .foregroundStyle(.red)
            }
        }
        .padding()
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Product UI

struct ProductCardView: View {
    @EnvironmentObject var vm: ShopViewModel
    let product: Product

    var averageRating: Double {
        guard !product.reviews.isEmpty else { return 0 }
        return Double(product.reviews.map { $0.rating }.reduce(0, +)) / Double(product.reviews.count)
    }

    var cardTint: Color {
        switch product.exploreCategory {
        case .girls, .mommyAndMe:
            return .taSoftPink
        case .boys, .toys:
            return .taSoftBlue
        case .nursery:
            return .taSoftGreen
        case .toddlerKids, .unisex:
            return .taNeutral
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 22)
                    .fill(cardTint)
                    .frame(height: 180)

                ProductImageView(imageName: product.imageName, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 178)
                    .scaleEffect(1.12)
                    .padding(2)
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                Button {
                    vm.toggleWishlist(for: product)
                } label: {
                    Image(systemName: vm.isWishlisted(product) ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundStyle(vm.isWishlisted(product) ? .red : Color.taText)
                        .padding(12)
                        .background(Color.white.opacity(0.95))
                        .clipShape(Circle())
                        .padding(10)
                }
            }

            Text(product.name)
                .font(.headline)
                .foregroundStyle(Color.taText)
                .lineLimit(2)

            Text(product.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                Text(String(format: "%.1f", averageRating))
                Text("(\(product.reviews.count))")
            }
            .font(.caption)
            .foregroundStyle(Color.taLeaf)

            Text(product.price, format: .currency(code: "USD"))
                .font(.title3.bold())
                .foregroundStyle(Color.taText)
        }
        .padding(12)
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ProductDetailView: View {
    @EnvironmentObject var vm: ShopViewModel
    let product: Product

    @State private var quantity = 1
    @State private var selectedColor = ""
    @State private var selectedSize = ""
    @State private var selectedImageIndex = 0
    @State private var reviewName = ""
    @State private var reviewTitle = ""
    @State private var reviewComment = ""
    @State private var reviewRating = 5
    @State private var submittedReviews: [Review] = []

    var allReviews: [Review] {
        product.reviews + submittedReviews
    }

    var averageRating: Double {
        guard !allReviews.isEmpty else { return 0 }
        return Double(allReviews.map { $0.rating }.reduce(0, +)) / Double(allReviews.count)
    }

    var currentImages: [String] {
        if let images = product.colorImageMap[selectedColor], !images.isEmpty {
            return images
        }
        return [product.imageName]
    }

    var body: some View {
        StickyTopContainer(title: "Tiny Adventures", showsBackButton: true) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    TabView(selection: $selectedImageIndex) {
                        ForEach(Array(currentImages.enumerated()), id: \.offset) { index, imageName in
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.taNeutral)

                                ProductImageView(imageName: imageName, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 325)
                                    .scaleEffect(1.08)
                                    .padding(2)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))

                                Button {
                                    vm.toggleWishlist(for: product)
                                } label: {
                                    Image(systemName: vm.isWishlisted(product) ? "heart.fill" : "heart")
                                        .font(.title2)
                                        .foregroundStyle(vm.isWishlisted(product) ? .red : Color.taText)
                                        .padding(14)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .padding()
                                }
                            }
                            .frame(height: 330)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .frame(height: 330)

                    Text(product.name)
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(Color.taText)

                    Text(product.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 8) {
                        TagChip(text: product.category.rawValue, bg: .taSoftGreen)
                        TagChip(text: product.exploreCategory.rawValue, bg: .taSoftBlue)
                        if product.isOrganic { TagChip(text: "Organic", bg: .taSoftPink) }
                        if product.isNonToxic { TagChip(text: "Non-Toxic", bg: .taNeutral) }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", averageRating))
                        Text("• \(allReviews.count) reviews")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.taLeaf)

                    Text(product.price, format: .currency(code: "USD"))
                        .font(.title2.bold())
                        .foregroundStyle(Color.taText)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Product Description")
                            .font(.title3.bold())
                            .foregroundStyle(Color.taText)

                        Text(product.description)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.taCard)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    if !product.availableColors.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Color")
                                .font(.headline)
                                .foregroundStyle(Color.taText)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(product.availableColors, id: \.self) { color in
                                        Button {
                                            selectedColor = color
                                            selectedImageIndex = 0
                                        } label: {
                                            Text(color)
                                                .font(.subheadline.weight(.semibold))
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 10)
                                                .background(selectedColor == color ? Color.taLeaf : Color.taCard)
                                                .foregroundStyle(selectedColor == color ? .white : Color.taText)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if !product.availableSizes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Size")
                                .font(.headline)
                                .foregroundStyle(Color.taText)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                                ForEach(product.availableSizes, id: \.self) { size in
                                    Button {
                                        selectedSize = size
                                    } label: {
                                        Text(size)
                                            .font(.subheadline.weight(.semibold))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(selectedSize == size ? Color.taLeaf : Color.taCard)
                                            .foregroundStyle(selectedSize == size ? .white : Color.taText)
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                    }
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quantity")
                            .font(.headline)
                            .foregroundStyle(Color.taText)

                        HStack(spacing: 18) {
                            Button {
                                if quantity > 1 { quantity -= 1 }
                            } label: {
                                Image(systemName: "minus")
                                    .frame(width: 40, height: 40)
                                    .background(Color.taCard)
                                    .clipShape(Circle())
                            }

                            Text("\(quantity)")
                                .font(.title3.bold())

                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus")
                                    .frame(width: 40, height: 40)
                                    .background(Color.taCard)
                                    .clipShape(Circle())
                            }
                        }
                        .foregroundStyle(Color.taLeaf)
                    }

                    Button {
                        let finalColor = selectedColor.isEmpty ? "Default" : selectedColor
                        let finalSize = selectedSize.isEmpty ? "Default" : selectedSize
                        vm.addToCart(product, color: finalColor, size: finalSize, quantity: quantity)
                    } label: {
                        Text("Add to Cart")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.taLeaf)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }

                    Divider().padding(.vertical, 6)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Customer Reviews")
                            .font(.title3.bold())
                            .foregroundStyle(Color.taText)

                        ForEach(allReviews) { review in
                            ReviewCard(review: review)
                        }
                    }

                    Divider().padding(.vertical, 6)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Write a Review")
                            .font(.title3.bold())
                            .foregroundStyle(Color.taText)

                        TextField("Your name", text: $reviewName)
                            .styledField()

                        TextField("Review title", text: $reviewTitle)
                            .styledField()

                        Picker("Rating", selection: $reviewRating) {
                            ForEach(1...5, id: \.self) { rating in
                                Text("\(rating)").tag(rating)
                            }
                        }
                        .pickerStyle(.segmented)

                        TextField("Write your review", text: $reviewComment, axis: .vertical)
                            .lineLimit(4...6)
                            .styledField()

                        Button {
                            let newReview = Review(
                                author: reviewName.isEmpty ? "Anonymous" : reviewName,
                                rating: reviewRating,
                                title: reviewTitle.isEmpty ? "Review" : reviewTitle,
                                comment: reviewComment.isEmpty ? "Lovely product." : reviewComment,
                                date: "Today"
                            )
                            submittedReviews.insert(newReview, at: 0)
                            reviewName = ""
                            reviewTitle = ""
                            reviewComment = ""
                            reviewRating = 5
                        } label: {
                            Text("Submit Review")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.taBrown)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                    }
                }
                .padding()
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if selectedColor.isEmpty, let first = product.availableColors.first {
                selectedColor = first
            }
            if selectedSize.isEmpty, let first = product.availableSizes.first {
                selectedSize = first
            }
        }
    }
}


// MARK: - Supporting Views

struct TagChip: View {
    let text: String
    let bg: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(bg)
            .foregroundStyle(Color.taText)
            .clipShape(Capsule())
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.title)
                    .font(.headline)

                Spacer()

                HStack(spacing: 2) {
                    ForEach(0..<review.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                    }
                }
                .font(.caption)
                .foregroundStyle(Color.taLeaf)
            }

            Text("by \(review.author) • \(review.date)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(review.comment)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.taCard)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

extension View {
    func styledField() -> some View {
        self
            .padding()
            .background(Color.taCard)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.taBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ProductImageView: View {
    let imageName: String
    var contentMode: ContentMode = .fit

    var body: some View {
        Group {
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(Color.taLeaf)

                    Text(imageName)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: - Sample Data

extension Product {
    static let sampleProducts: [Product] = [
        
        Product(name: "Girls Bow Headband", category: .accessories, exploreCategory: .girls, style: .accessories, featuredCollection: .flora, collectionsSection: .baby, price: 16, imageName: "girls_headband", subtitle: "Soft organic headband", description: "A sweet soft headband designed for everyday wear and special moments.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Girls", filterCategoryLabel: "Accessories", filterStyleLabel: "Headbands", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink", "White"], collectionLabel: "Flora", availableColors: ["Blush", "Cream"], availableSizes: ["One Size"], reviews: [Review(author: "Nora", rating: 5, title: "So cute", comment: "Looks beautiful and feels soft.", date: "Apr 10")], colorImageMap: ["Blush": ["girls_headband", "girls_headband_2", "girls_headband_3"], "Cream": ["girls_headband_cream", "girls_headband_cream_2", "girls_headband_cream_3"]]),

        Product(name: "Organic Zipper Footie", category: .clothing, exploreCategory: .unisex, style: .footies, featuredCollection: .honeyBunny, collectionsSection: .newCollections, price: 39, imageName: "oatmeal_footie", subtitle: "Printed organic favorite", description: "A soft printed footie with playful charm and everyday comfort.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Unisex", filterCategoryLabel: "Footies", filterStyleLabel: "Footies", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Oatmeal", "Black", "Bunny", "Hippo", "Botanica", "Llama", "Farm", "Turtle"], collectionLabel: "Honey Bunny", availableColors: ["Cream", "Black", "Bunny", "Hippo", "Botanica", "Llama", "Farm", "Turtle"], availableSizes: ["Preemie-NB", "0-3m", "3-6m"], reviews: [Review(author: "Luna", rating: 5, title: "Precious", comment: "The print is adorable.", date: "Apr 8")], colorImageMap: ["Cream": ["oatmeal_footie", "oatmeal_footie_2", "oatmeal_footie_3", "oatmeal_footie_4", "oatmeal_footie_5"], "Black": ["black_footie", "black_footie_2", "black_footie_3"], "Bunny": ["bunny_footie", "bunny_footie_2", "bunny_footie_3", "bunny_footie_4"], "Hippo": ["hippo_footie", "hippo_footie_2", "hippo_footie_3"], "Botanica": ["botanica_footie", "botanica_footie_2", "botanica_footie_3"], "Llama": ["llama_footie", "llama_footie_2", "llama_footie_3"], "Farm": ["farm_footie", "farm_footie_2", "farm_footie_3", "farm_footie_4"], "Turtle": ["turtle_footie", "turtle_footie_2", "turtle_footie_3", "turtle_footie_4"]]),

        Product(name: "Mommy & Me Matching Set", category: .clothing, exploreCategory: .mommyAndMe, style: .matchingSets, featuredCollection: .flora, collectionsSection: .momDad, price: 68, imageName: "mommy_me_set_oatmeal", subtitle: "Matching comfort for mama and baby", description: "A coordinated set designed for keepsake photos, cuddly moments, and everyday elegance.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Women", filterCategoryLabel: "Sets", filterStyleLabel: "Sets", ageRangeLabel: "Adult", availabilityLabel: "In-Stock", colorLabels: ["Pink", "Beige", "Grey", "Black"], collectionLabel: "I Love Mom", availableColors: ["Oatmeal", "Pink", "Gray", "Black"], availableSizes: ["Baby 0-3m", "Baby 3-6m", "Baby 6-9m", "Mom S", "Mom M", "Mom L"], reviews: [Review(author: "Rachel", rating: 5, title: "Love it", comment: "So sweet and flattering.", date: "Mar 11")], colorImageMap: ["Oatmeal": ["mommy_me_set_oatmeal", "mommy_me_set_oatmeal_2", "mommy_me_set_oatmeal_3", "mommy_me_set_oatmeal_4"], "Pink": ["mommy_me_set_pink", "mommy_me_set_pink_2", "mommy_me_set_pink_3"], "Gray": ["mommy_me_set_gray", "mommy_me_set_gray_2", "mommy_me_set_gray_3", "mommy_me_set_gray_4"], "Black": ["mommy_me_set_black", "mommy_me_set_black_2", "mommy_me_set_black_3"]]),

        Product(name: "Mom Organic Slub Tank & Jogger Set", category: .clothing, exploreCategory: .mommyAndMe, style: .matchingSets, featuredCollection: .essentials, collectionsSection: .momDad, price: 78, imageName: "mom_lounge_top_blue", subtitle: "Soft neutral tank & jogger set for matching moments", description: "A relaxed lounge piece for moms who want softness and a refined look.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: false, genderLabel: "Women", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Shirts", ageRangeLabel: "Adult", availabilityLabel: "In-Stock", colorLabels: ["Blue", "Stone", "Black"], collectionLabel: "Organic Essentials", availableColors: ["Blue", "Stone", "Black"], availableSizes: ["XS", "S", "M", "L"], reviews: [Review(author: "Sara", rating: 5, title: "So comfy", comment: "Feels luxe and easy to style.", date: "Apr 4")], colorImageMap: ["Blue": ["mom_lounge_top_blue", "mom_lounge_top_blue_2", "mom_lounge_top_blue_3", "mom_lounge_top_blue_4", "mom_lounge_top_blue_5"], "Stone": ["mom_lounge_top_stone", "mom_lounge_top_stone_2", "mom_lounge_top_stone_3", "mom_lounge_top_stone_4"], "Black": ["mom_lounge_top_black", "mom_lounge_top_black_2", "mom_lounge_top_black_3"]]),

        Product(name: "Unisex Knotted Hat", category: .accessories, exploreCategory: .unisex, style: .accessories, featuredCollection: .organicMuslin, collectionsSection: .baby, price: 14, imageName: "knotted_hat_prickles", subtitle: "A soft finishing touch for newborn looks", description: "A gentle organic knotted hat perfect for newborn outfits and gifting.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Accessories", filterStyleLabel: "Hats", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Prickles", "Llama", "Moonstone", "Bunny", "Cactus", "Botanica", "Shark", "Green"], collectionLabel: "Floral Muslin", availableColors: ["Prickles", "Llama", "Moonstone", "Bunny", "Cactus", "Botanica", "Shark", "Green"], availableSizes: ["One Size"], reviews: [Review(author: "Ella", rating: 5, title: "Adorable", comment: "Perfect hospital bag item.", date: "Feb 2")], colorImageMap: ["Prickles": ["knotted_hat_prickles", "knotted_hat_prickles_2"], "Llama": ["knotted_hat_llama", "knotted_hat_llama_2"], "Moonstone": ["knotted_hat_moonstone", "knotted_hat_moonstone_2"], "Bunny": ["knotted_hat_bunny", "knotted_hat_bunny_2"], "Cactus": ["knotted_hat_cactus", "knotted_hat_cactus_2"], "Botanica": ["knotted_hat_botanica", "knotted_hat_botanica_2"], "Shark": ["knotted_hat_shark", "knotted_hat_shark_2"], "Green": ["knotted_hat_green", "knotted_hat_green_2"]]),


        Product(name: "Baby Booties", category: .essentials, exploreCategory: .unisex, style: .accessories, featuredCollection: .essentials, collectionsSection: .baby, price: 16, imageName: "baby_booties_cream", subtitle: "Tiny cozy booties", description: "Soft baby booties perfect for newborn comfort and gifting.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Accessories", filterStyleLabel: "Baby Booties", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["White", "Blue", "Black"], collectionLabel: "Cotton Basics", availableColors: ["Cream", "Black", "Dusty Blue"], availableSizes: ["Preemie-NB", "0-3m"], reviews: [Review(author: "Mina", rating: 5, title: "Adorable", comment: "Stayed on well.", date: "Mar 25")], colorImageMap: ["Cream": ["baby_booties_cream"], "Black": ["baby_booties_black"], "Dusty Blue": ["baby_booties_blue"]]),


        Product(name: "Organic Blanket", category: .nursery, exploreCategory: .nursery, style: nil, featuredCollection: .organicMuslin, collectionsSection: .newCollections, price: 34, imageName: "fruit_blanket", subtitle: "Breathable muslin comfort for naps", description: "A lightweight organic blanket perfect for stroller rides, snuggles, and nursery layering.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Nursery", filterStyleLabel: "Blankets", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Fruit", "Bear", "Turtle", "Panda", "Botanica", "Christmas", "Green", "Snow"], collectionLabel: "Organic Muslin", availableColors: ["Fruit", "Bear", "Turtle", "Panda", "Botanica", "Christmas", "Green", "Snow"], availableSizes: ["One Size"], reviews: [Review(author: "Sofia", rating: 5, title: "Premium feel", comment: "Feels soft and luxurious.", date: "Apr 1")], colorImageMap: ["Fruit": ["fruit_blanket", "fruit_blanket_2", "fruit_blanket_3", "fruit_blanket_4"], "Bear": ["bear_blanket", "bear_blanket_2", "bear_blanket_3"], "Turtle": ["turtle_blanket", "turtle_blanket_3", "turtle_blanket_4"], "Panda": ["panda_blanket", "panda_blanket_2"], "Botanica": ["botanica_blanket", "botanica_blanket_2"], "Christmas": ["christmas_blanket", "christmas_blanket_2", "christmas_blanket_3", "christmas_blanket_4", "christmas_blanket_5"], "Green": ["green_blanket", "green_blanket_2", "green_blanket_3"], "Snow": ["snow_blanket", "snow_blanket_2", "snow_blanket_3", "snow_blanket_4"]]),

        Product(name: "Organic Crib Sheets", category: .nursery, exploreCategory: .nursery, style: nil, featuredCollection: .essentials, collectionsSection: .newCollections, price: 28, imageName: "crib_sheet_foxy", subtitle: "Soft fitted sheet for a calm sleep space", description: "A gentle crib sheet crafted for a clean, breathable nursery setup.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Nursery", filterStyleLabel: "Crib Sheets", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Foxy", "Bunny", "Rainbow", "Oatmeal", "Blue", "Prickle"], collectionLabel: "The Neutral Collection", availableColors: ["Foxy", "Bunny", "Rainbow", "Oatmeal", "Blue", "Prickle"], availableSizes: ["One Size"], reviews: [Review(author: "Layla", rating: 5, title: "Lovely", comment: "Fits perfectly and feels smooth.", date: "Mar 16")], colorImageMap: ["Foxy": ["crib_sheet_foxy", "crib_sheet_foxy_3", "crib_sheet_foxy_4"], "Bunny": ["crib_sheet_bunny", "crib_sheet_bunny_3", "crib_sheet_bunny_4"], "Rainbow": ["crib_sheet_rainbow", "crib_sheet_rainbow_2", "crib_sheet_rainbow_3", "crib_sheet_rainbow_4"], "Oatmeal": ["crib_sheet_oatmeal", "crib_sheet_oatmeal_2", "crib_sheet_oatmeal_3", "crib_sheet_oatmeal_4"], "Blue": ["crib_sheet_blue", "crib_sheet_blue_2", "crib_sheet_blue_3"], "Prickle": ["crib_sheet_prickle", "crib_sheet_prickle_2", "crib_sheet_prickle_3"]]),

        
        // GIRLS
        Product(name: "Organic Bubble Romper", category: .clothing, exploreCategory: .girls, style: .rompers, featuredCollection: .flora, collectionsSection: .baby, price: 40, imageName: "horse_smocked_romper", subtitle: "Sweet smocked romper", description: "A soft organic romper with a delicate smocked top.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Rompers", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Horse", "Floral", "Botanica"], collectionLabel: "Flora", availableColors: ["Horse", "Floral", "Botanica"], availableSizes: ["0-3m", "3-6m", "6-9m", "9-12m"], reviews: [], colorImageMap: ["Horse": ["horse_smocked_romper", "horse_smocked_romper_2", "horse_smocked_romper_3"], "Floral": ["floral_smocked_romper", "floral_smocked_romper_2"], "Botanica": ["botanica_smocked_romper", "botanica_smocked_romper_2"]]),

        Product(name: "Organic Zipper Footie", category: .clothing, exploreCategory: .girls, style: .footies, featuredCollection: .essentials, collectionsSection: .baby, price: 36, imageName: "girls_lavender_zipper_footie", subtitle: "Soft zipper footie", description: "An everyday organic zipper footie in a soft hue.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Girls", filterCategoryLabel: "Footies", filterStyleLabel: "Footies", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Purple", "Pink"], collectionLabel: "Organic Essentials", availableColors: ["Lavender", "Blush"], availableSizes: ["Preemie-NB", "0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Lavender": ["girls_lavender_zipper_footie", "girls_lavender_zipper_footie_2", "girls_lavender_zipper_footie_3"], "Blush": ["girls_blush_zipper_footie", "girls_blush_zipper_footie_2", "girls_blush_zipper_footie_3"]]),

        Product(name: "Organic Kimono Bodysuit", category: .clothing, exploreCategory: .girls, style: .bodysuits, featuredCollection: .essentials, collectionsSection: .baby, price: 24, imageName: "girls_kimono_bodysuit", subtitle: "Wrap-style organic bodysuit", description: "A soft kimono-style bodysuit for easy dressing and gentle comfort.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: true, genderLabel: "Girls", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Bodysuits", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink", "White"], collectionLabel: "Cotton Basics", availableColors: ["Cream", "Blush"], availableSizes: ["Preemie-NB", "0-3m", "3-6m"], reviews: [], colorImageMap: ["Cream": ["girls_kimono_bodysuit_cream", "girls_kimono_bodysuit_cream_2", "girls_kimono_bodysuit_cream_3", "girls_kimono_bodysuit_cream_4"], "Blush": ["girls_kimono_bodysuit", "girls_kimono_bodysuit_2"]]),

        Product(name: "Cotton Candy Organic Pointelle Ruffle Bloomer", category: .clothing, exploreCategory: .girls, style: nil, featuredCollection: .flora, collectionsSection: .baby, price: 20, imageName: "girls_pointelle_bloomer", subtitle: "Pointelle ruffle bloomer", description: "A soft organic pointelle bloomer with sweet ruffle detailing.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "Bottoms", filterStyleLabel: "Shorts", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink"], collectionLabel: "Flora", availableColors: ["Cotton Candy"], availableSizes: ["0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Cotton Candy": ["girls_pointelle_bloomer", "girls_pointelle_bloomer_2", "girls_pointelle_bloomer_3"]]),

        Product(name: "Organic Gown", category: .clothing, exploreCategory: .girls, style: nil, featuredCollection: .essentials, collectionsSection: .baby, price: 28, imageName: "girls_organic_gown", subtitle: "Newborn organic sleep gown", description: "A soft and cozy organic gown for easy nighttime changes.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: true, genderLabel: "Girls", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Gowns", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink", "White"], collectionLabel: "Organic Essentials", availableColors: ["Blush", "White"], availableSizes: ["Preemie-NB", "0-3m"], reviews: [], colorImageMap: ["Blush": ["girls_organic_gown", "girls_organic_gown_2"], "White": ["girls_organic_gown_white", "girls_organic_gown_white_2"]]),

        Product(name: "Organic Pointelle Criss-Cross Bodysuit", category: .clothing, exploreCategory: .girls, style: .bodysuits, featuredCollection: .essentials, collectionsSection: .baby, price: 22, imageName: "girls_cross_bodysuit_cottoncandy", subtitle: "3-pack soft organic bandana bibs", description: "A crossback straps bodysuits with delicate textures", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Girls", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Bodysuits", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Cotton Candy", "Grey", "Black"], collectionLabel: "Organic Essentials", availableColors: ["Cotton Candy", "Grey", "Black"], availableSizes: ["0-3m", "3-6m", "6-9m", "9-12m", "12-18m"], reviews: [], colorImageMap: ["Cotton Candy": ["girls_cross_bodysuit_cottoncandy", "girls_cross_bodysuit_cottoncandy_2", "girls_cross_bodysuit_cottoncandy_3", "girls_cross_bodysuit_cottoncandy_4", "girls_cross_bodysuit_cottoncandy_5"], "Grey": ["girls_cross_bodysuit_grey", "girls_cross_bodysuit_grey_2"], "Black": ["girls_cross_bodysuit_black", "girls_cross_bodysuit_black_2", "girls_cross_bodysuit_black_3", "girls_cross_bodysuit_black_4"]]),

        Product(name: "Chia Floral Organic Muslin Ruffle Bodysuit", category: .clothing, exploreCategory: .girls, style: .bodysuits, featuredCollection: .flora, collectionsSection: .baby, price: 30, imageName: "girls_chia_floral_bodysuit", subtitle: "Muslin ruffle bodysuit", description: "An airy organic muslin bodysuit with floral print and ruffle trim.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Bodysuits", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink", "Multi"], collectionLabel: "Flora", availableColors: ["Chia Floral"], availableSizes: ["0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Chia Floral": ["girls_chia_floral_bodysuit", "girls_chia_floral_bodysuit_2"]]),

        Product(name: "Rosewater Dots Organic Ruffle Neck Bodysuit", category: .clothing, exploreCategory: .girls, style: .bodysuits, featuredCollection: .flora, collectionsSection: .baby, price: 28, imageName: "girls_rosewater_bodysuit", subtitle: "Ruffle neck dotted bodysuit", description: "A soft dotted organic bodysuit with a charming ruffle neckline.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Bodysuits", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink", "White"], collectionLabel: "Flora", availableColors: ["Rosewater Dots"], availableSizes: ["0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Rosewater Dots": ["girls_rosewater_bodysuit", "girls_rosewater_bodysuit_2", "girls_rosewater_bodysuit_3", "girls_rosewater_bodysuit_4"]]),

        Product(name: "Organic Sweatshirt & Jogger Set", category: .clothing, exploreCategory: .girls, style: .matchingSets, featuredCollection: .essentials, collectionsSection: .toddlerKids, price: 52, imageName: "girls_sweatshirt_jogger_set_2", subtitle: "Cozy matching sweatshirt set", description: "A soft organic sweatshirt and jogger set for comfort and play.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Girls", filterCategoryLabel: "Sets", filterStyleLabel: "Sweatshirts", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Pink", "Beige"], collectionLabel: "Cozy Fleece", availableColors: ["Buttercream", "Oatmeal"], availableSizes: ["0-3m", "3-6m", "6-9m", "9-12m", "2T"], reviews: [], colorImageMap: ["Buttercream": ["girls_sweatshirt_jogger_set_2", "girls_sweatshirt_jogger_set_3", "girls_sweatshirt_jogger_set_4"], "Oatmeal": ["girls_sweatshirt_jogger_set_oatmeal", "girls_sweatshirt_jogger_set_oatmeal_2", "girls_sweatshirt_jogger_set_oatmeal_3"]]),


        Product(name: "Organic Muslin Sleeveless Romper", category: .clothing, exploreCategory: .girls, style: .rompers, featuredCollection: .organicMuslin, collectionsSection: .baby, price: 30, imageName: "girls_muslin_sleeveless_romper", subtitle: "Sleeveless muslin romper", description: "A breezy sleeveless organic muslin romper for warm days.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Rompers", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pink", "Beige"], collectionLabel: "Organic Muslin", availableColors: ["Blush", "Chia"], availableSizes: ["0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Blush": ["girls_muslin_sleeveless_romper"], "Chia": ["girls_muslin_sleeveless_romper_chia", "girls_muslin_sleeveless_romper_chia_2"]]),

        // BOYS
        Product(name: "Organic Zipper Footie", category: .clothing, exploreCategory: .boys, style: .footies, featuredCollection: .essentials, collectionsSection: .baby, price: 36, imageName: "boys_organic_zipper_footie", subtitle: "Classic zipper footie", description: "A soft everyday organic zipper footie made for comfort and easy changes.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Boys", filterCategoryLabel: "Footies", filterStyleLabel: "Footies", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Blue", "White"], collectionLabel: "Organic Essentials", availableColors: ["Blue", "Cream"], availableSizes: ["Preemie-NB", "0-3m", "3-6m"], reviews: [], colorImageMap: ["Blue": ["boys_organic_zipper_footie_blue", "boys_organic_zipper_footie_blue_2", "boys_organic_zipper_footie_blue_3"], "Cream": ["boys_organic_zipper_footie", "boys_organic_zipper_footie_2", "boys_organic_zipper_footie_3"]]),


        Product(name: "Organic Knotted Hat", category: .accessories, exploreCategory: .boys, style: .accessories, featuredCollection: .essentials, collectionsSection: .baby, price: 14, imageName: "boys_knotted_hat", subtitle: "Newborn organic knotted hat", description: "A gentle organic knotted hat for newborn comfort.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: true, genderLabel: "Boys", filterCategoryLabel: "Accessories", filterStyleLabel: "Hats", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Blue", "White"], collectionLabel: "Cotton Basics", availableColors: ["Blue", "Cream"], availableSizes: ["One Size"], reviews: [], colorImageMap: ["Blue": ["boys_knotted_hat_blue"], "Cream": ["boys_knotted_hat"]]),

        Product(name: "Organic Sleeveless Romper", category: .clothing, exploreCategory: .boys, style: .rompers, featuredCollection: .organicMuslin, collectionsSection: .baby, price: 30, imageName: "boys_sleeveless_romper", subtitle: "Sleeveless organic romper", description: "A breathable sleeveless romper for warm-weather comfort.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: false, genderLabel: "Boys", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Rompers", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Blue", "Game"], collectionLabel: "Organic Muslin", availableColors: ["Sky", "Game Day"], availableSizes: ["0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Sky": ["boys_sleeveless_romper_sky","boys_sleeveless_romper_sky_2", "boys_sleeveless_romper_sky_3"], "Game Day": ["boys_sleeveless_romper", "boys_sleeveless_romper_2", "boys_sleeveless_romper_3", "boys_sleeveless_romper_4"]]),

        Product(name: "Organic Short-Sleeve Kimono Bodysuit", category: .clothing, exploreCategory: .boys, style: .bodysuits, featuredCollection: .essentials, collectionsSection: .baby, price: 24, imageName: "boys_kimono_bodysuit", subtitle: "Short-sleeve kimono bodysuit", description: "A soft wrap-style organic bodysuit for easy dressing.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: true, genderLabel: "Boys", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Bodysuits", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Blue", "Green"], collectionLabel: "Cotton Basics", availableColors: ["Blue", "Green"], availableSizes: ["Preemie-NB", "0-3m", "3-6m"], reviews: [], colorImageMap: ["Blue": ["boys_kimono_bodysuit_blue"], "Green": ["boys_kimono_bodysuit"]]),

        Product(name: "Organic Cuffed Zipper Footie", category: .clothing, exploreCategory: .boys, style: .footies, featuredCollection: .essentials, collectionsSection: .baby, price: 37, imageName: "boys_cuffed_zipper_footie", subtitle: "Cuffed footie with zipper", description: "A cozy cuffed organic footie designed for softness and comfort.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: false, genderLabel: "Boys", filterCategoryLabel: "Footies", filterStyleLabel: "Footies", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Pool", "Game"], collectionLabel: "Organic Essentials", availableColors: ["Pool", "Game Day"], availableSizes: ["Preemie-NB", "0-3m", "3-6m"], reviews: [], colorImageMap: ["Pool": ["boys_cuffed_zipper_footie_pool","boys_cuffed_zipper_footie_pool_2", "boys_cuffed_zipper_footie_pool_3"], "Game Day": ["boys_cuffed_zipper_footie", "boys_cuffed_zipper_footie_2", "boys_cuffed_zipper_footie_3"]]),


        // UNISEX

        Product(name: "French Terry Tee & Shorties Set", category: .clothing, exploreCategory: .unisex, style: .rompers, featuredCollection: .organicMuslin, collectionsSection: .baby, price: 30, imageName: "unisex_muslin_romper", subtitle: "Tee & Shorties Set", description: "A lightweight organic frenchn terry tee & shorties set for any occasion.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Unisex", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Set", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Indigo", "Red", "Sky"], collectionLabel: "Organic Muslin", availableColors: ["Indigo", "Red", "Sky"], availableSizes: ["0-3m", "3-6m", "6-9m"], reviews: [], colorImageMap: ["Sky": ["unisex_muslin_romper_sky", "unisex_muslin_romper_sky_2", "unisex_muslin_romper_sky_3", "unisex_muslin_romper_sky_4"], "Red": ["unisex_muslin_romper_red", "unisex_muslin_romper_red_2", "unisex_muslin_romper_red_3"], "Indigo": ["unisex_muslin_romper", "unisex_muslin_romper_2", "unisex_muslin_romper_3", "unisex_muslin_romper_4"]]),

        Product(name: "Kids' Organic Pj Set", category: .toddlerKids, exploreCategory: .unisex, style: nil, featuredCollection: .essentials, collectionsSection: .toddlerKids, price: 40, imageName: "unisex_organic_pj_farm", subtitle: "Soft organic pj set", description: "Designed to be comfortably-snug and form-fitting", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Tees", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Farm", "Acorn", "Cow", "Llama"], collectionLabel: "Cotton Basics", availableColors: ["Farm", "Acorn", "Cow", "Llama"], availableSizes: ["18-24M", "2T", "3T", "4T", "5", "6"], reviews: [], colorImageMap: ["Farm": ["unisex_organic_pj_farm", "unisex_organic_pj_farm_2", "unisex_organic_pj_farm_3", "unisex_organic_pj_farm_4", "unisex_organic_pj_farm_5"], "Acorn": ["unisex_organic_pj_acorn", "unisex_organic_pj_acorn_2", "unisex_organic_pj_acorn_3"], "Cow": ["unisex_organic_pj_cow", "unisex_organic_pj_cow_2", "unisex_organic_pj_cow_3"], "Llama": ["unisex_organic_pj_llama", "unisex_organic_pj_llama_2", "unisex_organic_pj_llama_3", "unisex_organic_pj_llama_4"]]),
        
        Product(name: "Organic French Terry Overall Romper", category: .clothing, exploreCategory: .unisex, style: .rompers, featuredCollection: .essentials, collectionsSection: .baby, price: 34, imageName: "girls_french_terry_overall_romper", subtitle: "French terry overall romper", description: "A cozy organic overall romper in soft French terry for everyday wear.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Overalls", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Beige", "Brown"], collectionLabel: "French Terry", availableColors: ["Oatmeal", "Sand"], availableSizes: ["3-6m", "6-9m", "9-12m"], reviews: [], colorImageMap: ["Oatmeal": ["girls_french_terry_overall_romper", "girls_french_terry_overall_romper_2"], "Sand": ["girls_french_terry_overall_romper_sand", "girls_french_terry_overall_romper_sand_2", "girls_french_terry_overall_romper_sand_3"]]),

        // MOMMY & ME
        Product(name: "Mom & Mini Hoodie Dress Bundle", category: .clothing, exploreCategory: .mommyAndMe, style: .matchingSets, featuredCollection: .essentials, collectionsSection: .momDad, price: 78, imageName: "mom_mini_hoodie_dress_bundle", subtitle: "Matching hoodie dress bundle", description: "A coordinated mom and mini hoodie dress bundle made for cozy matching moments.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Women", filterCategoryLabel: "Sets", filterStyleLabel: "Hoodies", ageRangeLabel: "Adult", availabilityLabel: "In-Stock", colorLabels: ["Pink", "Indigo"], collectionLabel: "Cozy Fleece", availableColors: ["Rose", "Indigo"], availableSizes: ["Mini 2T", "Mini 3T", "Mini 4T", "Mom S", "Mom M", "Mom L"], reviews: [], colorImageMap: ["Rose": ["mom_mini_hoodie_dress_bundle"], "Indigo": ["mom_mini_hoodie_dress_bundle_indigo"]]),

        // NURSERY
        Product(name: "Lovey With Removable Teething Ring", category: .nursery, exploreCategory: .nursery, style: nil, featuredCollection: .babyAnimals, collectionsSection: .newCollections, price: 24, imageName: "fruit_teething_ring", subtitle: "Lovey with removable teething ring", description: "A soft nursery lovey paired with a removable teething ring for comfort and soothing.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Lovies", filterStyleLabel: "Lovies", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Fruit", "Bear"], collectionLabel: "Baby Animals", availableColors: ["Fruit", "Bear"], availableSizes: ["One Size"], reviews: [], colorImageMap: ["Fruit": ["fruit_teething_ring", "fruit_teething_ring_2", "fruit_teething_ring_3", "fruit_teething_ring_4"], "Bear": ["bear_teething_ring", "bear_teething_ring_2", "bear_teething_ring_3"]]),

    
        // TODDLER & KIDS
        Product(name: "Kids' Organic French Terry Shorts & Tee Set", category: .toddlerKids, exploreCategory: .toddlerKids, style: .matchingSets, featuredCollection: .essentials, collectionsSection: .toddlerKids, price: 48, imageName: "kids_french_terry_set_pink", subtitle: "French terry shorts and tee set", description: "A relaxed kids' organic set with soft French terry shorts and tee.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Unisex", filterCategoryLabel: "Sets", filterStyleLabel: "Sets", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Pink", "Blue", "Gray"], collectionLabel: "French Terry", availableColors: ["Pink", "Blue", "Gray"], availableSizes: ["2T", "3T", "4T", "5", "6"], reviews: [], colorImageMap: ["Pink": ["kids_french_terry_set_pink", "kids_french_terry_set_pink_2", "kids_french_terry_set_pink_3"], "Blue": ["kids_french_terry_set_blue", "kids_french_terry_set_blue_2", "kids_french_terry_set_blue_3"], "Gray": ["kids_french_terry_set_gray", "kids_french_terry_set_gray_2", "kids_french_terry_set_gray_3"]]),

        Product(name: "Kids' Organic Button-Up Shirt", category: .toddlerKids, exploreCategory: .toddlerKids, style: nil, featuredCollection: .essentials, collectionsSection: .toddlerKids, price: 34, imageName: "denim_button_up_shirt", subtitle: "Organic button-up shirt", description: "A polished yet soft button-up shirt for kids.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: false, genderLabel: "Unisex", filterCategoryLabel: "Tops & Bodysuits", filterStyleLabel: "Shirts", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Denim", "Farm", "Cow", "Oatmeal", "White"], collectionLabel: "Cotton Basics", availableColors: ["Denim", "Farm", "Cow", "Oatmeal", "White"], availableSizes: ["2T", "3T", "4T", "5", "6"], reviews: [], colorImageMap: ["Denim": ["denim_button_up_shirt"], "Farm": ["farm_button_up_shirt", "farm_button_up_shirt_2", "farm_button_up_shirt_3"], "Cow": ["cow_button_up_shirt", "cow_button_up_shirt_2", "cow_button_up_shirt_3", "cow_button_up_shirt_4"], "Oatmeal": ["oatmeal_button_up_shirt", "oatmeal_button_up_shirt_2", "oatmeal_button_up_shirt_3", "oatmeal_button_up_shirt_4", "oatmeal_button_up_shirt_5", "oatmeal_button_up_shirt_6"], "White": ["white_button_up_shirt", "white_button_up_shirt_2"]]),

        Product(name: "Organic Smocked Summer Dress", category: .toddlerKids, exploreCategory: .toddlerKids, style: .dresses, featuredCollection: .flora, collectionsSection: .toddlerKids, price: 40, imageName: "denim_smocked_summer_dress", subtitle: "Smocked summer dress", description: "A breezy organic summer dress with delicate smocking.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: true, isBestSelling: false, genderLabel: "Girls", filterCategoryLabel: "Dresses", filterStyleLabel: "Dresses", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Denim", "Red", "Green", "Cream", "Blue", "Pink", "Oatmeal"], collectionLabel: "Flora", availableColors: ["Denim", "Red", "Green", "Cream", "Blue", "Pink", "Oatmeal"], availableSizes: ["2T", "3T", "4T", "5"], reviews: [], colorImageMap: ["Denim": ["denim_smocked_summer_dress", "denim_smocked_summer_dress_2", "denim_smocked_summer_dress_3", "denim_smocked_summer_dress_4", "denim_smocked_summer_dress_5"], "Red": ["red_smocked_summer_dress", "red_smocked_summer_dress_2", "red_smocked_summer_dress_3", "red_smocked_summer_dress_4", "red_smocked_summer_dress_5"], "Green": ["green_smocked_summer_dress", "green_smocked_summer_dress_2", "green_smocked_summer_dress_3", "green_smocked_summer_dress_4"], "Cream": ["cream_smocked_summer_dress", "cream_smocked_summer_dress_2", "cream_smocked_summer_dress_3", "cream_smocked_summer_dress_4"], "Blue": ["blue_smocked_summer_dress", "blue_smocked_summer_dress_2", "blue_smocked_summer_dress_3", "blue_smocked_summer_dress_4"], "Pink": ["pink_smocked_summer_dress", "pink_smocked_summer_dress_2", "pink_smocked_summer_dress_3", "pink_smocked_summer_dress_4", "pink_smocked_summer_dress_5"], "Oatmeal": ["oatmeal_smocked_summer_dress", "oatmeal_smocked_summer_dress_2", "oatmeal_smocked_summer_dress_3", "oatmeal_smocked_summer_dress_4"]]),

        Product(name: "Organic Potty-Training Briefs", category: .toddlerKids, exploreCategory: .toddlerKids, style: nil, featuredCollection: .essentials, collectionsSection: .toddlerKids, price: 26, imageName: "oatmeal_organic_briefs", subtitle: "Soft organic briefs", description: "Breathable organic briefs for all-day comfort.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Underwear", filterStyleLabel: "Underwear", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Oatmeal", "Buttercream", "Cow", "Llama", "Farm", "Turtle"], collectionLabel: "Cotton Basics", availableColors: ["Oatmeal", "Buttercream", "Cow", "Llama", "Farm", "Turtle"], availableSizes: ["2T", "3T", "4T", "5", "6"], reviews: [], colorImageMap: ["Oatmeal": ["oatmeal_organic_briefs"], "Buttercream": ["buttercream_organic_briefs"], "Cow": ["cow_organic_briefs"], "Llama": ["llama_organic_briefs"], "Farm": ["farm_organic_briefs"], "Turtle": ["turtle_organic_briefs"]]),

        Product(name: "Organic Cuffed Muslin Overall", category: .toddlerKids, exploreCategory: .toddlerKids, style: nil, featuredCollection: .organicMuslin, collectionsSection: .toddlerKids, price: 38, imageName: "gray_cuffed_muslin_overall", subtitle: "Cuffed muslin overall", description: "A soft organic muslin overall with a relaxed fit and cuffed finish.", isOrganic: true, isNonToxic: true, isTrending: false, isJustLaunched: true, isBestSelling: false, genderLabel: "Unisex", filterCategoryLabel: "One-Pieces", filterStyleLabel: "Overalls", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Gray", "Light"], collectionLabel: "Organic Muslin", availableColors: ["Gray", "Light"], availableSizes: ["2T", "3T", "4T"], reviews: [], colorImageMap: ["Gray": ["gray_cuffed_muslin_overall", "gray_cuffed_muslin_overall_2", "gray_cuffed_muslin_overall_3", "gray_cuffed_muslin_overall_4"], "Light": ["light_cuffed_muslin_overall", "light_cuffed_muslin_overall_2", "light_cuffed_muslin_overall_3", "light_cuffed_muslin_overall_4"]]),

        Product(name: "Kids' Organic PJ Set", category: .toddlerKids, exploreCategory: .toddlerKids, style: .pajamas, featuredCollection: .essentials, collectionsSection: .toddlerKids, price: 42, imageName: "turtle_organic_pj_set", subtitle: "Classic organic pajama set", description: "A soft pajama set made for bedtime comfort.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "PJs", filterStyleLabel: "PJs", ageRangeLabel: "Toddler/Kid", availabilityLabel: "In-Stock", colorLabels: ["Turtle", "Horse", "Sun", "Dots"], collectionLabel: "Organic Essentials", availableColors: ["Turtle", "Horse", "Sun", "Dots"], availableSizes: ["2T", "3T", "4T", "5", "6"], reviews: [], colorImageMap: ["Turtle": ["turtle_organic_pj_set", "turtle_organic_pj_set_2", "turtle_organic_pj_set_3"], "Horse": ["horse_organic_pj_set", "horse_organic_pj_set_2", "horse_organic_pj_set_3", "horse_organic_pj_set_4"], "Sun": ["sun_organic_pj_set", "sun_organic_pj_set_2", "sun_organic_pj_set_3"], "Dots": ["dots_organic_pj_set", "dots_organic_pj_set_2", "dots_organic_pj_set_3"]]),
        
        // SHOP BY STYLE - ACCESSORIES
        Product(name: "Organic Bandana Bib 3-Pack", category: .accessories, exploreCategory: .unisex, style: .accessories, featuredCollection: .essentials, collectionsSection: .baby, price: 22, imageName: "organic_bandana_bib_3pack", subtitle: "3-pack organic bib set", description: "A soft everyday bandana bib set made with organic materials.", isOrganic: true, isNonToxic: true, isTrending: true, isJustLaunched: false, isBestSelling: true, genderLabel: "Unisex", filterCategoryLabel: "Accessories", filterStyleLabel: "Bibs", ageRangeLabel: "Infant", availabilityLabel: "In-Stock", colorLabels: ["Multi", "Cream"], collectionLabel: "Organic Essentials", availableColors: ["Multi", "Cream"], availableSizes: ["One Size"], reviews: [], colorImageMap: ["Multi": ["organic_bandana_bib_3pack"], "Cream": ["organic_bandana_bib_3pack_cream", "organic_bandana_bib_3pack_cream_2"]]),

       
        ]
        }


        // MARK: - Previews

        struct PreviewShopContainer<Content: View>: View {
            @StateObject private var vm = ShopViewModel()
            let content: () -> Content

            var body: some View {
                content()
                    .environmentObject(vm)
            }
        }

        #Preview("App Preview") {
            PreviewShopContainer {
                ContentView()
            }
        }

        #Preview("Home") {
            PreviewShopContainer {
                NavigationStack {
                    HomeView()
                }
            }
        }

        #Preview("Collections") {
            PreviewShopContainer {
                NavigationStack {
                    CollectionsView()
                }
            }
        }

        #Preview("Trending") {
            PreviewShopContainer {
                NavigationStack {
                    TrendingView()
                }
            }
        }

        #Preview("Account") {
            PreviewShopContainer {
                NavigationStack {
                    AccountView()
                }
            }
        }

        #Preview("Product Card") {
            PreviewShopContainer {
                ProductCardView(product: Product.sampleProducts[0])
                    .padding()
                    .background(Color.taCream)
            }
        }

        #Preview("Product Detail") {
            PreviewShopContainer {
                NavigationStack {
                    ProductDetailView(product: Product.sampleProducts[0])
                }
            }
        }

        #Preview("Cart") {
            PreviewShopContainer {
                NavigationStack {
                    CartView()
                }
            }
        }

        #Preview("Wishlist") {
            PreviewShopContainer {
                WishlistView()
            }
        }

        #Preview("Search") {
            PreviewShopContainer {
                SearchSheetView()
            }
        }

        #Preview("Create Account") {
            PreviewShopContainer {
                CreateAccountView()
            }
        }

        #Preview("Sign In") {
            PreviewShopContainer {
                SignInView()
            }
        }

        #Preview("Change Password") {
            PreviewShopContainer {
                NavigationStack {
                    ChangePasswordView()
                }
            }
        }

   
// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(ShopViewModel())
}
