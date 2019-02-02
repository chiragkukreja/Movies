//
//  FilterViewController.swift
//  Movies
//
//  Created by Chirag Kukreja on 02/02/19.
//  Copyright © 2019 Chirag Kukreja. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func handleButttonAction(with filters: Filters)
}


struct Filters {
    let minYear: String
    let maxYear: String
}
class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?
    @IBOutlet weak var minYear: UITextField!
    @IBOutlet weak var maxYear: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func viewResultsTapped(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        let filters = Filters(minYear: minYear.text ?? "", maxYear: maxYear.text ?? "")
        delegate?.handleButttonAction(with: filters)
    }
    
}

extension FilterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

