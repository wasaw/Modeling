//
//  InputViewController.swift
//  Modeling
//
//  Created by Александр Меренков on 26.03.2024.
//

import UIKit

private enum Constants {
    static let logoViewHeight: CGFloat = 250
    static let logoCornerRadius: CGFloat = 20
    static let horizontalPadding: CGFloat = 10
    static let textFieldTopPadding: CGFloat = 15
    static let textFieldHeight: CGFloat = 60
    static let buttonBottomPadding: CGFloat = 30
    static let buttonHeight: CGFloat = 90
    static let buttonCornerRadius: CGFloat = 16
    static let groupSizeLessConstraint: CGFloat = 40
    static let groupSizeMoreConstraint: CGFloat = 115
}

private enum AnimationsViews {
    case infection
    case duration
    case inputBtn
}

final class InputViewController: UIViewController {
    
// MARK: - Properties
    
    private lazy var logoView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Моделирование"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .white
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(bottom: view.bottomAnchor, paddingBottom: -15)
        view.layer.cornerRadius = Constants.logoCornerRadius
        view.backgroundColor = .logoBackground
        return view
    }()
    private let groupPlaceholder = "Количество людей в группе"
    private let infectionPlaceholder = "Заражение при контакте"
    private let durationplaceholder = "Период пересчета"
    
    private lazy var groupSizeTextField = UITextField.modelingParamenter(placeholder: groupPlaceholder)
    private lazy var infectionFactorTextField = UITextField.modelingParamenter(placeholder: infectionPlaceholder)
    private lazy var durationTextField = UITextField.modelingParamenter(placeholder: durationplaceholder)
    private lazy var inputButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Запустить моделирование", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        btn.addTarget(self, action: #selector(handleInputButton), for: .touchUpInside)
        btn.layer.cornerRadius = Constants.buttonCornerRadius
        btn.backgroundColor = .buttonBackground
        return btn
    }()
    
    private var groupSizeConstrains: NSLayoutConstraint?
        
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureKeyboard()
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardGesture)
        view.backgroundColor = .background
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(logoView)
        logoView.anchor(leading: view.leadingAnchor,
                        top: view.topAnchor,
                        trailing: view.trailingAnchor,
                        height: Constants.logoViewHeight)
        
        view.addSubview(groupSizeTextField)
        groupSizeTextField.delegate = self
        groupSizeTextField.anchor(leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  paddingLeading: Constants.horizontalPadding,
                                  paddingTrailing: -Constants.horizontalPadding,
                                  height: Constants.textFieldHeight)
        groupSizeConstrains = groupSizeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        groupSizeConstrains?.isActive = true
        
        view.addSubview(infectionFactorTextField)
        infectionFactorTextField.delegate = self
        infectionFactorTextField.anchor(leading: view.leadingAnchor,
                                        top: groupSizeTextField.bottomAnchor,
                                        trailing: view.trailingAnchor,
                                        paddingLeading: Constants.horizontalPadding,
                                        paddingTop: Constants.textFieldTopPadding,
                                        paddingTrailing: -Constants.horizontalPadding,
                                        height: Constants.textFieldHeight)
        infectionFactorTextField.layer.opacity = 0
        
        view.addSubview(durationTextField)
        durationTextField.delegate = self
        durationTextField.anchor(leading: view.leadingAnchor,
                                 top: infectionFactorTextField.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 paddingLeading: Constants.horizontalPadding,
                                 paddingTop: Constants.textFieldTopPadding,
                                 paddingTrailing: -Constants.horizontalPadding,
                                 height: Constants.textFieldHeight)
        durationTextField.layer.opacity = 0
        
        view.addSubview(inputButton)
        inputButton.anchor(leading: view.leadingAnchor, 
                           trailing: view.trailingAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           paddingLeading: Constants.horizontalPadding,
                           paddingTrailing: -Constants.horizontalPadding,
                           paddingBottom: -Constants.buttonBottomPadding,
                           height: Constants.buttonHeight)
        inputButton.layer.opacity = 0
    }
    
    private func configureKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        groupSizeTextField.inputAccessoryView = toolBar
        infectionFactorTextField.inputAccessoryView = toolBar
        durationTextField.inputAccessoryView = toolBar
    }
    
    private func animation(for element: AnimationsViews) {
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.view.layoutIfNeeded()
            
            switch element {
            case .infection:
                self?.infectionFactorTextField.layer.opacity = 1
            case .duration:
                self?.durationTextField.layer.opacity = 1
            case .inputBtn:
                self?.inputButton.layer.opacity = 1
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Внимание", message: "Все введенные значения должны быть целыми числами", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
// MARK: - Selectors
    
    @objc private func dismissKeyboard() {
        groupSizeConstrains?.constant = 0
        view.endEditing(true)
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleInputButton() {
        guard let groupText = groupSizeTextField.text,
              let group = Int(groupText),
              let infectionText = infectionFactorTextField.text,
              let infection = Int(infectionText),
              let durationText = durationTextField.text,
              let duration = Int(durationText) else {
            showAlert()
            return
        }
        
        navigationController?.pushViewController(InfectedViewController(groupSize: group,
                                                                        infectionFactor: infection,
                                                                        timeInterval: duration), animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension InputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let placeholder = textField.placeholder else { return }

        switch placeholder {
        case groupPlaceholder:
            groupSizeConstrains?.constant = -Constants.groupSizeLessConstraint
            animation(for: .infection)
        case infectionPlaceholder:
            groupSizeConstrains?.constant = -Constants.groupSizeMoreConstraint
            animation(for: .duration)
        case durationplaceholder:
            groupSizeConstrains?.constant = -Constants.groupSizeMoreConstraint
            animation(for: .inputBtn)
        default:
            break
        }
    }
}
