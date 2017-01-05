//
//  ViewController.m
//  Hinter
//
//  Created by igenius on 2016/11/5.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import "ViewController.h"
#import "StoryDevelopCell.h"
#import "HinterCollectedVC.h"
#import "WWHPresentationController.h"
#import "GlobalVariable.h"
#import  "AppDelegate.h"

//,UIViewControllerAnimatedTransitioning
@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
@property (weak, nonatomic,nullable) IBOutlet UITextField *suspectsTextField;
@property (weak, nonatomic,nullable) IBOutlet UITableView *storyTableView;
@property (nonatomic ,strong,nullable) NSTimer *timer;
@property (nonatomic ,strong) NSArray *storyArray;
@property (nonatomic ,strong) NSMutableArray *storyDevelopArray;
@property (nonatomic ,strong) NSMutableArray *hinterTempArray;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
//@property (nonatomic ,strong) NSTimer *gameTimer;
@property (nonatomic ,strong) NSSet *clueToSolvingCaseSet;

//转场动画使用
@property ( nonatomic, strong ) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自动计算tableViewCell的高度,告诉tableView所有cell的真是高度是自动计算的(根据设置的约束)
    self.storyTableView.rowHeight = UITableViewAutomaticDimension;
    //设置tableViewCell的估算高度
    self.storyTableView.estimatedRowHeight = 50;
    
    
    [self loadBackgroundImage];
    self.storyArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"StoryList.plist" ofType:nil]];
    self.leftBtn.titleLabel.numberOfLines = 0;
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    if (![self.storyDevelopArray.lastObject  isEqual: @"第一章结束"]){
    [self startTimer];
    } else {
        //TODO： 当结案后按钮
        NSIndexPath *tempIndexPath = [NSIndexPath  indexPathForRow:self.storyDevelopArray.count - 1 inSection:0];
        [self.storyTableView selectRowAtIndexPath:tempIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];

        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        [self.leftBtn setTitle:@"下一章" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"结案" forState:UIControlStateNormal];

    }
}

//- (void)viewDidAppear:(BOOL)animated{
//    [self.storyTableView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 定义全局变量
static int add = 0;
static int tempAdd;


#pragma mark - UI设计


- (void)loadBackgroundImage{
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    backImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
}

//顶格排版
- (void)setFlush{
    NSIndexPath *tempIndexPath = [NSIndexPath  indexPathForRow:self.storyDevelopArray.count - 1 inSection:0];
    [self.storyTableView selectRowAtIndexPath:tempIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
}


#pragma mark - 存储数据方法
-(void)storeUserStory:(NSMutableArray *)tempArray{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"storyDevelop.plist"];
    [tempArray writeToFile:filePath atomically:YES];
    
}

#pragma mark - 懒加载属性
- (NSMutableArray *)storyDevelopArray{
    //如果为空
    if (!_storyDevelopArray) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"storyDevelop.plist"];

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
        _storyDevelopArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        } else {
            _storyDevelopArray = [NSMutableArray array];
        }
            
        
    }
    return _storyDevelopArray;
}



- (NSMutableArray *)hinterTempArray{
    
    if (!_hinterTempArray) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"hintsCollect.plist"];

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
            _hinterTempArray = [NSMutableArray arrayWithArray:[GlobalVariable getHinterArray]];
        
        } else {
        _hinterTempArray = [NSMutableArray array];
        }
    }
        return _hinterTempArray;
}

- (NSSet *)clueToSolvingCaseSet{
    if (!_clueToSolvingCaseSet) {
        _clueToSolvingCaseSet = [NSSet setWithObjects:
                                 @"通过调查百里戚大学是心理专业，并非金融专业",
                                 @"➥所以我也一直劝说她休公休假，在家好好休息休息",
                                 @"以100元为报偿让其在8月17日当晚去石桥东的垃圾桶下取一个U盘送到死者家中",
                                 @"➥这次我转发了一个微博名叫刺史雨发起的抽奖",
                                 @"➥对了，还有百里戚，吵架那天以及前两天百里戚和我抱怨了很多他和死者之间的小矛盾",
                                 @"➥有一个，通过监控发现8月17日在单位死者同事百里戚接触过死者的手机",
                                 @"➥当天百里戚约了我一起在石桥东附近的铺子喝酒",
                                 @"➥一直在和我说段素芳生活的不容易，最后还让我打个电话给段素芳赔礼道歉",
                                 @"在死者家中找到个U盘,其中都是死者儿子与其女朋友交往的场景，还有张图片是她俩机票订单信息",
                                 @"就在此时，放在另一张桌上死者的手机突然响起，一首许志安的《为什么你背着我爱别人》",
                                 @"其他有价值的线索就只是小男孩说黑衣男子再和他交谈中一直在转大拇指上的一个八角戒指",
                                 @"此时我注意到他一直在摸他的大拇指关节处",
                                 nil];
    }
    return _clueToSolvingCaseSet;
}

