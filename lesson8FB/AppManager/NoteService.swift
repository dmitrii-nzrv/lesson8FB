//
//  NoteService.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 25.10.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage


class NoteService{
    
    func createNote(note: Note, image: Data?, completion: @escaping (Result<Bool, Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let noteID = UUID().uuidString
 
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("notes")
            .document(noteID)
            .setData(["header" : note.heder, "note": note.note]) { [weak self] _ in
                guard let self = self else { return }
                guard let image else {
                    completion(.success(true))
                    return
                }
                
                
                let storage = Storage.storage()
                    .reference()
                    .child("notes")
                    .child(uid)
                    .child("\(UUID().uuidString).jpg")
            
                self.oneImageLoad(image, storage) { result in
                    switch result {
                    case .success(let url):
                        //3 если файл загружен получить ссылку
                        let photoURL = url.absoluteString
                        
                        Firestore.firestore()
                            .collection("users")
                            .document(uid)
                            .collection("notes")
                            .document(noteID)
                            .setData(["photo": photoURL], merge: true)
                        
                        completion(.success(true))
                        
                    case .failure(let failure):
                        print(failure)
                        completion(.failure(failure))
                    }
                }
        }
    }
 
    private func oneImageLoad(_ image: Data?, _ storage: StorageReference, _ completion: @escaping (Result<URL, Error>) ->()){
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        guard let imageData = image else { return }
        
        DispatchQueue.main.async {
            storage.putData(imageData, metadata: metadata) { meta, err in
                guard let _ = meta else {
                    completion(.failure(err!))
                    return
                }
                
                storage.downloadURL { url, err in
                    guard let url = url else {
                        completion(.failure(err!))
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    func loadNotes(completion: @escaping ([Note]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("notes")
            .getDocuments { snap, err in
                var notes = [Note]()
                if let data = snap?.documents {
                    data.forEach { doc in
                        let id = doc.documentID
                        print(id)
                        let header = doc["header"] as? String
                        let note = doc["note"] as? String
                        let image = doc["photo"] as? String
                        
                        let noteItem = Note(id: id, heder: header ?? "", note: note ?? "", image: image)
                        notes.append(noteItem)
                    }
                    completion(notes)
            }
        }
    }
    
    func updateNote(note: Note, completion: @escaping (Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("notes")
            .document(note.id)
            .updateData(["header": note.heder, "note": note.note]) { _ in
                completion(true)
            }
        
    }
    
    
    func deleteNote(note: Note){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("notes")
            .document(note.id)
            .delete()
    }
    
}
