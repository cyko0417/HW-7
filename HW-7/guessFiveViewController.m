//
//  guessFiveViewController.m
//  HW-7
//
//  Created by  Chih-Yu Ko on 2018/4/28.
//  Copyright © 2018年 Oath. All rights reserved.
//

#import "guessFiveViewController.h"
@import GameplayKit;

@interface guessFiveViewController ()

@end

@implementation guessFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) initGame {
    [self decideTurn];
    [self resetControl];
    [self showTurn];
    startPushed=false;
}

// 決定誰先喊/換誰喊
- (void) decideTurn {
    if (currentPlayer==COMPUTER) {
        currentPlayer=USER;
    }
    else if (currentPlayer==USER) {
        currentPlayer=COMPUTER;
    }
    else { // NONE
        GKRandomDistribution *distribution = [GKRandomDistribution distributionWithLowestValue:0 highestValue:1];
        NSInteger tmp=[distribution nextInt];
        
        if (tmp==0)
            currentPlayer=COMPUTER;
        else
            currentPlayer=USER;
    }
    //segCompCall.hidden=(currentPlayer!=COMPUTER);
    segUserCall.enabled=(currentPlayer==USER);
}

// 還原各 control 的狀態
- (void) resetControl {
    // 不能讓 user 點選電腦的 segment
    segCompCall.enabled=false;
    segCompShow.enabled=false;
    
    // 清空訊息
    labelResult.text=@"";
    
    // 根據狀況決定玩家的按鈕是否可以動
    segUserCall.enabled=(currentPlayer==USER);
    segUserShow.enabled=true;
    
    buttonStart.enabled=true;
}

// 在上方顯示輪到誰喊拳
- (void) showTurn {
    NSString *player = (currentPlayer==COMPUTER) ? @"電腦" : @"玩家";
    labelTurn.text=[NSString stringWithFormat:@"現在輪到 %@ 喊拳", player ];
}

// 按 Start 後的動作
- (IBAction)startButtonPushed:(id)sender {
    // 想要在按鈕被按下後到顯示結果前讓按鈕失效(避免玩家連續按)，但連帶使 UI 不能動，要再想法子解決。
    if (startPushed)
        return;
    
    startPushed=true;
    // 以下設定都會讓 UI 不能動，所以拿掉
    //buttonStart.enabled=false;
    //labelResult.text=nil;
    [self guessForComputer];
    [self judgeResult];
    //buttonStart.enabled=true;
    startPushed=false;
}

- (void) guessForComputer {
    GKRandomDistribution *distribution = [GKRandomDistribution distributionWithLowestValue:0 highestValue:4];
    
    // 先決定要喊什麼
    NSInteger call=[distribution nextInt];

    // 再根據喊的內容決定可以出什麼
    NSInteger show;
    while (true) {
        show=[distribution nextInt];
        if (show<=segCompShow.numberOfSegments-1 && show<=call && show>=(call-2)) {
            break;
        }
    }
    
    //NSLog(@"=========== pass to func: %ld, %ld", call, show);
    [self showComputerGuess:call show:show];
}

- (void) showComputerGuess: (NSInteger)call show:(NSInteger) show {
    GKRandomDistribution *distribution = [GKRandomDistribution distributionWithLowestValue:0 highestValue:4];
    NSInteger index;
    
    // 用迴圈隨變顯示 call 及 show 增加懸疑性
    for (int i=0; i<5; i++) {
        if (currentPlayer==COMPUTER) {
            index=[distribution nextInt];
            [segCompCall setSelectedSegmentIndex:index];
            //NSLog(@"call=%ld", index);
            //usleep(200000);
        }
        index=[distribution nextInt];
        while (index>segCompShow.numberOfSegments-1) {
            index=[distribution nextInt];
        }
        [segCompShow setSelectedSegmentIndex:index];
        //NSLog(@"show=%ld", index);
        usleep(200000);
    }
    
    // 最後顯示電腦真正的選擇
    if (currentPlayer==COMPUTER) {
        [segCompCall setSelectedSegmentIndex:call];
        //NSLog(@"Final call=%ld", call);
    }
    [segCompShow setSelectedSegmentIndex:show];
    //NSLog(@"Final show=%ld", show);
}

- (void) judgeResult {
    NSInteger call=(currentPlayer==COMPUTER) ? segCompCall.selectedSegmentIndex : segUserCall.selectedSegmentIndex;
    NSInteger computerShow = segCompShow.selectedSegmentIndex;
    NSInteger userShow = segUserShow.selectedSegmentIndex;
    
    NSString *win = (call==(computerShow+userShow)) ? @" 贏了" : @"";
    
    NSString *msg;
    if (currentPlayer==COMPUTER) {
        msg=[NSString stringWithFormat:@"電腦喊%ld 電腦出%ld 玩家出%ld", call*5, computerShow*5, userShow*5];
    }
    else {
        msg=[NSString stringWithFormat:@"玩家喊%ld 電腦出%ld 玩家出%ld", call*5, computerShow*5, userShow*5];
    }

    if (win.length>0)
        msg = [msg stringByAppendingString: win];
    
    
    if (win.length>0) {
        buttonStart.enabled=false;
        segUserCall.enabled=false;
        segUserShow.enabled=false;
        labelResult.text=msg;
    } else {
        [self initGame];
        labelResult.text=msg;
    }
}

- (IBAction)restartButtonPushed:(id)sender {
    [self initGame];
}

@end
