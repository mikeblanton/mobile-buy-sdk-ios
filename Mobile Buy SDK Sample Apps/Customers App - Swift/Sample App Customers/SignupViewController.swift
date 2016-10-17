//
//  SignupViewController.swift
//  Sample App Customers
//
//  Created by Shopify.
//  Copyright (c) 2016 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import Buy

class SignupViewController: UITableViewController {

    weak var delegate: AuthenticationDelegate?
    
    @IBOutlet fileprivate weak var firstNameField:       UITextField!
    @IBOutlet fileprivate weak var lastNameField:        UITextField!
    @IBOutlet fileprivate weak var emailField:           UITextField!
    @IBOutlet fileprivate weak var passwordField:        UITextField!
    @IBOutlet fileprivate weak var passwordConfirmField: UITextField!
    @IBOutlet fileprivate weak var actionCell:           ActionCell!
    
    fileprivate var firstName:       String { return self.firstNameField.text       ?? "" }
    fileprivate var lastName:        String { return self.lastNameField.text        ?? "" }
    fileprivate var email:           String { return self.emailField.text           ?? "" }
    fileprivate var password:        String { return self.passwordField.text        ?? "" }
    fileprivate var passwordConfirm: String { return self.passwordConfirmField.text ?? "" }
    
    // ----------------------------------
    //  MARK: - View Loading -
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionCell.loading = false
    }
    
    // ----------------------------------
    //  MARK: - Actions -
    //
    fileprivate func createUser() {
        guard !self.actionCell.loading else { return }
        
        let credentials = BUYAccountCredentials(items: [
            BUYAccountCredentialItem(firstName: self.firstName),
            BUYAccountCredentialItem(lastName: self.lastName),
            BUYAccountCredentialItem(email: self.email),
            BUYAccountCredentialItem(password: self.password)
        ])
        
        self.actionCell.loading = true
        BUYClient.sharedClient.createCustomer(with: credentials) { (customer, token, error) in
            self.actionCell.loading = false
            
            if let customer = customer,
                let token = token {
                self.clear()
                self.delegate?.authenticationDidSucceedForCustomer(customer, withToken: token.accessToken)
            } else {
                self.delegate?.authenticationDidFailWithError(error as NSError?)
            }
        }
    }
    
    fileprivate func clear() {
        self.firstNameField.text        = ""
        self.lastNameField.text         = ""
        self.emailField.text            = ""
        self.passwordField.text         = ""
        self.passwordConfirmField.text  = ""
    }
    
    // ----------------------------------
    //  MARK: - UITableViewDelegate -
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 2 {
            
            if !self.email.isEmpty &&
                !self.password.isEmpty &&
                !self.firstName.isEmpty &&
                !self.lastName.isEmpty &&
                !self.passwordConfirm.isEmpty {
                
                self.createUser()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
