//
//  TwentyOneViewController.h
//  HW-7
//
//  Created by  Chih-Yu Ko on 2018/4/29.
//  Copyright © 2018年 Oath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface TwentyOneViewController : UIViewController {
    
    // 莊家的籌碼
    __weak IBOutlet UILabel *labelComputerScore;
    // 玩家的籌碼
    __weak IBOutlet UILabel *labelUserScore;
    // 完家下注
    __weak IBOutlet UILabel *labelUserBet;
    // 下注的 stepper
    __weak IBOutlet UIStepper *stepperBet;
    // 發牌
    __weak IBOutlet UIButton *buttonStart;
    // 再一張
    __weak IBOutlet UIButton *buttonOneMore;
    // 停止
    __weak IBOutlet UIButton *buttonStop;
    // 顯示莊家的牌
    IBOutletCollection(UILabel) NSArray *labelComputerCards;
    // 顯示玩家的牌
    IBOutletCollection(UILabel) NSArray *labelUserCards;
    // 顯示結果
    __weak IBOutlet UILabel *labelResult;
    
    
    int computerScore;
    int userScore;
    int userBet;
    NSString *msg;
    
    NSMutableArray *cards; // 放洗好的牌
    NSMutableArray *computerCards; // 電腦的牌
    NSMutableArray *userCards; // 玩家的牌
    int cardIndex; // 目前抽到哪張牌
    
    
    

    
    __weak IBOutlet UILabel *labelBet;
    
    
    
    
}

@end
