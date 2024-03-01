//
//  FavoriteView.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 01.03.2024.
//

import SwiftUI

struct FavoriteView: View {

    var favorite: Follower

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: favorite.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .cornerRadius(10)
//            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            Text(favorite.login)
                .bold()
                .lineLimit(1)
                .font(.title)
                .minimumScaleFactor(0.6)
        }

    }
}

#Preview {
    FavoriteView(favorite: Follower(login: "Test to see a very long name", avatarUrl: ""))
}
