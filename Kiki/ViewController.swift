
import UIKit
import AVFoundation

//録音できたものを次の画面に移す　録音中にマイクの音を拾って波をつける

class ViewController: UIViewController {
    
    let fileManager = NSFileManager()//録音もできないしそれを再生もできない
    var audioRecorder: AVAudioRecorder?
    let fileName = "sample.caf"
    var time: NSTimer!
    let recordDelay = 3.0
    
    
    let image1 = UIImage(named: "IMG_2522")
    let image2 = UIImage(named: "IMG_2844")
    let image3 = UIImage(named: "IMG_2846")
    
    
    
    @IBOutlet weak var viewImage: UIView! //オレンジ色
    @IBOutlet weak var recordImage: UIButton! //丸いレコーディングボタン
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setupAudioRecorder()
    }
    
    //カウントダウンしてレコード開始しボタンのUIも変更
    @IBAction func recordStart(sender: UIButton) {
        sender.setImage(UIImage(named: "Kiki5"), forState: UIControlState.Normal)
    
    }
    
    func imageiti() {
        let view1: UIImageView = UIImageView(frame: CGRectMake(0,0,300,300))
        image1.size = view1
        
        
        
        
    }
    
    
    func setupAudioRecorder() {
        let session = AVAudioSession.sharedInstance() //ここではどっちも設定してる
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord) //マイクから取りこんだ音声データを、再生専用とか録音専用の指定もある
        try! session.setActive(true)
        let recordSetting : [String : AnyObject] = [
            //オーディオデータを設定の通りに全て取りこんでると大量のデータになってしまうので、圧縮
            AVEncoderAudioQualityKey : AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey : 16,//1枚のページにたして16の情報をかけてる
            AVNumberOfChannelsKey: 2 , //イヤホンも左右から違う音が聞こえる
            AVSampleRateKey: 44100.0 //これが多ければ多いほどスムーズ
        ]
        do {     //録音したものは/aaa/bbb/ccc.app/Document/sample.caここに入る
            try audioRecorder = AVAudioRecorder(URL: self.documentFilePath(), settings: recordSetting)
        } catch {
            print("初期設定でerror")
        }
    }
    
    // 録音するファイルのパスを取得(録音時、再生時に参照)
    // swift2からstringByAppendingPathComponentが使えなくなったので少し面倒
    func documentFilePath()-> NSURL {//要求されたドメインで指定された一般的なディレクトリの Url の配列を返します
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        //iTunesにもバックアップされる、大事なファイルを置くディレクトリへのパスを取得
        let dirURL = urls[0] //要求されたドメインで指定された一般的なディレクトリの Url の配列のうちの一個が帰ってくる
        return dirURL.URLByAppendingPathComponent(fileName)
    }          //その指定したディレクトリにurlを置いて完
    

    
    
    
    
    
    
}
