//
//  ViewController.swift
//  Test4
//
//  Created by 1 on 2018/12/15.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageView:UIImageView = UIImageView.init();
    let lab:UILabel = UILabel.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // init imageView
        imageView.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100);
        self.view.addSubview(imageView);
        
        //获取路径
       let dirPath:String = getFilePath("dir");
        //查看是否存在该文件夹，不存在就创建
        let isSuccess:Bool = makeDir(dirPath);
     
        if let isExists:Bool = isSuccess {
            //图片路径
            let imgPath:String = dirPath.appendingFormat("/%@","image.png");
            //判断是否存在图片文件
            if FileManager.default.fileExists(atPath: imgPath){
                //有图片就显示
                do{
                    let data:Data = try Data.init(contentsOf: URL.init(fileURLWithPath: imgPath), options: .dataReadingMapped);
                    imageView.image = UIImage.init(data: data);
                }catch{
                    
                }

            }else{
                //没有就下载
                let path:String = "http://huiping.fxgold.com/hongTaoCase/hongTaoImage/b9629e2b-5ca2-4908-af64-85ef94f7e3cd.png";
                do{
                    let data:Data = try Data.init(contentsOf: URL.init(string: path)!);
                    self.imageView.image = UIImage(data: data)
                    if UIImage(data: data) != nil {
                     //保存图片
                    self.saveImage(imgPath, data: data);
                    }
                    
                }catch{
                    
                }
           
            }
            
        }
        
   //2   自定制视图
        
        let myView:OvalView = OvalView.init(frame: CGRect.init(x: 100, y: 250, width: 200, height: 200));
        self.view.addSubview(myView);
        
        
//   (3)    代码版hello world（在视图控制器中加入代码）
        self.lab.frame = CGRect.init(x: 100, y: 480, width: 100, height: 50);
        self.lab.backgroundColor = UIColor.green;
        self.lab.textColor = UIColor.red;
        self.view.addSubview(self.lab);
        
        
        let btn:UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 550, width: 150, height: 30));
        btn.backgroundColor = UIColor.lightGray;
        btn.setTitle("点击我", for: .normal);
        self.view.addSubview(btn);
        btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
      
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func tapped() {
        self.lab.text = "Hello World!";
       
    }
    //保存图片
    func saveImage(_ imagePath:String,data:Data) {
        do {
        
            try data.write(to: URL.init(fileURLWithPath: imagePath));
        } catch  {
            
        }
       
    }
    //  MARK:--method1判断沙盒的Document目录下是否存在某文件夹，如果没有则新建一个该文件夹
    func makeDir(_ dirPath:String)->Bool {
        
        //判断是否存在该文件夹
        var isExists:Bool = false;
        if FileManager.default.fileExists(atPath:dirPath) {
           //存在
            print("存在");
            isExists = true;
        }else
        {
             print("不存在");
            //不存在 创建
            
            do{
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil);
                isExists = true;
            }catch{
                isExists = false;
            }
            
        }
        
        return isExists;
    }
//     MARK:--method1获取该文件夹路径
    func getFilePath(_ dirName:String) -> String {
        
     
        //获取沙盒路径
        let paths:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        //获取Document路径
        let documentPath:String = paths.first!;
        
        //文件夹路径
//        let dirPath:String = documentPath.appendingFormat("%@/%@",documentPath,dirName);
        let dirPath:String = documentPath.appendingFormat("/%@",dirName);

        return dirPath;
    }


}
//(2) 自定制视图
class OvalView: UIView {
    override func draw(_ rect: CGRect) {
         //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        //随后在里面画线段 进行绘制 先绘制 在填充或描边 就是stroke 移到这点 重新开始另一点的路径也是这个函数
        context.move(to: CGPoint.init(x: 50, y: 50));
       
        //再移动到这点
        context.addLine(to: CGPoint.init(x: 100, y: 100));
        context.addLine(to: CGPoint.init(x: 180, y: 40));
        context.addLine(to: CGPoint.init(x: 50, y: 50));
        //设置属性 例如线段宽度 颜色等
        context.setLineWidth(5.0);
        context.setStrokeColor(UIColor.red.cgColor);
      
        //绘制
        context.strokePath();
      
    }
}
