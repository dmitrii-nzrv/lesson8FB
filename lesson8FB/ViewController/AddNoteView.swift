
//  AddNotesView.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 25.10.2024.
//

import UIKit


class AddNoteView: UIViewController {

    private let noteService: NoteService = NoteService()
    private var viewBuilder = ViewBuilder()
    var note: Note?
    var image: UIImage?
        
    lazy var noteHeader = viewBuilder.createTextField(frame: CGRect(x: 30, y: 160, width: view.frame.width - 60, height: 75), placeholder: "Header")
    
    lazy var noteText: UITextView = {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 10
        return $0
    }(UITextView(frame: CGRect(x: 30, y: noteHeader.frame.maxY + 60, width: view.frame.width - 60, height: 150)))
    
    lazy var imagePicker: UIImagePickerController = {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        $0.delegate = self
        return $0
    }(UIImagePickerController())
    
    lazy var imageView: UIImageView = {
        $0.frame.size = CGSize(width: 150, height: 150)
        $0.frame.origin.x = (view.frame.width - 150) / 2
        $0.frame.origin.y = noteText.frame.maxY + 100
        $0.backgroundColor = .gray
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        return $0
    }(UIImageView())
    
    @objc
    func imageTapped() {
        present(imagePicker, animated: true)
    }
    
    lazy var saveBtn = viewBuilder.ctreateButton(frame: CGRect(x: 30, y: view.frame.height - 100, width: view.frame.width - 60, height: 50), action: saveAction, title: note != nil ? "update" : "save", isMainBtn: true)
    
    lazy var saveAction = UIAction {[weak self] _ in
        guard let self = self else { return }
        
        
        
        if self.note == nil {
            let note = Note(heder: noteHeader.text ?? "", note: noteText.text ?? "", image: nil)
            if image != nil {
                let imageData = image?.jpegData(compressionQuality: 0.5)
                noteService.createNote(note: note, image: imageData) { isAdd in
                    switch isAdd {
                    case .success(let success):
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            } else {
                noteService.createNote(note: note, image: nil){ isAdd in
                    switch isAdd {
                    case .success(let success):
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        } else {
            let note = Note(id: note!.id, heder: noteHeader.text ?? "", note: noteText.text ?? "", image: nil)
            noteService.updateNote(note: note) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Add note"
        
        view.addSubview(noteHeader)
        view.addSubview(noteText)
        view.addSubview(imageView)
        view.addSubview(saveBtn)
        
        
        noteHeader.text = note?.heder
        noteText.text = note?.note
        
        
        if note != nil,
            let url = note?.image,
            let urlToImage = URL(string: url) {
            imageView.load(url: urlToImage)
        }
    }

}

extension AddNoteView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            self.imageView.image = image
            self.image = image
        }
        picker.dismiss(animated: true)
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

