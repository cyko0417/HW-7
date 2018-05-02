//
//  Card.h
//  HW-7
//
//  Created by  Chih-Yu Ko on 2018/4/29.
//  Copyright © 2018年 Oath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject {

    int cardId;
    
}

- (instancetype)initWithId: (int)id;

- (int) getValue;
// 取得花色 (♠️...)
- (NSString *)getSuit;
// 取得撲克牌數值 (A, 1, 2,...10, J, Q, K)
- (NSString *)getPorkValue;
// 取得花色+數值 (♠️Q)
- (NSString *)getSymbol;

@end
