

import UIKit

private let reuseIdentifier = "cellid"  //自訂的       //這邊是全域變數吧 怎麼會是private 大概放哪都可？

class ThumbnailsCollectionViewController: UICollectionViewController {
    
    var dataManager:DataManager!  //初始化 並直接取出（方便後面取用）
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.register(       self.collectionView不用建立class的作法   目前有會衝突
//            UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        dataManager = DataManager.shared            //共享使用者區塊的 所有檔案名稱
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let selectedIndexPath = self.collectionView?.indexPathsForSelectedItems?.first else{
            assertionFailure("Fail to get selected item's index.")
            return
        }
        
        guard let viewControler =
            (segue.destination as? UINavigationController)?.topViewController
                as? DetailViewController else {
            return assertionFailure("Fail to get detailVC")
            
        }
        
        viewControler.targetIndex = selectedIndexPath.row   //把index傳過去
        
        viewControler.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        viewControler.navigationItem.leftItemsSupplementBackButton = true
        //告訴他原來前面是什麼control 並支援返回功能
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataManager.count        // 所有的檔案    這專案是圖片
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        guard let finalCell = cell as? ThumbnailCollectionViewCell else{
            return cell
        }
        
        
        finalCell.label.text = dataManager.filename(at: indexPath.row)
        finalCell.thumbnailImageView.image = dataManager.image(at: indexPath.row)
        return cell
    }

   

}
