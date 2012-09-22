//
//  DrinkGameViewController.m
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "DrinkGameViewController.h"
#define POST_FILE_NAME @""
#define NO_BEER_IMGS 11

@interface DrinkGameViewController (){
    
    __weak IBOutlet UIButton *btnLeft;
    __weak IBOutlet UIButton *btnRight;
    __weak IBOutlet UIImageView *imgDrink;
    __weak IBOutlet UILabel *lblScore;
    __weak IBOutlet UILabel *lblSwipe;
    
    int turnState;
    int score;
    int turnScore;
    CGPoint originalCenter;
    NSMutableArray *beerImages;
    UISwipeGestureRecognizer *swipeLeftRight, *swipeUpDown;
}

@end

@implementation DrinkGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)rightPressed:(UIButton *)sender {
    
    if(turnState==2){
        [self loseScore];
    }else [self addScore];
    turnState = 2;
}
- (IBAction)leftPressed:(UIButton *)sender {
    if(turnState==1){
        [self loseScore];
    }else [self addScore];
    turnState = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    score = 0;
    
    swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    
    swipeUpDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUpDown setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown )];
    
    
    [self loadImages];
    [self nextBottle];
}

-(void)removeGestures{
    
    [imgDrink removeGestureRecognizer:swipeLeftRight];
    [imgDrink removeGestureRecognizer:swipeUpDown];
}
-(void)addGestures{
    
    [imgDrink addGestureRecognizer:swipeLeftRight];
    [imgDrink addGestureRecognizer:swipeUpDown];
    [self.view setUserInteractionEnabled:YES];
    [imgDrink setUserInteractionEnabled:YES];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received.");
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         imgDrink.center = CGPointMake(imgDrink.center.x-600, imgDrink.center.y);
                     }
                     completion:^(BOOL finished){
                         [self nextBottle];
                     }];
}

- (void)loadImages{
    beerImages = [NSMutableArray array];
    for(int i=NO_BEER_IMGS-1;i>=0;i--){
        NSString* fileName = [NSString stringWithFormat:@"%d%@",i,POST_FILE_NAME];
        NSLog(@"%@",fileName);
        UIImage *img = [UIImage imageNamed:fileName];
        [beerImages addObject:img];
    }
    originalCenter = imgDrink.center;
}

- (void)nextBottle{
    turnState = 0;
    turnScore = 0;
    [self removeGestures];
    [self updateDisplay];
}

- (void)updateDisplay{
    [lblSwipe setHidden:YES];
    [btnLeft setHidden:NO];
    [btnRight setHidden:NO];
    NSString *strScore = [NSString stringWithFormat:@"Score: %d",score];
    [lblScore setText:strScore];
    [imgDrink setImage:[beerImages objectAtIndex:turnScore]];
    imgDrink.center = originalCenter;
    [imgDrink setNeedsDisplay];
    if(turnScore == NO_BEER_IMGS -1){
        [btnLeft setHidden:YES];
        [btnRight setHidden:YES];
        [lblSwipe setHidden:NO];
        [self addGestures];
    }
}

- (void)addScore{
    turnScore++;
    score++;
    [self updateDisplay];
}
- (void)loseScore{
    turnScore = MAX(turnScore-1,0);
    score = MAX(score-1,0);
    [self updateDisplay];
}

- (void)viewDidUnload
{
    btnRight = nil;
    btnLeft = nil;
    imgDrink = nil;
    lblScore = nil;
    lblSwipe = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
