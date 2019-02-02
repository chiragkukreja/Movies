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
final class FilterViewController: UIViewController {
    var viewModel: FilterViewModel!
    weak var delegate: FilterViewControllerDelegate?
    @IBOutlet weak var minYear: UITextField!
    @IBOutlet weak var maxYear: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !viewModel.filters.minYear.isEmpty{
            minYear.text = viewModel.filters.minYear
        }
        if !viewModel.filters.maxYear.isEmpty{
            maxYear.text = viewModel.filters.maxYear
        }
    }
    
    @IBAction func viewResultsTapped(_ sender: Any) {
        dismiss()
        guard let min = minYear.text, let max = maxYear.text else {return}
        
        var reloadRequired = false
        if  min != viewModel.filters.minYear {
            reloadRequired = true
        }
        if max != viewModel.filters.maxYear {
            reloadRequired = true
        }
        if reloadRequired{
            let filters = Filters(minYear: min, maxYear: max)
            delegate?.handleButttonAction(with: filters)
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss()
    }
   private func dismiss() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.intValue <= 2019
    }
}

