//
//  ListDetailViewController.swift
//  推送
//
//  Created by 赵希帆 on 15/9/17.
//  Copyright (c) 2015年 赵希帆. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(controller : ListDetailViewController)
    func listDetailViewController(controllrt : ListDetailViewController,didFinishAddingChecklist checklist : Checklist)
    func listDetailViewController(controller : ListDetailViewController,didFinishEditingChecklist checklist : Checklist)
    
}


class ListDetailViewController: UITableViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    var delegate : ListDetailViewControllerDelegate?
    var checklistToEdit : Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if checklistToEdit != nil {
            self.title = "编辑任务类型"
            TextField.text = checklistToEdit!.name
            DoneButton.enabled = true
        }
        TextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.TextField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    @IBAction func Cancel(sender: AnyObject) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    
    @IBAction func Done(sender: AnyObject) {
        if self.checklistToEdit == nil {
            let checklist = Checklist(name: TextField.text!)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
        else{
            checklistToEdit?.name = self.TextField.text!
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklistToEdit!)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newText = textField.text!.stringByReplacingCharactersInRange(range.toRange(textField.text!), withString: string)
        DoneButton.enabled = newText.characters.count > 0
        return true
    }
    
}
