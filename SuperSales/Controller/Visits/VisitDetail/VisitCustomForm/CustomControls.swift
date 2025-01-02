import UIKit

enum TextFieldType {
    case normal
    case decimal
    case phone
    case email
    case date
    case search
}

protocol CustomSearchBarDelegate: AnyObject {
    func onSearch()
}

class CustomTextFieldView: UIView, UITextFieldDelegate {
    var quesId = 0
    // Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppFontName.bold, size: 15)
        label.textColor = .gray
        return label
    }()
    
    // Text field
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont(name: AppFontName.regular, size: 14)
        textField.textColor = .black
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        return textField
    }()
    
    // Bottom border view
    private let bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    // Date picker
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.addTarget(self, action: #selector(doneButtonTapped), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private let textFieldType: TextFieldType
    private var characterLimit = 10
    weak var delegate: CustomSearchBarDelegate? // Optional delegate for communication

    required init?(coder: NSCoder) {
        self.textFieldType = .normal
        super.init(coder: coder)
        setupView()
    }
    
    init(title: String, placeholder: String, textFieldType: TextFieldType = .normal) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        titleLabel.text = title
        textField.placeholder = placeholder
        textField.delegate = self  // Set the delegate
        setupView()
        if textFieldType == .date {
            setupDatePicker()
        }else if textFieldType == .search {
            setupRightView()
            disableKeyboard()
        }
        setupCharLimit()
    }
    
    private func setupView() {
        // Add subviews
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(bottomBorder)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Text field constraints
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            // Bottom border constraints
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            
            // Ensure the bottom of the view is the bottom of the border
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupDatePicker() {
//        // Add done button to toolbar
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
//        toolbar.setItems([doneButton], animated: false)
        
        // Set the date picker as the input view for the text field
        textField.inputView = datePicker
//        textField.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        textField.text = dateFormatter.string(from: datePicker.date)
    }
    
    private func setupCharLimit() {
        switch textFieldType {
        case .normal:
            characterLimit = 30
            textField.keyboardType = .default
        case .decimal:
            characterLimit = 7
            textField.keyboardType = .decimalPad
        case .email:
            characterLimit = 30
            textField.keyboardType = .emailAddress
        case .phone:
            characterLimit = 10
            textField.keyboardType = .numberPad
        case .date:
            textField.keyboardType = .default
        case .search:
            textField.keyboardType = .default
        }
    }
    
    private func setupRightView() {
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        textField.rightView = searchButton
        textField.rightViewMode = .always
    }

    @objc private func searchButtonClicked() {
        // Handle the search button click event here
        delegate?.onSearch()
    }

    private func disableKeyboard() {
        textField.inputView = UIView() // Assign an empty UIView as inputView to prevent the keyboard from opening
    }
    
    // UITextFieldDelegate method to restrict pincode input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= characterLimit
    }
    
    // Optionally, override `canBecomeFirstResponder` to always return false
    override var canBecomeFirstResponder: Bool {
        return textFieldType == .search ? false : true
    }
    
}

