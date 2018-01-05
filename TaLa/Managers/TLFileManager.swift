//
//  FileManager.swift
//  TaLa
//
//  Created by huydoquang on 12/24/17.
//  Copyright © 2017 huydoquang. All rights reserved.
//

import UIKit

protocol TLFileManagerInterface {
    func addImage(with image: UIImage, and name: String) -> URL?
    func removeFile(at url: URL) -> Bool
    func replaceFile(at url: URL, with image: UIImage) -> URL?
    func checkFileExisted(at url: URL) -> Bool
}

class TLFileManager: TLFileManagerInterface {
    static let shared = TLFileManager()
    
    private var defaultImagesFolder: URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent(Constants.Folder.defaultImagesFolderName)
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            return dataPath
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
            return nil
        }
    }

    func addImage(with image: UIImage, and name: String = "\(Date().timeIntervalSince1970)") -> URL? {
        guard let fileURL = self.defaultImagesFolder?.appendingPathComponent(name), let data = UIImagePNGRepresentation(image) else { return nil }
        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch let error as NSError {
            print("Error creating file image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func removeFile(at url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch let error as NSError {
            print("Error delete file: \(error.localizedDescription)")
            return false
        }
    }
    
    func replaceFile(at url: URL, with image: UIImage) -> URL? {
        let desURL = url.deletingLastPathComponent().appendingPathComponent("\(Date().timeIntervalSince1970)")
        do {
            try FileManager.default.moveItem(at: url, to: desURL)
            return desURL
        } catch let error as NSError {
            print("Error move file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func checkFileExisted(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
