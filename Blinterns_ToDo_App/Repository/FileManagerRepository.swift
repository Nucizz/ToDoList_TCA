//
//  FileManagerRepository.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import Foundation
import UIKit
import Dependencies

struct FileManagerRepository: DependencyKey {
    
    var saveImage: (UIImage) throws -> String
    var loadImage: (String) throws -> Data
    var deleteImage: (String) throws -> Void
    
    static private var imageCache = NSCache<NSString, NSData>()
    
}

extension FileManagerRepository{
    static var liveValue: FileManagerRepository {
        return Self(
            saveImage: { image in
                guard let data = image.jpegData(compressionQuality: 0.5) else {
                    throw CsError.FileManagerError.imageCompressionFailure
                }
                
                do {
                    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                        throw CsError.FileManagerError.invalidApplicationURL
                    }
                    
                    let fileName = String(Date.now.timeIntervalSince1970)
                    
                    guard let path = directory.appendingPathComponent(fileName) else {
                        throw CsError.FileManagerError.pathFailure
                    }
                    
                    try data.write(to: path)
                    return fileName
                } catch {
                    throw error
                }

            },
            loadImage: { fileName in
                if let cachedImage = imageCache.object(forKey: fileName as NSString) {
                    return cachedImage as Data
                }
                
                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                    throw CsError.FileManagerError.invalidApplicationURL
                }
                
                let fileURL = directory.appendingPathComponent(fileName)
                
                guard FileManager.default.fileExists(atPath: fileURL.path) else {
                    throw CsError.FileManagerError.imageNotFound
                }
                
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    imageCache.setObject(imageData as NSData, forKey: fileName as NSString)
                    return imageData
                } catch {
                    throw error
                }
            },
            deleteImage: { fileName in
                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                    throw CsError.FileManagerError.invalidApplicationURL
                }
                
                let fileURL = directory.appendingPathComponent(fileName)
                
                guard FileManager.default.fileExists(atPath: fileURL.path) else {
                    throw CsError.FileManagerError.imageNotFound
                }
                
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    imageCache.removeObject(forKey: fileName as NSString)
                } catch {
                    throw error
                }
            }
        )
    }
}

extension DependencyValues {
    var fileManagerRepository: FileManagerRepository {
        get { self[FileManagerRepository.self] }
        set { self[FileManagerRepository.self] = newValue }
    }
}
