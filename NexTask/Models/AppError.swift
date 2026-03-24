//
//  AppError.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-23.
//

import Foundation

struct AppError: Identifiable {
    let id = UUID()
    let title: String
    let message: String?
}
