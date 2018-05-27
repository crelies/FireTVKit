//
//  FireTVSelectionTableViewCell.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

final class FireTVSelectionTableViewCell: UITableViewCell {
    private var theme: FireTVSelectionThemeProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = theme?.labelColor
            textLabel?.textColor = theme?.backgroundColor
        } else {
            backgroundColor = theme?.cellBackgroundColor
            textLabel?.textColor = theme?.labelColor
        }
    }
}

extension FireTVSelectionTableViewCell {
    func updateUI(withTheme theme: FireTVSelectionThemeProtocol) {
        self.theme = theme
        backgroundColor = theme.cellBackgroundColor
        textLabel?.textColor = theme.labelColor
    }
}
