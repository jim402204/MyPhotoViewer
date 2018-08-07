
import UIKit

class DataManager {
    
    var test = "123"
    
    // Singletion 以下為單例模式
    static let shared = DataManager()
    
    private init(){
        retrieveFilenames()                //取得系統默認文件路徑下使用者的區塊中 所有的檔案內容名稱
    }
    
    //Ｍａｒｋ  -  Private Methods/Properties
    private var filenames = [String]()    //store Property   thread 要用中斷點看旁邊的 thread 1 (main)
    private let documentURL :URL =
    {
        //大概以後 會加入其他程式碼 先習慣吧
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()     //這是method
    
    private func retrieveFilenames(){
        print("Document \(documentURL)")
        
        let filemanager = FileManager.default
        
        guard let results = try?filemanager.contentsOfDirectory(atPath: documentURL.path) else {
            assertionFailure("Fail to get file list")
            return
        }
        filenames = results                        //返回所有的路徑內容 字串陣列
        //Wordaround to remove "DS_Store" file   // 這是模擬器的默認檔案
        if let index = filenames.index(of: ".DS_Store"){
            filenames.remove(at: index)
        }
        
        print("Filmnames\(filenames)")
    }
    
    
    
    //Mark Public Methods  :
    
//    private var filmname = [String]()     這邊只是在 以取得的檔名陣列中 取得圖片
    
    var count: Int {   // 屬性 圖片總數
        return filenames.count
    }
    
    func filename(at:Int) -> String? {   //多數程式語言 回傳nil 表示失敗
        
        guard at >= 0 && at < filenames.count else {     //使用array 的防堵
            return nil
        }
        
        return filenames[at]
    }
    
    func image(at:Int) -> UIImage? {//有？表示有可能 執行失敗
        
        guard let filename = filename(at: at) else {
            return nil
        }
        
        let fullPath = documentURL.appendingPathComponent(filename).path
        
        
        return UIImage(contentsOfFile: fullPath)    //有機會拿到nil
        // 取得圖片透過 檔案完整的檔案內容路徑
    }
    
}