#pragma mark - 定时器
- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    [self.timer invalidate];
    
}


- (void)timerAction:(NSTimer *)timer{
    //每个1.5秒添加一行数据
    [self refreshStory];

    //自动顶格操作
    NSIndexPath *tempIndexPath = [NSIndexPath  indexPathForRow:self.storyDevelopArray.count - 1 inSection:0];
    [self.storyTableView selectRowAtIndexPath:tempIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];

}








#pragma mark - 刷新数据
- (void)refreshStory{
    
    NSString *tempStoryDevelop = self.storyArray[self.storyDevelopArray.count + tempAdd];
    
    
    //判断是够包含&,即是否要显示button,
    if ([tempStoryDevelop rangeOfString:@"&"].location != NSNotFound){
        [self stopTimer];
        
     NSInteger i = [tempStoryDevelop rangeOfString:@"&"].location;
        
        
        
        if (tempStoryDevelop  != self.storyArray.lastObject) {
           
            //获取&前的字符串
            NSString *prefix = [tempStoryDevelop substringWithRange:NSMakeRange(0, i-1)];
            //获取&后的字符串
            NSString *suffix = [tempStoryDevelop substringFromIndex:i+2];
            
            //设置button属性
            [self.leftBtn setTitle:prefix forState:UIControlStateNormal];
            [self.rightBtn setTitle:suffix forState:UIControlStateNormal];
            

            //获取tag
            NSInteger leftTag = [[tempStoryDevelop substringFromIndex:i-1] integerValue];
            
            [self.leftBtn setTag:leftTag];
            
            NSInteger rightTag = [[tempStoryDevelop substringFromIndex:i+1] integerValue];
            
            [self.rightBtn setTag:rightTag];
        } else {
            //获取&前的字符串
            NSString *prefix = [tempStoryDevelop substringWithRange:NSMakeRange(0, i)];
            //获取&后的字符串
            NSString *suffix = [tempStoryDevelop substringFromIndex:i+1];
            
            //设置button属性
            [self.leftBtn setTitle:prefix forState:UIControlStateNormal];
            [self.rightBtn setTitle:suffix forState:UIControlStateNormal];

        }

        
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        [self.storyTableView reloadData];
    } else {
        //不包含&则直接刷新数据
        [self.storyDevelopArray addObject:[NSString stringWithFormat:@"%@",tempStoryDevelop]];
        [self storeUserStory:self.storyDevelopArray];

        [self.storyTableView reloadData];
        
    }

}


#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storyDevelopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //定义复用标识
    static NSString *ID = @"storyCell";

    //从缓存池中取标识为ID的Cell
    StoryDevelopCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];

    cell.storyLabel.text = self.storyDevelopArray[indexPath.row];
    if ([self.storyDevelopArray[indexPath.row] rangeOfString:@"⎡"].location != NSNotFound){
        cell.storyLabel.textColor = [UIColor orangeColor];
    }   else {
        cell.storyLabel.textColor = [UIColor colorWithRed:242/255.0 green:231/255.0 blue:201/255.0 alpha:1];
    }
    //TODO: 传入模型,通过判断某一个 来判断,在cell里面设置,通过传入的数据模型来判断,参考系统自带闹钟的button,找demo
    //简单方式
    if (![self.hinterTempArray containsObject:cell.storyLabel.text]) {
        [cell.addHinterBtn setTitle:@"+" forState:UIControlStateNormal];
    } else {
        [cell.addHinterBtn setTitle:@"-" forState:UIControlStateNormal];

    }
    cell.selectedBackgroundView = [[UIImageView alloc] init];
    return cell;
}


#pragma mark - 作案人textFieldDone点击
- (IBAction)murdererTextFieldDone:(id)sender {
    [sender resignFirstResponder];
}



#pragma mark - 按钮点击

//左边点击按钮
- (IBAction)leftBtnClick:(UIButton *)leftBtn {


    if ([self.leftBtn.titleLabel.text  isEqual: @"下一章"]){
      
        [self.storyDevelopArray addObject:[NSString stringWithFormat:@"下一章还在创作中，欢迎大家提供更精彩的故事"]];
       
        
        [self.storyTableView reloadData];
        [self setFlush];

    } else {
    
    add = self.leftBtn.tag;
    tempAdd = tempAdd + add;

    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    [self.storyDevelopArray addObject:[NSString stringWithFormat:@"⎡%@⎦",self.leftBtn.titleLabel.text ]];
    [self storeUserStory:self.storyDevelopArray];

    
    [self.leftBtn setTitle:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:nil forState:UIControlStateNormal];
        
    [self.storyTableView reloadData];

    [self setFlush];

    [self startTimer];
    }

}

