//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let container: PersistentContainer
    private var diaryList: [DiaryEntity] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(container: PersistentContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDiary()
        configureNavigation()
        configureBackgroundColor()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadDiary()
    }
    
    private func loadDiary() {
        do {
            diaryList = try container.viewContext.fetch(DiaryEntity.fetchRequest())
            tableView.reloadData()
        } catch {
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(closeAction)
            self.present(alert, animated: true)
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = String(localized: "DiaryListNavigationTitle")
        
        let action = UIAction { _ in
            self.addDiary()
        }
        let barButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func addDiary(indexPath: IndexPath? = nil) {
        let diaryViewController = DiaryViewController(container: container, indexPath: indexPath)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        configureTableViewConstraint()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.identifier,
            for: indexPath
        ) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        let diary = diaryList[indexPath.row]
        cell.configureContents(diary: diary)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diary = diaryList[indexPath.row]
        let diaryViewController = DiaryViewController(diary: diary, container: container, indexPath: indexPath)
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let diary = diaryList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complitionHandler in
            self.diaryList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.container.viewContext.delete(diary)
            self.container.saveContext()
            complitionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
}
