// Copyright SIX DAY LLC. All rights reserved.

import Foundation

import UIKit
import Eureka
import MessageUI

class SupportViewController: FormViewController {

    let viewModel = SupportViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title

        form +++ Section()

            <<< link(
                title: NSLocalizedString("settings.faq.button.title", value: "FAQ", comment: ""),
                value: "https://trustwalletapp.com/faq.html",
                image: R.image.settings_faq()
            )

            <<< link(
                title: NSLocalizedString("settings.privacyPolicy.button.title", value: "Privacy Policy", comment: ""),
                value: "https://trustwalletapp.com/privacy-policy.html",
                image: R.image.settings_privacy_policy()
            )

            <<< link(
                title: NSLocalizedString("settings.termsOfService.button.title", value: "Terms of Service", comment: ""),
                value: "https://trustwalletapp.com/terms.html",
                image: R.image.settings_terms()
            )

            <<< AppFormAppearance.button { button in
                button.title = NSLocalizedString("settings.emailUsReadFAQ.button.title", value: "Email Us (Read FAQ first)", comment: "")
            }.onCellSelection { [weak self] _, _  in
                self?.sendUsEmail()
            }.cellSetup { cell, _ in
                cell.imageView?.image = R.image.settings_email()
            }

            +++ Section(NSLocalizedString("settings.openSourceDevelopment.label.title", value: "Open Source Development", comment: ""))

            <<< link(
                title: NSLocalizedString("settings.sourceCode.button.title", value: "Source Code", comment: ""),
                value: "https://github.com/TrustWallet/trust-wallet-ios",
                image: R.image.settings_open_source()
            )

            <<< link(
                title: NSLocalizedString("settings.reportBug.button.title", value: "Report a Bug", comment: ""),
                value: "https://github.com/TrustWallet/trust-wallet-ios/issues/new",
                image: R.image.settings_bug()
            )
    }

    private func link(
        title: String,
        value: String,
        image: UIImage?
    ) -> ButtonRow {
        return AppFormAppearance.button {
            $0.title = title
            $0.value = value
        }.onCellSelection { [unowned self] (_, row) in
            guard let value = row.value, let url = URL(string: value) else { return }
            self.openURL(url)
        }.cellSetup { cell, _ in
            cell.imageView?.image = image
        }
    }

    func sendUsEmail() {
        let composerController = MFMailComposeViewController()
        composerController.mailComposeDelegate = self
        composerController.setToRecipients([Constants.supportEmail])
        composerController.setSubject(NSLocalizedString("settings.feedback.email.title", value: "Trust Feedback", comment: ""))
        composerController.setMessageBody(emailTemplate(), isHTML: false)

        if MFMailComposeViewController.canSendMail() {
            present(composerController, animated: true, completion: nil)
        }
    }

    private func emailTemplate() -> String {
        return """
        \n\n\n

        Helpful information to developers:
        iOS Version: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.model)
        Trust Version: \(Bundle.main.fullVersion)
        Current locale: \(Locale.preferredLanguages.first ?? "")
        """
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SupportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
