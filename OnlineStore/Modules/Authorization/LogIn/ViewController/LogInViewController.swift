//
//  LogIn.swift
//  OnlineStore
//
//  Created by NikitaKorniuk   on 16.04.24.
//

import UIKit
import Route

final class LogInViewController: BaseViewController {
    
    enum TextFieldData: Int {
        case emailTextField = 0
        case passwordTextField
    }

    private let tableView     = UITableView()

    private let forgotYourPasswordButton: UIButton = {
        let button                  = UIButton()
        button.configuration        = .plain()
        button.configuration?.title = Text.forgotYourPassword
        button.configuration?.baseForegroundColor = Color.customPurple

        return button
    }()

    private let signInButton  = FBButton(color: Color.customGreen ?? .systemGreen, title: Text.signIn, systemImageName: "")
    private var profileUser = ProfileUser(name: "", mail: "", password: "", repeatPassword: "", photo: nil)
    private let state: State

    private let dontHaveAnAccountLabel: UILabel = {
        let label       = UILabel()
        label.text      = Text.dontHaveAnAccount
        label.textColor = .systemGray

        return label
    }()

    private let registerButton: UIButton = {
        let button                  = UIButton()
        button.configuration        = .plain()
        button.configuration?.title = Text.register
        button.configuration?.baseForegroundColor = Color.customGreen

        return button
    }()

    private let bottomVerticalStack: UIStackView = {
        let stack       = UIStackView()
        stack.axis      = .vertical
        stack.spacing   = 0

        return stack
    }()

    init(state: State) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        NSCoder.fatalErrorNotImplemented()
    }

    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: Text.signIn,
        withSearchTextField: false,
        withLocationView: false,
        isSetupBackButton: false,
        rightButtons: [])
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        dismissKeyboardTapGesture()
    }


    private func dismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }


    private func  configureViewController() {
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        view.addSubview(forgotYourPasswordButton)
        view.addSubview(signInButton)
        view.addSubview(bottomVerticalStack)
        bottomVerticalStack.addArrangedSubview(dontHaveAnAccountLabel)
        bottomVerticalStack.addArrangedSubview(registerButton)

        configureTableView()
        addTarget()
        setupConstraints()
    }


    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight         = 82
        tableView.separatorStyle    = .none
        tableView.dataSource        = self
        tableView.isScrollEnabled   = false

        let cells = [
            "EmailAddressCell",
            "PasswordCell",
        ]

        for cell in cells {
            tableView.register(classFromString(cell).self, forCellReuseIdentifier: cell)
        }
    }


    private func setupConstraints() {

        let padding: CGFloat = 20

        tableView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(1)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(180)
        }

        forgotYourPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.centerX.equalToSuperview()
        }

        bottomVerticalStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        signInButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(52)
            make.bottom.equalTo(bottomVerticalStack.snp.top).offset(-30)
        }
    }


    private func addTarget() {
        signInButton.addTarget(self, action: #selector(signInTapped(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped(_:)), for: .touchUpInside)
        forgotYourPasswordButton.addTarget(self, action: #selector(forgotYourPasswordTapped(_:)), for: .touchUpInside)
    }


    @objc private func forgotYourPasswordTapped(_ sender: UIButton) {
        print(">> Go to FORGOT PASSWORD flow")
    }


    @objc private func signInTapped(_ sender: UIButton) {
        self.showLoadingView()
        guard !profileUser.mail.isEmpty, !profileUser.password.isEmpty else {
            print("No email or password found!")
            self.dismissLoadingView()
            return
        }

        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signInUser(email: profileUser.mail, password: profileUser.password)
                guard let email = returnedUserData.email else { return }
                print(">> Go to MAIN flow")
                let homeViewController = CustomTabBar()
                router.replace(with: homeViewController)
            } catch {
                print("Error: \(error)")
            }
            self.dismissLoadingView()
        }
    }


    @objc private func registerTapped(_ sender: UIButton) {
        print(">> Go to REGISTER flow")
        let registerViewController = SingUpViewController(state: State(cells: [.userName, .emailAddress, .password, .confirmPassword]))
        router.replace(with: registerViewController)
    }


    @objc private func textfieldValueChanged(_ textField: UITextField){

        guard let text = textField.text else { return }
        switch textField.tag {

        case TextFieldData.emailTextField.rawValue:
            profileUser.mail = text
            print("E-mail: \(text)")

        case TextFieldData.passwordTextField.rawValue:
            profileUser.password = text
            print("Password: \(text)")

        default:
            break
        }
    }


    deinit {
        print(">> deinit from LogInViewController")
    }
}


extension LogInViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.cells.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state.cells[indexPath.row] {

        case .userName:
            break

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
            break
        }
        return UITableViewCell()
    }
}


extension LogInViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textfieldValueChanged), for: .editingChanged)
    }

}
