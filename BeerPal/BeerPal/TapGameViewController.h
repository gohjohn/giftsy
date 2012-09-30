//
//  TapGameViewController.h
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "BeerItemViewController.h"
#import "PauseViewController.h"
#import "EndGameViewController.h"
#import "CheckViewController.h"

typedef enum {
  kPlaying,
  kEnded
} GameState;

typedef enum {
  kSingle,
  kMultiplayer
} GameMode;

@interface TapGameViewController : UIViewController <tapGame, pauseActions, endActions, GKSessionDelegate, GKPeerPickerControllerDelegate> {
  
  NSMutableArray *beerArray;
  int numberOfBeersTapped;
  IBOutlet UILabel *scoreLabel;
  IBOutlet UIImageView *background;
  PauseViewController *pausevc;
  EndGameViewController *endvc;
  IBOutlet UILabel *timeLabel;
  NSTimer *gametimer;
  int timeLeft;
  int opponentScore;
  
  GameState gamestate;
  GameMode gamemode;
  BOOL receivedOppResult;
  
  GKSession *gameSession;
	// PeerPicker Object
	GKPeerPickerController *peerPicker;
  NSMutableArray *gamePeers;
}

@end
