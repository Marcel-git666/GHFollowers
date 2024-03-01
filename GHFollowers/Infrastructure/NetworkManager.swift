//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 12.01.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()

    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func getFollower(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }

        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

    func getLogin(token: String) async throws -> String {
        let apiUrl = "https://api.github.com/user"

        guard let url = URL(string: apiUrl) else {
            throw GFError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw GFError.invalidResponse
            }

            do {
                let user = try decoder.decode(User.self, from: data)
                return user.login
            } catch {
                throw GFError.invalidData
            }
        } catch {
            throw GFError.unexpectedError
        }
    }

    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }

        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

    func followUser(username: String, token: String) async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        let apiUrl = "https://api.github.com/user/following/\(username)"

        guard let url = URL(string: apiUrl) else {
            throw GFError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw GFError.invalidResponse
            }

            if (200...299).contains(httpResponse.statusCode) {
                print("Successfully followed user \(username) with status code: \(httpResponse.statusCode)")
                print("Follow request for \(username) completed in \(CFAbsoluteTimeGetCurrent() - startTime) seconds")
            } else {
                throw GFError.failedToFollowUser(username: username, statusCode: httpResponse.statusCode)
            }
        } catch {
            throw GFError.invalidResponse
        }
    }

    func unfollowUser(_ username: String, token: String) async throws {
        let apiUrl = "https://api.github.com/users/\(username)/following/\(username)"

        guard let url = URL(string: apiUrl) else {
            throw GFError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw GFError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 204:
                return // Successfully unfollowed
            case 404:
                // Handle unexpected 404 (optional)
                return // Assume unfollowed as 404 might indicate already unfollowed
            default:
                throw GFError.failedToUnfollowUser(username: username, statusCode: httpResponse.statusCode)
            }
        } catch {
            throw GFError.unexpectedError
        }
    }

    func isFollowing(_ targetUsername: String, token: String, currentUser: String) async throws -> Bool {
        // Ensure username is not the same as current user
        guard targetUsername != currentUser else {
            return false // User cannot follow themselves
        }

        let apiUrl = "https://api.github.com/users/\(currentUser)/following/\(targetUsername)"

        guard let url = URL(string: apiUrl) else {
            throw GFError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw GFError.invalidResponse
            }
            return httpResponse.statusCode == 204 // 204 indicates following
        } catch {
            throw GFError.unexpectedError
        }
    }

    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
