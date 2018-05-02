//
//  Card.m
//  HW-7
//
//  Created by  Chih-Yu Ko on 2018/4/29.
//  Copyright © 2018年 Oath. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)initWithId: (int)id {
    self = [super init];
    if (self) {
        self->cardId=id;
    }
    return self;
}

- (NSString *)getSuit {
    NSString *suit;
    switch((int)(cardId/13)) {
        case 0:
            suit=@"♠️";
            break;
        case 1:
            suit=@"♥️";
            break;
        case 2:
            suit=@"♦️";
            break;
        case 3:
            suit=@"♣️";
            break;
    };
    return suit;
}

- (int) getValue {
    int tmp=cardId%13;
    
    switch(tmp) {
        case 0:
            return 1;
        case 9:
        case 10:
        case 11:
        case 12:
            return 10;
        default:
            return tmp+1;
    }
}

- (NSString *)getPorkValue {
    int tmp=cardId%13;
    NSString *value;
    if (tmp==0)
        value=@"A";
    else if (tmp==10)
        value=@"J";
    else if (tmp==11)
        value=@"Q";
    else if (tmp==12)
        value=@"K";
    else
        value=[NSString stringWithFormat:@"%d", tmp+1];
    
    return value;
}


- (NSString *)getSymbol {
    return [NSString stringWithFormat:@"%@%@", [self getSuit], [self getPorkValue]];
}


@end
