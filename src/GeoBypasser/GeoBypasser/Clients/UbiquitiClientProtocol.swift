//
//  UbiquitiClientProtocol.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 26.06.2021.
//

protocol UbiquitiClientProtocol {
    func show(key: String) throws -> String
    func delete(key: String) throws
    func set(key: String) throws
    func beginSession() throws
    func endSession() throws
    func commit() throws
    func save() throws
}
