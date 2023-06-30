import UIKit
import SnapKit


class MoviesViewController: UIViewController {
    
    
    let filmManager = FilmManager()
    let tableView = UITableView()
    let customFont = "Kanit-Bold"
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.dataSource = self
        tableView.delegate = self
        
  
        setupUI()
        setupNaviagation()
        
        let cellNib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        
        
        filmManager.fetchFilmsFromWeb { [weak self] error in
            if error != nil {
                DispatchQueue.main.async {
                    
                    self?.showErrorAlert(message: "Упс! Что-то пошло не так...")
                }
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    //MARK: - Problems with Data Alert
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        view.layer.backgroundColor = UIColor(red: 0.03, green: 0.23, blue: 0.30, alpha: 1.00).cgColor
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor(red: 0.11, green: 0.12, blue: 0.18, alpha: 1.00)
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.reloadData()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    //MARK: - Setup Naviagation UI
    
    private func setupNaviagation(){
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Фильмы"
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFilm = filmManager.filmsByYear[indexPath.section][indexPath.row]
        
        let detailViewController = DetailViewController()
        detailViewController.selectedFilm = selectedFilm
        
        if let navigationController = navigationController {
            navigationController.pushViewController(detailViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MoviesViewController: UITableViewDataSource {
    
    //MARK: - Cell Setup
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filmManager.filmsByYear.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmManager.filmsByYear[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MoviesTableViewCell
        
        let film = filmManager.filmsByYear[indexPath.section][indexPath.row]
        
        cell.backgroundColor = UIColor(red: 0.21, green: 0.23, blue: 0.27, alpha: 0.5)
        
        cell.localizedLabel.text = film.localizedName
        cell.localizedLabel.numberOfLines = 1
        cell.localizedLabel.font = UIFont(name: customFont, size: 18)
        cell.localizedLabel.textColor = .white
        
        cell.originalLabel.text = film.name
        cell.originalLabel.numberOfLines = 1
        cell.originalLabel.font = UIFont(name: "Kanit-Medium", size: 16)
        cell.originalLabel.textColor = .white
        
        cell.ratingLabel.text = "\(film.rating ?? 0.0)"
        cell.ratingLabel.font = UIFont(name: customFont, size: 14)
        cell.ratingLabel.textColor = .white
        cell.ratingLabel.font = UIFont(name: "Kanit-Medium", size: 14)
        
        
        //MARK: - Rating color depending on rating
        
        if let rating = film.rating {
            switch rating {
            case 7.0...Double.greatestFiniteMagnitude:
                cell.ratingLabel.textColor = UIColor(red: 0.02, green: 0.84, blue: 0.63, alpha: 1.00)
            case 5.0..<7.0:
                cell.ratingLabel.textColor = UIColor(red: 1.00, green: 0.82, blue: 0.40, alpha: 1.00)
            case ..<5.0:
                cell.ratingLabel.textColor = UIColor(red: 0.94, green: 0.28, blue: 0.44, alpha: 1.00)
            default:
                cell.ratingLabel.textColor = UIColor(red: 0.07, green: 0.54, blue: 0.70, alpha: 1.00)
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    //MARK: - Custom Year Headers
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let filmsInSection = filmManager.filmsByYear[section]
        guard let firstFilm = filmsInSection.first else {
            return nil
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = UIColor(red: 0.11, green: 0.12, blue: 0.18, alpha: 1.00)
        
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: customFont, size: 15)
        titleLabel.textColor = .white
        titleLabel.text = "\(firstFilm.year ?? 0)"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
    
}