class CustomRadioButtonView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        return stackView
    }()

    // Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Bold", size: 15) // Replace with AppFontName.bold if defined
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(titleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func addRadioButton(_ title: String) {
        let radioButton = createRadioButton(title: title)
        stackView.addArrangedSubview(radioButton)
    }

    private func createRadioButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.setTitle(" \(title)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.backgroundColor = .clear
        
        // Set the custom images for the radio button
        let unselectedImage = UIImage(named: "icon_radio_unselected")
        let selectedImage = UIImage(named: "icon_radio_selected")
        button.setImage(unselectedImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        
        // Align the image and title
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }

    @IBAction
    private func radioButtonTapped(_ sender: UIButton) {
        for case let button as UIButton in stackView.arrangedSubviews {
            button.isSelected = false
        }
        sender.isSelected = true
    }
}

class CustomImagePickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        return stackView
    }()

    // Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .gray
        label.text = "Picture"
        return label
    }()

    // Add Picture button
    private let addPictureButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "Add Picture", attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.blue
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(addPictureTapped), for: .touchUpInside)
        return button
    }()
    
    private var images: [UIImage] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private var heightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addPictureButton)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20) // Add space below collection view
        ])

        // Initial height constraint
        heightConstraint = heightAnchor.constraint(equalToConstant: 60) // Set initial height to 60
        heightConstraint.isActive = true
    }

    @objc private func addPictureTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        UIApplication.shared.windows.first?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            images.append(selectedImage)
            collectionView.isHidden = images.isEmpty
            collectionView.reloadData()
            updateViewHeight()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = images[indexPath.item]
        cell.deleteAction = { [weak self] in
            self?.images.remove(at: indexPath.item)
            collectionView.reloadData()
            self?.updateViewHeight()
        }
        return cell
    }

    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let padding: CGFloat = 8 * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - padding
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func updateViewHeight() {
        let rows = ceil(CGFloat(images.count) / 3.0)
        let itemHeight: CGFloat = (collectionView.frame.width - 16) / 3 // Adjust this to match sizeForItemAt if necessary
        let newHeight = rows * itemHeight + (rows - 1) * 8 + 60 + 20 // 60 for the stackView height (title + button), 20 for the bottom space
        
        heightConstraint.constant = newHeight
        layoutIfNeeded()
    }
}

class ImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5 // Set corner radius to 5
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("✕", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    
    var deleteAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)

        deleteButton.sendSubviewToBack(contentView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func deleteTapped() {
        deleteAction?()
    }
}

class CheckboxGroupView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    init(title: String, options: [String]) {
        super.init(frame: .zero)
        setupView(title: title, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(title: "", options: [])
    }
    
    private func setupView(title: String, options: [String]) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: AppFontName.bold, size: 15)
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for option in options {
            let checkbox = createCheckbox(option: option)
            stackView.addArrangedSubview(checkbox)
        }
    }
    
    private func createCheckbox(option: String) -> UIView {
        let checkbox = UIButton(type: .custom)
        checkbox.setTitle(" \(option)", for: .normal)
        checkbox.setTitleColor(.black, for: .normal)
        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkbox.addTarget(self, action: #selector(toggleCheckbox(_:)), for: .touchUpInside)
        checkbox.contentHorizontalAlignment = .left
        checkbox.tintColor = .systemBlue // Set the tint color for the selected state
        return checkbox
    }
    
    @IBAction
    private func toggleCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

class CustomSwitchView: UIView {

    // Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Custom Switch (UIButton)
    private let customSwitch: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_switch_unselected"), for: .normal)
        button.setImage(UIImage(named: "icon_switch_selected"), for: .selected)
        button.addTarget(self, action: #selector(switchTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Add subviews
        addSubview(titleLabel)
        addSubview(customSwitch)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Switch constraints
            customSwitch.trailingAnchor.constraint(equalTo: trailingAnchor),
            customSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Fixed size constraints
            self.widthAnchor.constraint(equalToConstant: 200),  // Set your desired width here
            self.heightAnchor.constraint(equalToConstant: 50)   // Set your desired height here
        ])
    }
    
    // Switch event handler
    @objc private func switchTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            print("Switch is ON")
        } else {
            print("Switch is OFF")
        }
    }
}

import UIKit
import DropDown

struct DropdownOption {
    let id: Int
    let value: String
}

class DropDownCustomView: UIView, UITextFieldDelegate {

    let dropDown1 = DropDown()
    let dropDown2 = DropDown()
    let textField1 = UITextField()
    let textField2 = UITextField()

