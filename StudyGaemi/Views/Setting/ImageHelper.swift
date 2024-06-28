//
//  ImageHelper.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/28/24.
//

import UIKit

import UIKit

class ImageHelper {
    
    static func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    static func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
