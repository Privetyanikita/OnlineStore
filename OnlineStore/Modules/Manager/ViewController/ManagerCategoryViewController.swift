//
//  ManagerCategoryViewController.swift
//  OnlineStore
//
//  Created by Мария Нестерова on 24.04.2024.
//

import UIKit

class ManagerCategoryViewController: BaseViewController {

    private let flow: ManagerFlow
    private var categoryToChange: Category? {
        didSet {
            setupCategoryToChange()
        }
    }
    private var categories: [Category]?

    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        let navBarTitle: String
        switch flow {
        case .createCategory:
            navBarTitle = Text.createCategory
        case .updateCategory:
            navBarTitle = Text.updateCategory
        default:
            navBarTitle = Text.deleteCategory
        }
       return CustomNavigationBarConfiguration(
        title: navBarTitle,
        withSearchTextField: false,
        isSetupBackButton: true,
        rightButtons: [])
    }
    
    override func loadView() {
        super.loadView()
        let managerCategoryView = ManagerCategoryView(flow: flow)
        managerCategoryView.onSelectImageTap = selectImage
        managerCategoryView.onMainActionButtonTap = handleCategory(category:)
        managerCategoryView.setDelegate = {self}
        view = managerCategoryView
    }
    
    init(flow: ManagerFlow) {
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
        getCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpNavBarButtons()
    }
    
    private func hookUpNavBarButtons() {
        customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupCategoryToChange() {
        if let managerCategoryView = view as? ManagerCategoryView {
            guard let categoryToChange else { return }
            managerCategoryView.setupCategoryToChange(categoryToChange)
        }
    }
    
    private func selectImage() {
        let photoEditVC = PhotoEditViewController()
        photoEditVC.modalPresentationStyle = .overFullScreen
        photoEditVC.onChoiceMade = setupImage(image:)
        present(photoEditVC, animated: true)
    }
    
    private func handleCategory(category: CategoryPost?) {
        if categoryToChange != nil && category?.image == nil && flow != .deleteCategory {
            let alertVC = UIAlertController(title: "Please set an image", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertVC, animated: true)
            return
        }
        
        switch flow {
        case .createCategory:
            createCategory(category: category)
        case .updateCategory:
            if categoryToChange == nil {
                let alertVC = UIAlertController(title: "Please search category to update", message: nil, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertVC, animated: true)
                return
            }
            updateCategory(category: category)
        default:
            if categoryToChange == nil {
                let alertVC = UIAlertController(title: "Please search category to delete", message: nil, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertVC, animated: true)
                return
            }
            deleteCategory()
        }
    }
    
    private func createCategory(category: CategoryPost?) {
        if let category {
            NetworkManager.shared.createCategory(category: category) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result{
                    case .success(let addedCategory):
                        let alertVC = UIAlertController(title: "New category \(addedCategory.name ?? "") successfuly added", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alertVC = UIAlertController(title: "Error adding new category", message: error.localizedDescription, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    }
                }
            }
        }
    }
    
    private func updateCategory(category: CategoryPost?) {
        if let category {
            NetworkManager.shared.changeCategory(id: categoryToChange!.id, category: category) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let changedCategory):
                        let alertVC = UIAlertController(title: "Category \(changedCategory.name ?? "") successfuly updated", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alertVC = UIAlertController(title: "Error updating category", message: error.localizedDescription, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    }
                }
            }
        }
    }
    
    private func deleteCategory() {
        NetworkManager.shared.deleteCategory(id: categoryToChange!.id) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result{
                case .success(let done):
                    if done {
                        let alertVC = UIAlertController(title: "Category successfuly deleted", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    } else {
                        let alertVC = UIAlertController(title: "Error deleting category", message: nil, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                        present(alertVC, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let alertVC = UIAlertController(title: "Error deleting category", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true)}))
                    present(alertVC, animated: true)
                }
            }
        }
    }
    
    private func setupImage(image: UIImage?) {
        if let managerCategoryView = view as? ManagerCategoryView {
            managerCategoryView.setupImage(image: image)
        }
    }
    
    private func getCategories(){
        NetworkManager.shared.fetchCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let dataCategory):
                    categories = dataCategory
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func backButtonTapped() {
        print("Back button tapped")
        dismiss(animated: true)
    }
}

extension ManagerCategoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        guard let categories else { return }
        categories.forEach({
            if $0.name.contains(searchText) {
                self.categoryToChange = $0
            }
        })
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension ManagerCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

}
