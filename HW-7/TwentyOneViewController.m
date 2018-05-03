//
//  TwentyOneViewController.m
//  HW-7
//
//  Created by  Chih-Yu Ko on 2018/4/29.
//  Copyright © 2018年 Oath. All rights reserved.
//

#import "TwentyOneViewController.h"
#import "Card.h"
@import GameplayKit;

@interface TwentyOneViewController ()

@end

@implementation TwentyOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    computerScore=1000;
    userScore=1000;
    userBet=0;
    cardIndex=0;
    
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


- (void)initGame {
    [self setControl];
    [self cardsShuffler];
    [self displayStatus];
    
    stepperBet.enabled=false;
    [stepperBet setValue:0];
    computerCards = [[NSMutableArray alloc] init];
    userCards = [[NSMutableArray alloc] init];
}

- (void)setControl {
    stepperBet.maximumValue=userScore;
    userBet=0;
    
    stepperBet.enabled=false;
    buttonStart.enabled=true;
    labelBet.enabled=false;
    buttonOneMore.enabled=false;
    buttonStop.enabled=false;
    labelResult.text=@" ";
    
    [self clearAllCards];
}

- (void)cardsShuffler {
    cards=[[NSMutableArray alloc] init];
    GKShuffledDistribution *distribution = [GKShuffledDistribution distributionWithLowestValue:0 highestValue:51];
    for (int i=0; i<52; i++) {
        NSInteger tmp=[distribution nextInt];
        Card *tmpCard=[[Card alloc] initWithId:(int)tmp];
        [cards addObject:tmpCard];
        //NSLog(@"%d => %@", i, [tmpCard getSymbol]);
    }
}

- (void)displayStatus {
    labelComputerScore.text=[NSString stringWithFormat:@"莊家的籌碼：%d", computerScore];
    labelUserScore.text=[NSString stringWithFormat:@"玩家的籌碼：%d", userScore-userBet];
    labelUserBet.text=[NSString stringWithFormat:@"下注：%d", userBet];
}

// ===== 開始玩的頁面 =====
// 按「發牌」
- (IBAction)startButtonPushed:(id)sender {
    //card
    [computerCards addObject: cards[0]];
    [cards removeObjectAtIndex:0];
    [userCards addObject:cards[0]];
    [cards removeObjectAtIndex:0];
    //NSLog(@"%@", [computerCards[0] getSymbol]);
    //NSLog(@"%@", [userCards[0] getSymbol]);
    buttonStart.enabled=false;
    labelBet.enabled=true;
    stepperBet.enabled=true;
    [self displayCards];

}

// 調整下注金額
- (IBAction)stepperBetPushed:(UIStepper *)sender {
    userBet=sender.value;
    [self displayStatus];
    if (userBet>0) {
        labelBet.enabled=false;
        buttonOneMore.enabled=true;
    }
    else {
        labelBet.enabled=true;
        buttonOneMore.enabled=false;
    }
}

// 按「再一張」
- (IBAction)oneMoreButtonPushed:(id)sender {
    // 莊家只有在第一次按時才會補一張
    if (computerCards.count==1) {
        [computerCards addObject: cards[0]];
        [cards removeObjectAtIndex:0];
    }
    // 玩家是每次按每次補
    [userCards addObject:cards[0]];
    [cards removeObjectAtIndex:0];
    int userValue=[self getValueof:userCards];
    if (computerCards.count>=5) {
        buttonOneMore.enabled=false;
    }
    // 超過 16 點就可以停
    if (userValue>16) {
        buttonStop.enabled=true;
        // 超過 21 點就不能再要牌了
        if (userValue>21) {
            buttonOneMore.enabled=false;
        }
    }
   
    // 超過 5 張就不能再要牌了
    if (userCards.count>=5) {
        buttonOneMore.enabled=false;
        buttonStop.enabled=true;
    }
    
    // 按「再一張」就不能更改籌碼了
    stepperBet.enabled=false;
    [self displayCards];
    //NSLog(@"%@", [computerCards[0] getSymbol]);
    //NSLog(@"%@", [userCards[0] getSymbol]);
    
    if (userCards.count==2)
        [self judgeResult1];
    else
        [self judgeResult2];
}

