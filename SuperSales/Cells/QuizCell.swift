//
//  QuizCell.swift
//  SuperSales
//
//  Created by mac on 27/01/22.
//  Copyright © 2022 Bigbang. All rights reserved.
//

import UIKit
protocol QuizCellDelegate {
    func viewDocumentClicked(cell:QuizCell)
    func startQuizClicked(cell:QuizCell)
    func viewScoreClicked(cell:QuizCell)
    func viewDocumentReportClicked(cell:QuizCell)
    
    
}
class QuizCell: UITableViewCell {

    
    @IBOutlet weak var btnViewDocumentReport: UIButton!
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDocumentName: UILabel!
    
    @IBOutlet weak var stkQuiz: UIStackView!
    @IBOutlet weak var btnViewDocument: UIButton!
    
    @IBOutlet weak var btnViewScore: UIButton!
    @IBOutlet weak var btnStartQuiz: UIButton!
    var quizdelegate:QuizCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//MARK: - IBAction
    
    @IBAction func btnViewDocumentClicked(_ sender: UIButton) {
        quizdelegate?.viewDocumentClicked(cell: self)
    }
    
    
    @IBAction func btnStartClicked(_ sender: UIButton) {
        quizdelegate?.startQuizClicked(cell: self)
    }
    
    
    @IBAction func btnViewScoreClicked(_ sender: UIButton) {
        quizdelegate?.viewScoreClicked(cell: self)
    }
    
    
    @IBAction func btnViewDocumentReportClicked(_ sender: UIButton) {
        quizdelegate?.viewDocumentReportClicked(cell: self)
        
    }
}