    var isSecondDropDownEnabled: Bool = true
    var options1: [DropdownOption] = []
    var dependentOptions: [Int: [DropdownOption]] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with options1: [DropdownOption], dependentOptions: [Int: [DropdownOption]], enableSecondDropDown: Bool = true) {
        self.options1 = options1
        self.dependentOptions = dependentOptions
        isSecondDropDownEnabled = enableSecondDropDown
        if !enableSecondDropDown {
            textField2.isHidden = true
        }
        dropDown1.dataSource = options1.map { $0.value }
        
        dropDown1.selectionAction = { [weak self] (index: Int, item: String) in
            self?.textField1.text = item
            if let selectedOption = options1[safe: index] {
                self?.updateDropDown2(for: selectedOption.id)
            }
        }

        dropDown2.selectionAction = { [weak self] (index: Int, item: String) in
            self?.textField2.text = item
        }
    }

    private func setupView() {
        textField1.placeholder = "Select an option"
        textField2.placeholder = "Select a dependent option"

        textField1.borderStyle = .roundedRect
        textField2.borderStyle = .roundedRect

        textField1.translatesAutoresizingMaskIntoConstraints = false
        textField2.translatesAutoresizingMaskIntoConstraints = false

        textField1.delegate = self
        textField2.delegate = self

        self.addSubview(textField1)
        self.addSubview(textField2)

        NSLayoutConstraint.activate([
            textField1.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textField1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),

            textField2.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 10),
            textField2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textField2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])

        textField1.addTarget(self, action: #selector(textField1DidChange), for: .editingChanged)
        textField2.addTarget(self, action: #selector(textField2DidChange), for: .editingChanged)

        dropDown1.anchorView = textField1
        dropDown2.anchorView = textField2
    }

    @objc func textField1DidChange() {
        filterDropDown1()
    }

    @objc func textField2DidChange() {
        filterDropDown2()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textField1 {
            filterDropDown1()
            dropDown1.show()
        } else if textField == textField2 {
            filterDropDown2()
            dropDown2.show()
        }
    }

    func updateDropDown2(for selectedOptionId: Int) {
        dropDown2.dataSource = dependentOptions[selectedOptionId]?.map { $0.value } ?? []
    }

    private func filterDropDown1() {
        let text = textField1.text ?? ""
        dropDown1.dataSource = options1.map { $0.value }.filter { $0.lowercased().contains(text.lowercased()) }
    }

    private func filterDropDown2() {
        guard let textField1Text = textField1.text,
              let selectedOption = options1.first(where: { $0.value == textField1Text }),
              let options = dependentOptions[selectedOption.id] else { return }

        let text = textField2.text ?? ""
        dropDown2.dataSource = options.map { $0.value }.filter { $0.lowercased().contains(text.lowercased()) }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



/*
import UIKit

class CustomSearchBar: UIView {

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Customer Name" // Adjust placeholder text as needed
        textField.borderStyle = .roundedRect // Adjust border style as needed
        textField.font = UIFont.systemFont(ofSize: 14) // Adjust font size as needed
        return textField
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(CustomSearchBar.self, action: #selector(onSearchButtonClicked), for: .touchUpInside)
        return button
    }()

    weak var delegate: CustomSearchBarDelegate? // Optional delegate for communication

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        addSubview(textField)
        addSubview(searchButton)

        // Constrain subviews (replace with your preferred layout)
        textField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            textField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),

            searchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            searchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            searchButton.widthAnchor.constraint(equalToConstant: 32) // Adjust button width as needed
        ])
    }

    @IBAction
    private func onSearchButtonClicked(_ sender: UIButton) {
        textField.resignFirstResponder() // Dismiss keyboard before opening new controller

        // Handle search action here
        // You might trigger a search process, display a search view controller, etc.

        if let delegate = delegate {
            delegate.onSearch(text: textField.text ?? "") // Optional delegate communication
        } else {
            // Implement default search behavior if no delegate is set
            print("Search triggered: \(textField.text ?? "")")
        }
    }
}

protocol CustomSearchBarDelegate: AnyObject {
    func onSearch(text: String)
}

import UIKit

class AddressFormView: UIView, UITextFieldDelegate {
    
    private let addressLine1TextField = UITextField()
    private let addressLine2TextField = UITextField()
    
    private let cityLabel = UILabel()
    private let cityTextField = UITextField()
    
    private let stateLabel = UILabel()
    private let stateTextField = UITextField()
    
    private let pincodeLabel = UILabel()
    private let pincodeTextField = UITextField()
    
    private let countryLabel = UILabel()
    private let countryTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Setup TextFields with Placeholders for Address Lines
        addressLine1TextField.placeholder = "Address Line 1"
        addressLine2TextField.placeholder = "Address Line 2"
        
        // Setup Labels for Other Fields
        cityLabel.text = "Town/City"
        stateLabel.text = "State"
        pincodeLabel.text = "Pincode"
        countryLabel.text = "Country"
        
        // Setup TextFields
        addressLine1TextField.borderStyle = .roundedRect
        addressLine2TextField.borderStyle = .roundedRect
        cityTextField.borderStyle = .roundedRect
        stateTextField.borderStyle = .roundedRect
        pincodeTextField.borderStyle = .roundedRect
        countryTextField.borderStyle = .roundedRect
        
        // Set pincodeTextField delegate and keyboard type
        pincodeTextField.delegate = self
        pincodeTextField.keyboardType = .numberPad
        
        // Add subviews
        addSubviews([addressLine1TextField, addressLine2TextField,
                     cityLabel, cityTextField,
                     stateLabel, stateTextField,
                     pincodeLabel, pincodeTextField,
                     countryLabel, countryTextField])
        
        // Set constraints
        setupConstraints()
    }
    
    private func addSubviews(_ views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func setupConstraints() {
        // Address Line 1 Constraints
        NSLayoutConstraint.activate([
            addressLine1TextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            addressLine1TextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLine1TextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        // Address Line 2 Constraints
        NSLayoutConstraint.activate([
            addressLine2TextField.topAnchor.constraint(equalTo: addressLine1TextField.bottomAnchor, constant: 16),
            addressLine2TextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLine2TextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        // City and State Constraints (Side by Side)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: addressLine2TextField.bottomAnchor, constant: 16),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            cityTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cityTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            stateLabel.topAnchor.constraint(equalTo: addressLine2TextField.bottomAnchor, constant: 16),
            stateLabel.leadingAnchor.constraint(equalTo: cityTextField.trailingAnchor, constant: 16),
            stateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stateTextField.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 8),
            stateTextField.leadingAnchor.constraint(equalTo: cityTextField.trailingAnchor, constant: 16),
            stateTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        // Pincode and Country Constraints (Side by Side)
        NSLayoutConstraint.activate([
            pincodeLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 16),
            pincodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            pincodeTextField.topAnchor.constraint(equalTo: pincodeLabel.bottomAnchor, constant: 8),
            pincodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pincodeTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            countryLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 16),
            countryLabel.leadingAnchor.constraint(equalTo: pincodeTextField.trailingAnchor, constant: 16),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            countryTextField.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8),
            countryTextField.leadingAnchor.constraint(equalTo: pincodeTextField.trailingAnchor, constant: 16),
            countryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            countryTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // UITextFieldDelegate method to restrict pincode input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return newText.count <= 6 && allowedCharacters.isSuperset(of: characterSet)
    }
}

import UIKit

class DynamicTableView: UIView {
    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Set table view properties
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.delegate = self
        tableView.dataSource = self
    }

    func reloadData() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        tableView.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: tableView.contentSize.height)
    }
}

extension DynamicTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // Your number of rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
}

import UIKit

class SearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRightView()
        disableKeyboard()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRightView()
        disableKeyboard()
    }

    private func setupRightView() {
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        rightView = searchButton
        rightViewMode = .always
    }

    @objc private func searchButtonClicked() {
        // Handle the search button click event here
        print("Search button clicked")
    }

    private func disableKeyboard() {
        self.inputView = UIView() // Assign an empty UIView as inputView to prevent the keyboard from opening
    }

    // Optionally, override `canBecomeFirstResponder` to always return false
    override var canBecomeFirstResponder: Bool {
        return false
    }
}

*/
