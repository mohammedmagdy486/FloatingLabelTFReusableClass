//
//  CustomTextFieldWithOutError.swift
//  CustomFloatingLabelWithOutError
//
//  Created by Noura on 14/01/22.
//  Modified By Mohammed Magdy 23-11-2022

import UIKit

protocol CustomTextFieldWithOutErrorDelegate: UITextFieldDelegate {}

@IBDesignable
class FloatingLabelTextFieldWithOutError: UIView {
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak  var topLabelBackView: UIView!
    @IBOutlet weak  var bottomLabelBackView: UIView!

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak private var borderView: UIView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var secureEyeButton: UIButton!
    @IBOutlet weak var backLineView: UIView!

    weak var delegate: CustomTextFieldWithOutErrorDelegate?
    public var activeBorderColor : UIColor? = .black
    public var tFActiveColor : UIColor? = .black
    public var labelActiveColor : UIColor? = .gray
    public var inActiveBorderColor : UIColor? = .gray
    public var inActiveLabelColor : UIColor? = #colorLiteral(red: 0.8690223098, green: 0.8690223098, blue: 0.8690223098, alpha: 1)
    public var topLabelBackGround : UIColor? = .clear
    public var bottomLabelBackGround : UIColor? = .white
    public var backGround : UIColor? = .white
    var isShowPassword = false
    
    
    private (set) var isActive = false {
        didSet {
            if isActive {
                self.label.textColor = labelActiveColor
                self.textfield.textColor = tFActiveColor
                self.borderView.borderColor = activeBorderColor

            } else {
                self.label.textColor = inActiveLabelColor
                self.textfield.textColor = .black
                self.borderView.borderColor = inActiveBorderColor

            }
            self.topLabelBackView.backgroundColor = topLabelBackGround
            self.bottomLabelBackView.backgroundColor = bottomLabelBackGround
            self.borderView.backgroundColor = backGround

        }
    }
    
    //MARK: - Placeholder Related.
    @IBInspectable
    var placeholderText: String? {
        get { textfield.placeholder }
        set {
            textfield.placeholder = newValue
        }
    }
    @IBInspectable
    var labelText: String? {
        get { label.text }
        set {
            label.text = newValue
        }
    }
    var placeholderLabelFont: UIFont {
        get { label.font }
        set { label.font = newValue }
    }
    
    //MARK: - TextField Related.
    @IBInspectable
    var text: String? {
        get { textfield.text }
        set {
            textfield.text = newValue
            textfield.accessibilityValue = newValue
            updatePlaceholderVisibility(textfield.text!)
        }
    }
    
    @IBInspectable
    var textColor: UIColor? {
        get { textfield.textColor }
        set { textfield.textColor = newValue }
    }
    
    var textFont: UIFont? {
        get { textfield.font }
        set { textfield.font = newValue }
    }
    @IBInspectable
    var labelColor: UIColor? {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    var labelFont: UIFont? {
        get { label.font }
        set { label.font = newValue }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.setupColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.setupColors()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FloatingLabelTextFieldWithOutError", owner: self, options: nil)
        
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.label.isHidden = true
        self.topLabelBackView.isHidden = true
        self.bottomLabelBackView.isHidden = true

        self.textfield.delegate = self
    }
    
    private func updatePlaceholderVisibility(_ text: String) {
        self.label.isHidden = text.isEmpty
        self.topLabelBackView.isHidden = text.isEmpty
        self.bottomLabelBackView.isHidden = text.isEmpty

//        self.label.textColor = text.isEmpty ? .clear : inActiveBorderColor
        self.topLabelBackView.backgroundColor = topLabelBackGround
        self.bottomLabelBackView.backgroundColor = bottomLabelBackGround
        
    }
    
    private func updateBeginVisibility(_ text: String) {
        self.label.isHidden = false
        self.topLabelBackView.isHidden = false
        self.bottomLabelBackView.isHidden = false
    }
    func setupColors(activeBorderColor : UIColor? = Asset.Colors.primaryBlue.color, tFActiveColor : UIColor? = .black, labelActiveColor : UIColor? = Asset.Colors.primaryBlue.color, inActiveBorderColor : UIColor? = Asset.Colors.tabBarUnselected.color, topLabelBackGround : UIColor? = .clear, bottomLabelBackGround : UIColor? = .white, backGround:UIColor? = .white){
        self.activeBorderColor = activeBorderColor
        self.tFActiveColor = tFActiveColor
        self.labelActiveColor = labelActiveColor
        self.inActiveBorderColor = inActiveBorderColor
//         labelColor = labelActiveColor
        self.topLabelBackGround = topLabelBackGround
        self.bottomLabelBackGround = bottomLabelBackGround
        self.backGround = backGround
    }
    
    func setUp(Label:String, placeholder:String, isPassword:Bool = false, keyBoardType:UIKeyboardType? = .default,pickerView:UIPickerView? = nil,datePicker:UIDatePicker? = nil, isAr:Bool){
        isActive = false
         labelText = Label
        placeholderText = placeholder
        secureEyeButton.isHidden = !isPassword
        textfield.isSecureTextEntry = isPassword
        textfield.textAlignment = isAr ? .right:.left
        secureEyeButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        textfield.keyboardType = keyBoardType ?? .default
        pickerView == nil ?():(textfield.inputView = pickerView)
        datePicker == nil ?():(textfield.inputView = datePicker)
    }
}

//MARK: - UITextFieldDelegate (Relay delegate calls to the controller for further updates)
extension FloatingLabelTextFieldWithOutError : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField)
        isActive = false
        if self.text == "" {
            self.placeholderText = labelText
        }
        
        self.updatePlaceholderVisibility(textfield.text ?? "")
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing?(textField)
        isActive = true
        self.placeholderText = ""
        self.updateBeginVisibility(textfield.text ?? "")
//        self.updatePlaceholderVisibility(textfield.text ?? "")
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            isActive = !updatedText.isEmpty
            self.updatePlaceholderVisibility(updatedText)
        }
        
        return delegate?.textField?(textField,
                                    shouldChangeCharactersIn: range,
                                    replacementString: string) ?? true
    }
}

extension FloatingLabelTextFieldWithOutError{
    @objc func showPassword(){
        if isShowPassword == false{
            secureEyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for:.normal)
            textfield.isSecureTextEntry = false
            isShowPassword = true
        }else{
            secureEyeButton.setImage(UIImage(systemName: "eye.fill"), for:.normal)
            textfield.isSecureTextEntry = true
            isShowPassword = false
        }

    }
  
}
