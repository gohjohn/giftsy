//
//  BluetoothViewController.m
//  BeerPal
//
//  Created by YangShun on 29/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//
#import "BluetoothViewController.h"

@implementation BluetoothViewController

@synthesize fartSession;

- (void)viewDidLoad {
  [super viewDidLoad];
	
	fartPicker = [[GKPeerPickerController alloc] init];
	fartPicker.delegate = self;
	
	//There are 2 modes of connection type
	// - GKPeerPickerConnectionTypeNearby via BlueTooth
	// - GKPeerPickerConnectionTypeOnline via Internet
	// We will use Bluetooth Connectivity for this example
	
	fartPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	fartPeers=[[NSMutableArray alloc] init];
	
	// Create the buttons
	UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnConnect addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
	[btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
	btnConnect.frame = CGRectMake(20, 100, 280, 30);
	btnConnect.tag = 12;
	[self.view addSubview:btnConnect];
	
}

// Connect to other peers by displayign the GKPeerPicker
- (void) connectToPeers:(id) sender{
	[fartPicker show];
}

- (void) sendALoudFart:(id)sender{
	// Making up the Loud Fart sound :P
	NSString *loudFart = @"Brrrruuuuuummmmmmmppppppppp";
	
	// Send the fart to Peers using teh current sessions
	[fartSession sendData:[loudFart dataUsingEncoding: NSASCIIStringEncoding] toPeers:fartPeers withDataMode:GKSendDataReliable error:nil];
  
}

- (void) sendASilentAssassin:(id)sender{
	// Making up the Silent Assassin :P
	NSString *silentAssassin = @"Puuuuuuuusssssssssssssssss";
	
	// Send the fart to Peers using teh current sessions
	[fartSession sendData:[silentAssassin dataUsingEncoding: NSASCIIStringEncoding] toPeers:fartPeers withDataMode:GKSendDataReliable error:nil];
	
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
	GKSession* session = [[GKSession alloc] initWithSessionID:@"com.vivianaranha.sendfart" displayName:nil sessionMode:GKSessionModePeer];
  return session;
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	// Get the session and assign it locally
  self.fartSession = session;
  session.delegate = self;
  
  //No need of teh picekr anymore
	picker.delegate = nil;
  [picker dismiss];
}

// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	//Convert received NSData to NSString to display
  NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	//Dsiplay the fart as a UIAlertView
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fart Received" message:whatDidIget delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
  
	if(state == GKPeerStateConnected){
		// Add the peer to the Array
		[fartPeers addObject:peerID];
    
		NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
		// Used to acknowledge that we will be sending data
		[session setDataReceiveHandler:self withContext:nil];
		
		[[self.view viewWithTag:12] removeFromSuperview];
		
		UIButton *btnLoudFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btnLoudFart addTarget:self action:@selector(sendALoudFart:) forControlEvents:UIControlEventTouchUpInside];
		[btnLoudFart setTitle:@"Loud Fart" forState:UIControlStateNormal];
		btnLoudFart.frame = CGRectMake(20, 150, 280, 30);
		btnLoudFart.tag = 13;
		[self.view addSubview:btnLoudFart];
		
		UIButton *btnSilentFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btnSilentFart addTarget:self action:@selector(sendASilentAssassin:) forControlEvents:UIControlEventTouchUpInside];
		[btnSilentFart setTitle:@"Silent Assassin" forState:UIControlStateNormal];
		btnSilentFart.frame = CGRectMake(20, 200, 280, 30);
		btnSilentFart.tag = 14;
		[self.view addSubview:btnSilentFart];
	}
	
}

- (IBAction)back:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end
