import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var yesBottun: UIButton!
    @IBOutlet private weak var noBottun: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    var isAnsweringQuestion = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        
        yesBottun.isEnabled = true
        noBottun.isEnabled = true
        imageView.layer.cornerRadius = 20
    }

    // MARK: - Actions
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        
        if !isAnsweringQuestion {
            isAnsweringQuestion = true
            yesBottun.isEnabled = false
            noBottun.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isAnsweringQuestion = false
                self.yesBottun.isEnabled = true
                self.noBottun.isEnabled = true
            }
        }
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        
        if !isAnsweringQuestion {
            isAnsweringQuestion = true
            yesBottun.isEnabled = false
            noBottun.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isAnsweringQuestion = false
                self.yesBottun.isEnabled = true
                self.noBottun.isEnabled = true
            }
        }
    }
    
    
    // MARK: - Private functions

    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()

        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.presenter.restartGame()
            }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    func highlightImageBorder(isCorrect isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: "Попробовать ещё раз",
            style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.presenter.restartGame()
            }

        alert.addAction(action)
    }
    
    
    
}
