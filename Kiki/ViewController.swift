
import UIKit
import AVFoundation

//録音できたものを次の画面に移す　録音中にマイクの音を拾って波をつける

class ViewController: UIViewController {
    
    let fileManager = NSFileManager()//録音もできないしそれを再生もできない
    var audioRecorder: AVAudioRecorder?
    let fileName = "sample.caf"
    var timer: NSTimer!
    let photos = ["Kiki10", "Kiki7", "Kiki8","IMG_1718"]
    var count = 1
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var recordImage: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudioRecorder()
    }
    
    //カウントダウンしてレコード開始しボタンのUIも変更
    @IBAction func recordStart(sender: UIButton) {
        sender.setImage(UIImage(named: "Kiki11"), forState: UIControlState.Normal)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.nextPage), userInfo: nil, repeats: true )
        
    }
    
    
    func nextPage (sender:NSTimer){
        
        var image:UIImage! = UIImage(named: photos[0])
        if count == 1{
            imageView.image = image;
            count += 1
            
        }else if count == 2{
            image = UIImage(named: photos[1])
            imageView.image = image
            count += 1
            
            
        }else if count == 3{
            image = UIImage(named: photos[2])
            imageView.image = image
            count += 1
        }else if count == 4{
            image = UIImage(named: photos[3])
            imageView.image = image
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            sender.invalidate()
            
        }
        
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
