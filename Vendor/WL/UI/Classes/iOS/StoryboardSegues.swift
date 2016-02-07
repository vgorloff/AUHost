/// File: StoryboardSegues.swift
/// Project: WLUI
/// Author: Created by Vlad Gorlov on 2014.08.13.
/// Copyright: Copyright (c) 2014 WaveLabs. All rights reserved.

import UIKit
import QuartzCore

public class GenericStoryboardSegue: UIStoryboardSegue {
	public var unwinding: Bool = false
}

public class CrossDissolveStoryboardSegue: GenericStoryboardSegue {

	public override func perform() {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

		if let nc = sourceViewController.navigationController {
			nc.view.layer.addAnimation(transition, forKey: kCATransition)
			if unwinding {
				if let dnc = destinationViewController.navigationController {
					dnc.popToViewController(destinationViewController, animated: false)
				}
			} else {
				nc.pushViewController(destinationViewController, animated: false)
			}
		} else {
			print("Seems like navigation controller is missed")
		}

	}
}

public class PushCrossDissolveStoryboardSegue: CrossDissolveStoryboardSegue {
}

public class PopCrossDissolveStoryboardSegue: CrossDissolveStoryboardSegue {
	override init(identifier: String?, source: UIViewController, destination: UIViewController) {
		super.init(identifier: identifier, source: source, destination: destination)
		unwinding = true
	}
}

public class SwitchStoryboardSegue: GenericStoryboardSegue {

	public override func perform() {
		if let nc = sourceViewController.navigationController {
			if unwinding {
				if let dnc = destinationViewController.navigationController {
					dnc.popToViewController(destinationViewController, animated: false)
				}
			} else {
				nc.pushViewController(destinationViewController, animated: false)
			}
		} else {
			print("Seems like navigation controller is missed")
		}

	}
}

public class PushSwitchStoryboardSegue: SwitchStoryboardSegue {
}

public class PopSwitchStoryboardSegue: SwitchStoryboardSegue {
	override init(identifier: String?, source: UIViewController, destination: UIViewController) {
		super.init(identifier: identifier, source: source, destination: destination)
		unwinding = true
	}
}