// 計算莊家或玩家手上的點數
- (int)getValueof: (NSMutableArray *)cards {
    // 取出所有牌，因為要 addObject，所以要用 MutableArray
    NSMutableArray *tmp1=[[NSMutableArray alloc] init];
    for (int i=0; i<cards.count; i++) {
        [tmp1 addObject:[NSNumber numberWithInt:[cards[i] getValue]]];
    }
    // 為了計算方便，把牌由大到小牌好(因為 A 可以代表 1 或 11)
    NSArray<NSNumber *> *tmp2=[tmp1 sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    //
    int rc=0;
    for (int i=0; i<tmp2.count; i++) {
        int tmp3=(int)[tmp2[i] integerValue];
        if (tmp3!=1) {
            rc+=tmp3;
        }
        else {
            if (rc+11<=21)
                rc+=11;
            else
                rc+=1;
        }
    }

    //NSLog(@"%d", rc);
    return rc;
}

// 電腦補牌
- (IBAction)stopButtonPushed:(id)sender {
    int computerValue=[self getValueof:computerCards];
    int userValue=[self getValueof:userCards];

    BOOL done=false;
    while (!done) {
        // 不到 16 點一定要補
        if (computerValue<=16) {
            NSLog(@"莊家點數 %d，不到 17 ，再補一張", computerValue);
            [computerCards addObject: cards[0]];
            [cards removeObjectAtIndex:0];
            computerValue=[self getValueof:computerCards];
        }
        // 點數比玩家小，補
        if (computerValue<=21 && computerValue<userValue) {
            NSLog(@"莊家點數 %d 小於玩家點數 %d ，再補一張", computerValue, userValue);
            [computerCards addObject: cards[0]];
            [cards removeObjectAtIndex:0];
            computerValue=[self getValueof:computerCards];
        }
        else {
            done=true;
        }
        // 翻 5 張了
        if (computerValue>21 || computerCards.count>=5)
            done=true;
        [self displayCards];
        
    }
    [self judgeResult3];
}

- (IBAction)restartButtonPushed:(id)sender {
    [self initGame];
}

// 頭兩張的比較
- (void)judgeResult1 {
    int computerValue=[self getValueof:computerCards];
    int userValue=[self getValueof:userCards];
    int balance=0; // 玩家可得分數

    // 剛發完第二張牌的狀況(要用 user 的牌數來看才準)
    if (userCards.count==2 && computerValue==21) {
        if (userValue!=21) {
            msg=[NSString stringWithFormat:@"莊家 21 點，玩家 %d 點，賠 %d", userValue, userBet*2];
            balance=-userBet*2;
        }
        else {
            msg=[NSString stringWithFormat:@"莊家 21 點，玩家 21 點，賠 %d", userBet];
            balance=-userBet;
        }
        // TODO: 結束的處理
    }
    // 已分出勝負
    if (balance!=0) {
        userScore+=balance;
        computerScore-=balance;
        buttonOneMore.enabled=false;
        buttonStop.enabled=false;
        labelResult.text=msg;
    }
    
}

// 玩家每次補牌後的檢查(檢查有沒有爆)
- (void)judgeResult2 {
    int userValue=[self getValueof:userCards];
    
    if (userValue>21) {
        msg=[NSString stringWithFormat:@"玩家 %d 點爆掉，賠 %d", userValue, userBet];
        userScore+=(-userBet);
        computerScore-=(-userBet);
        buttonOneMore.enabled=false;
        buttonStop.enabled=false;
        labelResult.text=msg;
    }
}

// 莊家補完牌的比較
- (void)judgeResult3 {
    int computerValue=[self getValueof:computerCards];
    int userValue=[self getValueof:userCards];
    int balance=0; // 玩家可得分數
    
    if (userValue>21) {
        msg=[NSString stringWithFormat:@"玩家 %d 點爆掉，賠 %d", userValue, userBet];
        balance=-userBet;
    }
    else if (computerValue>21) {
        msg=[NSString stringWithFormat:@"莊家 %d 點爆掉，賺 %d", computerValue, userBet];
        balance=userBet;
    }
    else if (computerValue>userValue) {
        msg=[NSString stringWithFormat:@"莊家 %d 點勝玩家 %d 點，賠 %d", computerValue, userValue, userBet];
        balance=-userBet;
    }
    else if (computerValue>userValue) {
        msg=[NSString stringWithFormat:@"玩家 %d 點勝莊家 %d 點，賠 %d", userValue, computerValue, userBet];
        balance=userBet;
    }
    
    // 已分出勝負
    if (balance!=0) {
        userScore+=balance;
        computerScore-=balance;
        buttonOneMore.enabled=false;
        buttonStop.enabled=false;
        labelResult.text=msg;
    }
    
}


- (void)displayCards {
    //NSLog(@"Display Cards");
    

    for (int i=0; i<labelComputerCards.count; i++) {
        if (i<computerCards.count) {
            [self displayACard:computerCards[i] at:i inLabel:labelComputerCards hideFirst:true];
        }
        else {
            [self displayANullCard:@"?" at:i inLabel:labelComputerCards];
        }

        //* For debug
        //NSLog(@"  Cards of computer");
        if (i==0)
            NSLog(@"  X index=%d, symbol=%@", i, [computerCards[i] getSymbol]);
        else if (i<computerCards.count)
            NSLog(@"    index=%d, symbol=%@", i, [computerCards[i] getSymbol]);
         //*/
    }
   
    NSLog(@"=====");
    for (int i=0; i<labelUserCards.count; i++) {
        if (i<userCards.count) {
            [self displayACard:userCards[i] at:i inLabel:labelUserCards hideFirst:false];
        }
        else {
            [self displayANullCard:@"?" at:i inLabel:labelUserCards];
        }
        //* For debug
        //NSLog(@"  Cards of user");
        if (i<userCards.count)
            NSLog(@"    index=%d, symbol=%@", i, [userCards[i] getSymbol]);
        //*/
    }
}

- (void) displayACard: (Card *)card at: (int)index inLabel:(NSArray *)labels hideFirst:(BOOL) hide {
    for (UILabel *label in labels) {
        if (label.tag==index) {
            if (index==0 && hide==true)
                label.text=@"X";
            else
                label.text=[card getSymbol];
        }
    }
}

- (void) displayANullCard: (NSString *)symbol at: (int)index inLabel:(NSArray *)labels {
    for (UILabel *label in labels) {
        if (label.tag==index)
            label.text=symbol;
    }
}

-(void) clearAllCards {
    for (UILabel *label in labelComputerCards)
        label.text=@" ";
    for (UILabel *label in labelUserCards)
        label.text=@" ";
}





@end
