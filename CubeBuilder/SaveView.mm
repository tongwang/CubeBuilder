//
//  SaveView.m
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "SaveView.h"
#include "Model.h"
#include "SaveDataModel.h"
#import "ASIFormDataRequest.h"
#include <sstream>


@implementation SaveView
@synthesize saveOnlineBtn;
@synthesize saveAsNewBtn;
@synthesize imageView;
@synthesize progressIndicator;
@synthesize saveBtn;
@synthesize textField;

@synthesize request;

- (IBAction)cancel:(id)sender{Model::getInstance()->cancelOverlay();}
-(IBAction)save:(id)sender
{
    
    int *cubeData =Model::getInstance()->cubeHandler->getCubeData();
    int size  = Model::getInstance()->cubeHandler->cubes.size()*4;
       NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:size];
    for ( int i = 0 ; i < size; i ++ )
        [array addObject:[NSNumber numberWithInt:cubeData[i]]];

        
        
    NSData *img = UIImagePNGRepresentation(self.imageView.image);
   
    NSData *cube= [NSKeyedArchiver archivedDataWithRootObject:array];
  
    if (Model::getInstance()->currentLoadID ==-1)
    {
        [[SaveDataModel getInstance] saveData:img cubeData:cube ];
    }else
    {
    
      [[SaveDataModel getInstance] saveDataCurrent:img cubeData:cube ];
    }
    Model::getInstance()->cancelOverlay();
    [saveBtn setEnabled:false];
    //[[SaveDataModel getInstance] getAllData];

}
-(IBAction)saveAsNew:(id)sender
{
   

    int *cubeData =Model::getInstance()->cubeHandler->getCubeData();
    int size  = Model::getInstance()->cubeHandler->cubes.size()*4;
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:size];
    for ( int i = 0 ; i < size; i ++ )
        [array addObject:[NSNumber numberWithInt:cubeData[i]]];
    
    
    
    NSData *img = UIImagePNGRepresentation(self.imageView.image);
   
    NSData *cube= [NSKeyedArchiver archivedDataWithRootObject:array];
    
    
    [[SaveDataModel getInstance] saveData:img cubeData:cube ];
    
    Model::getInstance()->cancelOverlay();
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    Model * model =Model::getInstance();
   model->isDirty =true;
   
      GLubyte *pixeldata  = model->pixeldata;
    GLubyte *buffer2 = (GLubyte *) malloc(768*768*4);
   
    int wS;
    int hS;
    int pW = model->pixelW;
    if ( model->pixelW ==1024)
    {
        wS = 0;
        hS =119;
    
    }else
    {
        wS = 119;
        hS =0;

    
    }
   
    int h =768;
    int w =768;
    int countX =0;
    int countY =0;
    int yr = 0;
    int xr =0;
    for(int y = wS; y <h+wS; ++y)
    {
        xr = ( w-1- countY) * h  * 4;
        yr = y * 4 * pW;
        for(int x = hS*4; x <(w+hS)* 4; ++x)
        {
            
            buffer2[xr + countX ] = pixeldata [yr + x];
                countX++;
        }
        countX =0;
        countY++;
    }
    delete [] pixeldata;
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, 768*1024*4, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w , h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
    int rw=310;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, rw, rw, 8, 4 * rw, colorSpaceRef, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, rw, rw), imageRef);
     CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:ref];
 
    
 
    CGContextRelease(bitmap );
    
    
    CGImageRelease(imageRef);
    
    CGDataProviderRelease(provider);
    
    
    [imageView setImage:myImage];  
    
    delete [] buffer2;
   // [myImage release];
    
    if ( Model::getInstance()->currentLoadID ==-1)
    {
        [saveAsNewBtn setHidden:true];
    }else
    {
    
        [saveAsNewBtn setHidden:false];
    
    }
  // delete [] buffer2;
    
   //[myImage release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(void) dealloc
{
    [ saveOnlineBtn release];
    [ saveAsNewBtn release];
    [ imageView release];
    [ progressIndicator release];
    [saveBtn release];
    [ textField release];
   //[saveAsNewBtn release];
   // [imageView release];
    [super dealloc];

}





-(IBAction)resignFR :(id)sender
{

    [sender resignFirstResponder]; 
}


-(IBAction)saveOnline:(id)sender
{
    
    if([textField.text isEqualToString: @""]){textField.text =@"Anonymous";} ;
    
    ///
    
    
        [progressIndicator setHidden:false];
      [saveOnlineBtn setEnabled:false];
    
    int *cubeData =Model::getInstance()->cubeHandler->getCubeData();
   int size  = Model::getInstance()->cubeHandler->cubes.size()*4;
    
    string str;
    stringstream outS;
    for ( int i = 0 ; i < size; i ++ ){
        outS << cubeData[i] <<" ";
    }
    str= outS.str();
    const char* cstr1 = str.c_str();
    
    
    NSString* strNS= [NSString stringWithUTF8String:cstr1];
    
	NSData *cube= [strNS dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    
    
   
    
    NSData *img = UIImageJPEGRepresentation(self.imageView.image,0.8);
    
     
    
    NSString *pathData = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"dataTemp.txt"];
	[cube writeToFile:pathData atomically:NO ];
    
    
    
    NSString *pathImage = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"imgTemp.jpg"];
	[img writeToFile:pathImage atomically:NO];
    int r =rand();
    
    NSString *rString = [NSString stringWithFormat:@"%d", r];
    NSString *tempString = [NSString stringWithFormat:@"developer%d", r];
    
    
    NSString *hString =[self MD5:tempString];
    
  [request cancel];
	[self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://cubeconstruct.net/process"]]];
	[request setPostValue:textField.text forKey:@"name"];
	[request setPostValue:rString forKey:@"r"];
    [request setPostValue:hString forKey:@"h"];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
	[request setUploadProgressDelegate:progressIndicator];
	[request setDelegate:self];
	[request setDidFailSelector:@selector(downloadFailed:)];
	[request setDidFinishSelector:@selector(downloadFinished:)];
	[request setTimeOutSeconds:20];
	
    [request setFile:pathImage forKey:@"image"];
	[request setFile:pathData forKey:@"data"];

	
	[request startAsynchronous];
	//[resultView setText:@"Uploading data..."];


}
- (NSString*)MD5:(NSString *)s
{
    // Create pointer to the string as UTF8
    const char *ptr = [s UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (void)downloadFailed:(ASIHTTPRequest *)theRequest
{
   
    [progressIndicator setHidden:true];
    Model::getInstance()->cancelOverlay();

    UIAlertView *alert  =[[UIAlertView alloc] initWithTitle:@"Sorry :)" message:@"I can't seem to connect to the server, you need to be online to save to the public gallery" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

    
    [alert show];
    [alert release];
}

- (void)downloadFinished:(ASIHTTPRequest *)theRequest
{


    [progressIndicator setHidden:true];
    Model::getInstance()->cancelOverlay();
}

@end
