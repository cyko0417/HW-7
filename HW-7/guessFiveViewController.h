//
//  guessFiveViewController.h
//  HW-7
//
//  Created by  Chih-Yu Ko on 2018/4/28.
//  Copyright © 2018年 Oath. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PLAYER {
    NONE,
    COMPUTER,
    USER
};

@interface guessFiveViewController : UIViewController {
    
    __weak IBOutlet UISegmentedControl *segCompCall;
    __weak IBOutlet UISegmentedControl *segCompShow;
    
    
    __weak IBOutlet UISegmentedControl *segUserCall;    
    __weak IBOutlet UISegmentedControl *segUserShow;
    
    __weak IBOutlet UILabel *labelTurn;
    __weak IBOutlet UILabel *labelResult;
    
    __weak IBOutlet UIButton *buttonStart;
    
    enum PLAYER currentPlayer;
    BOOL startPushed;
}
    


@end
