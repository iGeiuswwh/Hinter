//
//  HinterCollectedVC.m
//  Hinter
//
//  Created by igenius on 2016/11/16.
//  Copyright © 2016年 wenhao_wang. All rights reserved.
//

#import "HinterCollectedVC.h"
#import "GlobalVariable.h"

@interface HinterCollectedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) UITableView *hinterCollected;
@property (nonatomic ,strong) NSMutableArray *hinterArray;

@end

@implementation HinterCollectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *hinterCollected = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 92, self.view.frame.size.height -180)];
    hinterCollected.delegate = self;
    hinterCollected.dataSource = self;
    self.hinterCollected = hinterCollected;
    self.hinterCollected.backgroundColor = [UIColor clearColor];
    self.hinterCollected.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hintCollectedBGI.png"]];
    [self.view addSubview:hinterCollected];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [GlobalVariable getHinterArray].count;

}

#pragma mark - TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"HinterCell";
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
    cell.textLabel.text = [GlobalVariable getHinterArray][indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
