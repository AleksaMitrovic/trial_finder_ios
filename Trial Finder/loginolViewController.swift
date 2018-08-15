//
//  loginolViewController.swift
//  Trial Finder
//
//  Created by barron9 on 24.03.2017.
//  Copyright © 2017 Iran Mateu. All rights reserved.
//

import UIKit

class loginolViewController: UIViewController {

    @IBAction func basdsti(_ sender: Any) {
        performSegue(withIdentifier: "basti", sender: nil)
    }
    @IBAction func `as`(_ sender: Any) {
        performSegue(withIdentifier: "basti", sender: nil)
    }
    @IBAction func x(_ sender: Any) {
        performSegue(withIdentifier: "fort", sender: nil)

    }
    @IBOutlet weak var tobbar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
self.title = "Hello!"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