//右边点击按钮
- (IBAction)rightBtnClick:(UIButton *)rightBtn {

    if ([self.rightBtn.titleLabel.text  isEqual: @"头，给个好评吧！"]){
        [self.storyDevelopArray addObject:[NSString stringWithFormat:@"快加微信“i96579207”，加入《线索》微信群吧！"]];
//        [self storeUserStory:self.storyDevelopArray];

        [self.storyTableView reloadData];
        [self setFlush];

    } else {
    
    //TODO:button为结案时
    if ([self.rightBtn.titleLabel.text  isEqual: @"结案"]){
        //TODO：弹出提示框，显示分数，分数即IQ
        //停止计时器
        //分数= 196- 选错的线索数*20 - 从故事结束后到点击结案的时间
        NSSet *keyOfUser = [NSSet setWithArray:[GlobalVariable getHinterArray]];
      
        if ([self.clueToSolvingCaseSet isSubsetOfSet:keyOfUser]&([self.suspectsTextField.text  isEqual: @"百里戚"])&(keyOfUser.count < 19)) {
            
            //TODO：计算分数
            float timeScore =  [AppDelegate APP].gameTime;
            if (timeScore > 3600.0) {
                timeScore = 3600;
            }

            float score = 196 - timeScore/60 - (keyOfUser.count + self.clueToSolvingCaseSet.count) * 20;
            if (score < 0) {
                score = 0;
            }

            [self.storyDevelopArray addObject:[NSString stringWithFormat:@"恭喜头，以%.2f的IQ成功破案",score]];
//            [self storeUserStory:self.storyDevelopArray];

            
            [self.storyTableView reloadData];
            [self setFlush];
            [self.rightBtn setTitle:@"头，给个好评吧！" forState:UIControlStateNormal];

        } else {
        //获取时间
                [self.storyDevelopArray addObject:[NSString stringWithFormat:@"头，线索还不完整，再整理整理线索吧"]];
        [self.storyTableView reloadData];
        [self setFlush];
        }

    } else {

    add = self.rightBtn.tag;
    tempAdd = tempAdd + add;


    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    
    [self.storyDevelopArray addObject:[NSString stringWithFormat:@"⎡%@⎦",self.rightBtn.titleLabel.text ]];
    [self storeUserStory:self.storyDevelopArray];

        
    [self.leftBtn setTitle:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:nil forState:UIControlStateNormal];
   
    [self.storyTableView reloadData];
    [self setFlush];
        
    [self startTimer];
    }
    }
}

//添加线索按钮
- (IBAction)addHinterBtnClick:(UIButton *)addHinterBtn {
    NSIndexPath *tempIndexPath = [self.storyTableView indexPathForCell:(StoryDevelopCell*)addHinterBtn.superview.superview];
    NSString *hinter = self.storyDevelopArray[tempIndexPath.row];
    
    if ([addHinterBtn.titleLabel.text  isEqual: @"+"]){
            [self.hinterTempArray addObject:hinter];
        
            [GlobalVariable setHinterArray:self.hinterTempArray];
        [addHinterBtn setTitle:@"-" forState:UIControlStateNormal];

    } else {
        [self.hinterTempArray removeObject:hinter];
        [GlobalVariable setHinterArray:self.hinterTempArray];
        [addHinterBtn setTitle:@"+" forState:UIControlStateNormal];
        
    }
    
    
 
}

//线索收集面板按钮
- (IBAction)hinterCollectClick:(UIButton *)hinterCollectBtn {
    //改变按钮样式
    [hinterCollectBtn setSelected:!hinterCollectBtn.isSelected];
    
    //创建弹出的控制器
    HinterCollectedVC * hinterCollectedVC = [[HinterCollectedVC alloc] init];
    //设置弹出控制器的属性
        //设置model方式
    [hinterCollectedVC setModalPresentationStyle:UIModalPresentationCustom];
    
    hinterCollectedVC.transitioningDelegate = self;
    //弹出控制器
    [self presentViewController:hinterCollectedVC animated:YES completion:nil];
}

//TODO:重新开始
- (IBAction)restartStory:(UIButton *)sender {
    [self restart];
}

- (void)restart{
    self.storyDevelopArray = [NSMutableArray array];
    self.hinterTempArray = [NSMutableArray array];
    [GlobalVariable setHinterArray:self.hinterTempArray];
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    [self.leftBtn setTitle:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:nil forState:UIControlStateNormal];
    tempAdd = 0;
    [self.storyTableView reloadData];
    [self startTimer];

}

#pragma mark - 转场代理及动画
//改变弹出位置及尺寸
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(nonnull UIViewController *)source{
    return [[WWHPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}



@end
