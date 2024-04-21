//
//  SingUpViewController.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import UIKit
import Route


enum CellType {
    case userName
    case emailAddress
    case password
    case confirmPassword
}

struct State {
    let cells: [CellType]
}

public func classFromString(_ className: String) -> AnyClass! {
    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!
    return cls
}


final class SingUpViewController: BaseViewController {

    enum TextFieldData: Int {
        case nameTextField = 0
        case emailTextField
        case passwordTextField
        case repeatPasswordTextField
    }
    
    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    private let headerLabel = UILabel()
    private let tableView   = UITableView()
    private let signUpButton  = FBButton(color: Color.customGreen ?? .systemGreen, title: Text.signUp, systemImageName: "")
    
    private lazy var typeOfAccountButton: UIButton = {
        let button = UIButton()
        button.configuration                             = .tinted()
        button.configuration?.baseForegroundColor        = .systemGray
        button.configuration?.baseBackgroundColor        = .systemGray
        button.configuration?.cornerStyle                = .capsule
        button.configuration?.title                      = Text.typeOfAccount
        button.configuration?.titleAlignment             = .leading
        button.configuration?.image                      = Image.angleRight
        button.configuration?.imagePlacement             = .trailing
        button.configuration?.imagePadding               = view.bounds.width * 0.35
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let alreadyHaveAnAccountLabel: UILabel = {
        let label       = UILabel()
        label.text      = Text.alreadyHaveAnAccount
        label.textColor = .systemGray
        
        return label
    }()
    
    private let logInButton: UIButton = {
        let button                  = UIButton()
        button.configuration        = .plain()
        button.configuration?.title = Text.login
        button.configuration?.baseForegroundColor = Color.customPurple
        
        return button
    }()
    
    private let bottomHorizontalStack: UIStackView = {
        let stack = UIStackView()
        
        return stack
    }()
    
    private var profileUser = ProfileUser(name: "", mail: "", password: "", repeatPassword: "", photo: nil)
    private let state: State
    
    
    init(state: State) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }
    
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.signUp,
        withSearchTextField: false,
        withLocationView: false,
        isSetupBackButton: false,
        rightButtons: [])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureViewController()
        dismissKeyboardTapGesture()
    }

    
    private func dismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(1)
            make.leading.trailing.bottom.equalToSuperview()
        })
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalToSuperview()
        }
    }
    
    
    private func  configureViewController() {
        view.backgroundColor = .systemBackground
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(typeOfAccountButton)
        contentView.addSubview(signUpButton)
        contentView.addSubview(bottomHorizontalStack)
        bottomHorizontalStack.addArrangedSubview(alreadyHaveAnAccountLabel)
        bottomHorizontalStack.addArrangedSubview(logInButton)
        
        configureHeaderLabel()
        configureTableView()
        addTarget()
        setupConstraints()
    }
    
    
    private func  configureHeaderLabel() {
        headerLabel.font = Font.getFont(.semiBold, size: 24)
        headerLabel.text = Text.completeYourAccount
    }

    
    private func configureTableView() {
        tableView.rowHeight         = 82
        tableView.separatorStyle    = .none
        tableView.dataSource        = self
        tableView.isScrollEnabled   = false
        
        let cells = [
            "UserNameCell",
            "EmailAddressCell",
            "PasswordCell",
            "ConfirmPasswordCell"
        ]
        
        for cell in cells {
            tableView.register(classFromString(cell).self, forCellReuseIdentifier: cell)
        }
    }
    
    
    private func addTarget() {
        signUpButton.addTarget(self, action: #selector(signUpTapped(_:)), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logInTapped(_:)), for: .touchUpInside)
        typeOfAccountButton.addTarget(self, action: #selector(typeOfAccountTapped(_:)), for: .touchUpInside)
    }
    
    
    private func setupConstraints() {

        let padding: CGFloat = 20
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(330)
        }
        
        typeOfAccountButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(52)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(typeOfAccountButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(52)
        }
        
        bottomHorizontalStack.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(54)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    
    @objc private func textfieldValueChanged(_ textField: UITextField){
        
        guard let text = textField.text else { return }
        switch textField.tag {
            
        case TextFieldData.nameTextField.rawValue:
            profileUser.name = text
            print("Name: \(text)")
            
        case TextFieldData.emailTextField.rawValue:
            profileUser.mail = text
            print("E-mail: \(text)")
            
        case TextFieldData.passwordTextField.rawValue:
            profileUser.password = text
            print("Password: \(text)")
            
        case TextFieldData.repeatPasswordTextField.rawValue:
            profileUser.repeatPassword = text
            print("Repeat password: \(text)")
            
        default:
            break
        }
    }
    
    
    @objc func signUpTapped(_ sender: UIButton) {
        self.showLoadingView()
        let email = profileUser.mail
        let password = profileUser.password
        let repeatPassword = profileUser.repeatPassword
        
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found!")
            self.dismissLoadingView()
            return
        }
        
        guard password == repeatPassword else {
            print("You should confirm password!")
            self.dismissLoadingView()
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print(">> SUCCESS!")
                guard let email = returnedUserData.email else { return }
                let homeViewController = CustomTabBar()
                router.replace(with: homeViewController)
            } catch {
                print("Error: \(error)")
            }
            self.dismissLoadingView()
        }
    }
    
    
    @objc func logInTapped(_ sender: UIButton) {
        let loginViewController = LogInViewController(state: State(cells: [.emailAddress, .password]))
        router.replace(with: loginViewController)
    }
    
    
    @objc func typeOfAccountTapped(_ sender: UIButton) {
        print(">> Go to TYPE OF ACCOUNT flow")
    }
    
    
    deinit {
        print(">> deinit from SingUpViewController")
    }
}


extension SingUpViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.cells.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state.cells[indexPath.row] {
        case .userName:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserNameCell") as? UserNameCell else {
                return UITableViewCell()
            }
            cell.textField.tag      = indexPath.row
            cell.textField.delegate = self
            return cell
            
        case .emailAddress:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmailAddressCell") as? EmailAddressCell else {
                return UITableViewCell()
            }
            cell.textField.tag      = indexPath.row
            cell.textField.delegate = self
            return cell
            
        case .password:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell") as? PasswordCell else {
                return UITableViewCell()
            }
            cell.textField.tag      = indexPath.row
            cell.textField.delegate = self
            return cell
            
        case .confirmPassword:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmPasswordCell") as? ConfirmPasswordCell else {
                return UITableViewCell()
            }
            cell.textField.tag      = indexPath.row
            cell.textField.delegate = self
            return cell
        }
    }
}


extension SingUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textfieldValueChanged), for: .editingChanged)
    }
    
}
