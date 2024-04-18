//
//  PhotoEditViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 16.04.2024.
//

import UIKit

class PhotoEditViewController: UIViewController {
    
    var onChoiceMade: ((UIImage?) -> Void)?

    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        let photoEditView = PhotoEditView()
        photoEditView.onTakePhotoTap = takePhoto
        photoEditView.onChooseFileTap = chooseFile
        photoEditView.onDeletePhotoTap = deletePhoto
        view = photoEditView
    }
    
    private func takePhoto() {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: "Device has no camera", message: "Choose photo from library", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true)
        }
        
    }
    
    private func chooseFile() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    private func deletePhoto() {
        onChoiceMade?(nil)
        dismiss(animated: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension PhotoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageName = UUID().uuidString
//        UserStorageManager.shared.updateUserPhoto(photoName: imageName)
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true) {
            self.onChoiceMade?(UIImage(contentsOfFile: self.getDocumentsDirectory().appendingPathComponent(imageName).path))
            self.dismiss(animated: true)
        }
    }
}
