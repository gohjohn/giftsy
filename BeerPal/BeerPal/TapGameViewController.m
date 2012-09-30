//
//  TapGameViewController.m
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "TapGameViewController.h"
#import "MenuViewController.h"

@interface TapGameViewController ()

@end

@implementation TapGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  peerPicker = [[GKPeerPickerController alloc] init];
	peerPicker.delegate = self;
  
  peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;

  
  pausevc = [[PauseViewController alloc] init];
  pausevc.delegate = self;
  
  endvc = [[EndGameViewController alloc] init];
  endvc.delegate = self;
  
  numberOfBeersTapped = 0;
  beerArray = [[NSMutableArray alloc] init];
  
  self.view.userInteractionEnabled = YES;
  background.userInteractionEnabled = YES;
  [self displayBeer];
  
  [peerPicker show];
  
  gamePeers = [NSMutableArray array];
  gamestate = kPlaying;
  
  gamemode = kSingle;
  receivedOppResult = NO;
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
  [self startGame];
}

- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state{
  
	if(state == GKPeerStateConnected){
    gamemode = kMultiplayer;
		// Add the peer to the Array
		[gamePeers addObject:peerID];
    
//		NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
		
		// Used to acknowledge that we will be sending data
		[session setDataReceiveHandler:self withContext:nil];
		[self startGame];
	}
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker
           sessionForConnectionType:(GKPeerPickerConnectionType)type {
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
	GKSession* session = [[GKSession alloc] initWithSessionID:@"com.vivianaranha.sendfart" displayName:nil sessionMode:GKSessionModePeer];
  return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *)session{
	
	// Get the session and assign it locally
  gameSession = session;
  session.delegate = self;
  [picker dismiss];
  //No need of teh picekr anymore
	picker.delegate = nil;
}

- (void)sendScore:(id)sender{
	// Making up the Loud Fart sound :P
	NSString *score = [NSString stringWithFormat:@"%i", numberOfBeersTapped];
	
	// Send the fart to Peers using teh current sessions
	[gameSession sendData:[score dataUsingEncoding: NSASCIIStringEncoding] toPeers:gamePeers withDataMode:GKSendDataReliable error:nil];
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context {
	//Convert received NSData to NSString to display
  NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	//Dsiplay the fart as a UIAlertView
  opponentScore = [whatDidIget intValue];
  NSLog(@"opponent score: %d", opponentScore);
  receivedOppResult = YES;
  
  if (gamestate == kEnded) {
    [self decideGameOutcome];
  } 
}

- (void)decideGameOutcome {
  if (numberOfBeersTapped < opponentScore) {
    NSLog(@"u lose...");
    [self.view addSubview:endvc.view];
    [endvc setLoseImage];
  } else {
    NSLog(@"u win!");
    [self.view addSubview:endvc.view];
  }
}

- (void)updateTime {
  timeLeft--;
  timeLabel.text = [NSString stringWithFormat:@"%d", timeLeft];
  if (timeLeft == 0) {
    gamestate = kEnded;
    [gametimer invalidate];
    [self sendScore:nil];
    if (receivedOppResult) {
      [self decideGameOutcome];
    }
  }
}

- (void)startGame {
  
  timeLeft = 21;
  gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
  
  [gametimer fire];
}

- (void)yes {
  [pausevc.view removeFromSuperview];
//  CheckViewController *checkoutvc = [[CheckViewController alloc] init];
//  [checkoutvc loadItem:@"beer" Price:1010 Qn:2];
//  [self presentModalViewController:checkoutvc animated:YES];
  
  MenuViewController *menuvc = [[MenuViewController alloc] init];
  [self presentModalViewController:menuvc animated:YES];
}

- (void)no {
  [pausevc.view removeFromSuperview];
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:NO completion:^(void){}];
}


- (void)displayBeer {
  for (int i = 0; i < 5; i++) {
    BeerItemViewController *beervc = [[BeerItemViewController alloc] init];
    beervc.delegate = self;
    [beerArray addObject:beervc];
    beervc.view.center = CGPointMake(20 + arc4random() % 420, 195);
    NSLog(NSStringFromCGPoint(beervc.view.center));
    [background addSubview:beervc.view];
  }
}

- (void)increaseCount:(id)sender {
  numberOfBeersTapped++;
  [((UIViewController*)sender).view removeFromSuperview];
  scoreLabel.text = [NSString stringWithFormat:@"%d", numberOfBeersTapped];
  [beerArray removeObject:(BeerItemViewController*)sender];
  if (numberOfBeersTapped % 5 == 0) {
//    NSLog(@"display beer");
    [self displayBeer];
  }
}

- (IBAction)pause:(id)sender {
  [self.view addSubview:pausevc.view];
  [gametimer invalidate];
}

- (void)resume {
  gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
  [gametimer fire];
}

- (void)clearBeers {
  for (int i = 0; i < [beerArray count]; i++) {
    [((UIViewController*)[beerArray objectAtIndex:i]).view removeFromSuperview];
  }
}

- (void)quit {
  [pausevc.view removeFromSuperview];
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:NO completion:^(void){}];
}

- (void)restart {
  [gametimer invalidate];
  [pausevc.view removeFromSuperview];
  [self clearBeers];
  timeLeft = 21;
  timeLabel.text = @"21";
  numberOfBeersTapped = 0;
  scoreLabel.text = @"0";
  [self displayBeer];
  gametimer = nil;
  gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
  [gametimer fire];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
