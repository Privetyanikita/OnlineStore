//
//  OnbordingViewController.swift
//  OnlineStore
//
//  Created by Polina on 17.04.2024.
//

import UIKit

final class OnbordingViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.configImageView(cornerRadius: 0, contentMode: .scaleAspectFit)
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        imageView.image = UIImage(systemName: "arrow.forward",withConfiguration: configuration)?
            .withTintColor(.white,renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = 3
        pageControl.page = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let data: [OnbordingModel] = OnbordingModel.getOnbordingModel()
    
    private var currentPage = 0 {
        didSet{
            pageControl.page = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDelegates()
        setViews()
        configUIElement()
        layoutViews()
        configureCollectionView()
    }
    
    private func setDelegates(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate
extension OnbordingViewController: UICollectionViewDelegate{}

// MARK: - UICollectionViewDataSource
extension OnbordingViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnbordingCell.resuseID, for: indexPath) as? OnbordingCell else { return UICollectionViewCell() }
        let data = data[indexPath.row]
        cell.configCell(titleText: data.title, descriptionText: data.subTitle, image: UIImage(named: data.image))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
       
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnbordingViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - setUpViews
private extension OnbordingViewController{
    func configUIElement(){
        button.addTarget(nil, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc private func tappedButton(){
        if currentPage == data.count - 1{
            print("go to AuthVC") // сохраняем флаг о прохождении онбординга
        }else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnbordingCell.self, forCellWithReuseIdentifier: OnbordingCell.resuseID)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
     func setViews(){
         button.addSubview(arrowImage)
        [
            collectionView,
            button,
            pageControl,
        ].forEach { view.addSubview($0) }
    }
    
     func layoutViews(){
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(button.snp.top).offset(-16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-60)
            make.height.equalTo(30)
        }
         button.snp.makeConstraints { make in
             make.trailing.equalToSuperview().offset(-20)
             make.bottom.equalToSuperview().offset(-50)
             make.height.width.equalTo(60)
         }
         
         arrowImage.snp.makeConstraints { make in
             make.centerX.centerY.equalTo(button)
             make.width.height.equalTo(20)
         }
    }
}
