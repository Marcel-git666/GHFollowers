//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 10.01.2024.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {

    enum Section {
        case main
    }

    var username: String!
    var followers = [Follower]()
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers: Bool = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var refreshControl: UIRefreshControl!

    let tokenRepository: TokenRepository

    init(username: String, tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureRefreshControl()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && !isLoadingMoreFollowers {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            if let username = username {
                config.secondaryText = "User \(username) has no followers."
            }
            config.text = "No followers"
            contentUnavailableConfiguration = config
        } else if isSearching && filteredFollowers.isEmpty {
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc func refreshData() {
        // Reset page and clear existing followers
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()

        // Fetch fresh data
        getFollowers(username: username, page: page)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let followButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                           style: .plain, target: self, action: #selector(followButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, followButton]
    }

    @objc func followButtonTapped() {
        guard let tokenBag = tokenRepository.getToken() else {
            presentGFAlert(title: "Error", message: "You are not logged in. Please log in first.", buttonTitle: "OK")
            return
        }
        showLoadingView()
        Task {
            do {
                try await followUser(token: tokenBag.accessToken)
                let loggedInUsername = try await NetworkManager.shared.getLogin(token: tokenBag.accessToken)
                let newFollower = Follower(login: loggedInUsername, avatarUrl: "") // Replace with actual avatar URL retrieval
                followers.append(newFollower)
                updateData(on: [newFollower])
                presentGFAlert(title: "Success", message: "You have successfully followed \(username ?? "Unknown user")", buttonTitle: "OK")
                Task {
                    let user = try await NetworkManager.shared.getUserInfo(for: loggedInUsername)
                    // Update temporary follower with actual info
                    if let index = followers.firstIndex(where: { $0.login == user.login }) {
                        followers[index].avatarUrl = user.avatarUrl
                    }
                    updateData(on: followers)
                }
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Error", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentGFAlert(title: "Error", message: "Failed to follow \(username ?? "Unknown user")", buttonTitle: "OK")
                }
                dismissLoadingView()
            }
            dismissLoadingView()
        }
    }

    func followUser(token: String) async throws {
        try await NetworkManager.shared.followUser(username: username, token: token)
    }

    @objc func addButtonTapped() {
        showLoadingView()
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavorites(user: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something wrong", message: gfError.rawValue, buttonTitle: "Ok")
                    dismissLoadingView()
                } else {
                    presentDefaultEror()
                    dismissLoadingView()
                }
            }
        }
    }

    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self else { return }
            guard let error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success",
                                        message: "You have successfully favorited a user \(user.login)🎆", buttonTitle: "Hooray")
                }
                dismissLoadingView()
                return
            }
            dismissLoadingView()
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Failure", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }

    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollower(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something bad happened", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultEror()
                }
                dismissLoadingView()
                isLoadingMoreFollowers = false
            }
            DispatchQueue.main.async {
                self.dismissLoadingView()
                self.isLoadingMoreFollowers = false
                self.refreshControl.endRefreshing() // Stop refresh animation
            }
        }
    }

    func updateFollowers(username: String, page: Int) async throws {
        showLoadingView()
        isLoadingMoreFollowers = true
        do {
            let followers = try await NetworkManager.shared.getFollower(for: username, page: page)
            updateUI(with: followers)
            dismissLoadingView()
            isLoadingMoreFollowers = false
        } catch {
            if let gfError = error as? GFError {
                presentGFAlert(title: "Something bad happened", message: gfError.rawValue, buttonTitle: "Ok")
            } else {
                presentDefaultEror()
            }
            dismissLoadingView()
            isLoadingMoreFollowers = false
        }
    }

    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { hasMoreFollowers = false }
        self.followers += followers
        self.updateData(on: followers)
        setNeedsUpdateContentUnavailableConfiguration()
    }

    func configureDataSource() { // swiftlint:disable force_cast
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower) // swiftlint:enable force_cast
            return cell
        })
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeiht = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeiht - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        navigationItem.searchController?.searchBar.text = ""
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
