//
//  HomeViewController.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 16.10.2024.
//

import UIKit

class AppController: UIViewController {

    private let viewBuilder = ViewBuilder()
    private let fbManager = FBManager()
    private let noteService = NoteService()
    
    
    var notes: [Note] = []
    lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .white
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    }(UITableView(frame: view.frame, style: .grouped))
    
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(logOut))
        
        
        
        noteService.loadNotes { [weak self] note in
            guard let self = self else { return }
            self.notes = note
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc
    func addNote(){
        let addVC = AddNoteView()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc
    func logOut(){
        fbManager.signOut()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "routeVC"), object: nil, userInfo: ["vc": WindowCase.login])
    }
}

extension AppController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = notes[indexPath.row].heder
        config.secondaryText = notes[indexPath.row].note
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addNote = AddNoteView()
        addNote.note = notes[indexPath.row]
        
        self.navigationController?.pushViewController(addNote, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            noteService.deleteNote(note: note)
        }
    }
}
