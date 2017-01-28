//
//  Suicider.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 28/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

//Naming is hard. I spend a couple of minutes thinking about the name of this protocol. 
//Sometimes I think code should have some fun in it. If it's something strange and boring, 
//it might benefit from being a little awekward and funny. I think that way it'll stick 
//on the readers' head longer. I mean, you probably have to come and see what this class is
//at first, but I'm pretty sure you'll remember it afterwards. "Ah! That's the viewController
//that shuts itset..."
//I also realize this is a discussible ideia. Among a team that would have to be discussed.
//Because other people (maybe like you, the reader) might actually prefer serious.
//But I couldn't really come up with a name that garanteed 100% the user knew what it was... 
//so why not add some fun to it and call it Suicider? :)
protocol Suicider {
    func killMe()
}

extension UIViewController : Suicider  {
    
    func killMe() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
