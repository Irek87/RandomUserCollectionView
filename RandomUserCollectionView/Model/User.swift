//
//  User.swift
//  RandomUserCollectionView
//
//  Created by Reek i on 05.07.2023.
//

struct UserResponse: Decodable {
    let results: [User]
}

struct User: Decodable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let dob: Dob
    let phone: String
    let picture: Picture
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Location: Decodable {
    let city: String
    let country: String
}

struct Dob: Decodable {
    let age: Int
}

struct Picture: Decodable {
    let large: String
}
