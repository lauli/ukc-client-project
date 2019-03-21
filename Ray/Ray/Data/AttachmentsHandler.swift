//
//  AttachmentsHandler.swift
//  Ray
//
//  Created by Laureen Schausberger on 03.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import MobileCoreServices
import Photos
import UIKit

final class AttachmentsHandler: NSObject {
    
    static let shared = AttachmentsHandler()
    fileprivate var currentVC: UIViewController?
    
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    func showActionSheet(currentVC: UIViewController) {
        self.currentVC = currentVC
        
        let actionSheet = UIAlertController(title: "Add a Picture or Video", message: "Please select if you want to make your own picture/video, or if you want to upload an existing one", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        currentVC.present(actionSheet, animated: true, completion: nil)
    }
    
    private func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        if attachmentTypeEnum == .camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch status{
            case .authorized: // The user has previously granted access to the camera.
                self.openCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
                
            case .denied, .restricted:
                //denied - The user has previously denied access.
                //restricted - The user can't grant access due to restrictions.
                // TODO: addAlertForSettings(attachmentTypeEnum)
                return
                
            default:
                break
            }
            
        } else if attachmentTypeEnum == .photoLibrary || attachmentTypeEnum == .video{
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status{
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary{
                    photoLibrary()
                }
                
                if attachmentTypeEnum == AttachmentType.video{
                    videoLibrary()
                }
                
            case .denied, .restricted:
                // TODO: addAlertForSettings(attachmentTypeEnum)
                break
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        // photo library access given
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                })
                
            default:
                break
            }
        }
    }
    
    private func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }

    
}

extension AttachmentsHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // To handle image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else{
            print("Something went wrong in  image")
        }
        // To handle video
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            self.videoPickedBlock?(videoUrl)
        }
        else{
            print("Something went wrong in  video")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    
}

enum AttachmentType: String{
    case camera, video, photoLibrary
}
