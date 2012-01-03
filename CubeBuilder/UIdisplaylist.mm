//
//  UIdisplaylist.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 23/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "UIdisplaylist.h"

void UIdisplaylist::setup()
{

    model =Model::getInstance();
    
    
    ImageDataLoader IDloader;
    GLubyte *imagedata;
    
    
    imagedata = IDloader.loadFile(@"mainmap.png");
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, STARTMAP_SIZE_H,STARTMAP_SIZE_W, 0, GL_RGBA, GL_UNSIGNED_BYTE, imagedata);
    
    
    
    
    
    int  posStartX =16;
    int posStartY =64*5 +16;
    int count=0; 
    // 11*7
    for (int i=0;i<7;i++)
    {
         int posY = i*32 +posStartY;
        for (int j=0;j<11;j++)
        {
            int posX = j*32 +posStartX;
            int pos =  (posX+ STARTMAP_SIZE_W *posY)*4;
            
            cbColor c;
            c.colorID = count;
            c.u =((float) posX -16.0);
             c.v =((float) posY -16.0);
            c.set((float)imagedata[pos]/255.0f, (float)imagedata[pos+1]/255.0f, (float)imagedata[pos+2]/255.0f);
            model->colors.push_back(c);
            //cout << "r=" << c.r << " g="<< c.g <<" b="<<c.b <<"\n";
            count++;
        }
    
    
    
    
    }
    
    
    
    
    
    
    
    
    free(imagedata);
   
    
    
   setSize(0,0,NP_ALIGN_TOPLEFT);
   setUVauto(0,0,STARTMAP_SIZE_H,STARTMAP_SIZE_W);


    paintBtn.setup(2);
    addChild(paintBtn);
    makeCallBack( UIdisplaylist,setPaint,paintCall );
    paintBtn.addEventListener("setState", paintCall);
    
    removeBtn.setup(1);
    addChild(removeBtn);
    makeCallBack( UIdisplaylist,setRemove ,removeCall );
    removeBtn.addEventListener("setState", removeCall);
    
    
    addBtn.setup(0);
    addChild(addBtn);
    makeCallBack( UIdisplaylist,setAdd,addCall );
    addBtn.addEventListener("setState", addCall);
    
    rotateBtn.setup(3);
    addChild(rotateBtn);
    makeCallBack( UIdisplaylist,setRotate,rotateCall );
    rotateBtn.addEventListener("setState", rotateCall);
                            
                            
    moveBtn.setup(4);
    addChild(moveBtn);
    makeCallBack( UIdisplaylist,setMove,moveCall );
    moveBtn.addEventListener("setState", moveCall );                      
    
    viewBtn.setup(7);
    addChild(viewBtn);
    makeCallBack( UIdisplaylist,setView,viewCall );
    viewBtn.addEventListener( TOUCH_UP_INSIDE, viewCall );   
    
    
    menuBtn.setup(16);
    addChild(menuBtn);
    makeCallBack( UIdisplaylist,setMenu ,menuCall );
    menuBtn.addEventListener( TOUCH_UP_INSIDE, menuCall );   
    
    redoBtn.setup(6);
    addChild(redoBtn);
    
    undoBtn.setup(5);
    addChild(undoBtn);
    
    
    zoomHolder.setup();
    addChild(zoomHolder);
    
    
    
    
    
    viewMenu.setup();
    addChild(viewMenu);
    
    colorMenu.setup();
    addChild(colorMenu);
    
    menuMenu.setup();
    menuMenu.y =-64;
    addChild(menuMenu);
    
    makeCallBack( UIdisplaylist,setOverlay ,overCall );
    menuMenu.addEventListener( "setOverlay", overCall );   
    
    makeCallBack( UIdisplaylist,setOverlay ,over2Call );
   colorMenu.addEventListener( "setOverlay", over2Call );   
    
    

    
    
    
   
    
     mainInfoBack.setSize( 64, 64,-32,-32);
     mainInfoBack.setUVauto(0,128,2048,2048);
  
    mainInfoBack.x =30;
    mainInfoBack.y =30;
     mainInfoBack.width =300;
     mainInfoBack.height=400;
     mainInfoBack.isDirty =true;
    mainInfoBack.visible =false;
    addChild( mainInfoBack); 
    
    colorHolder.setup();
    colorHolder.x =200;
    colorHolder.y =200;
    addChild(colorHolder);
    colorHolder.visible =false;    
    
    model->colorHolder = &colorHolder;
       model->colorMenu = &colorMenu;
    
}

void UIdisplaylist::setOverlay(npEvent *e)
{
    OverlayEvent * overE = (OverlayEvent *) e; 
    int type =  overE->overlayType;
    
    int tarW;
    int tarH;
    if (type == -1)
    {
        closeCurrentOverLay();
        return;
        
    }  
    currentOverLay = type;
  
   if (type == 1)
    {
        tarW =11*44+64;
        
        tarH =7*44 +64;
        
    }
    else if (type == 10)
    {
        tarW =200;
        tarH =150;
    
    }else  if (type == 11)
    {
        tarW =400;
        tarH =400;
        
    }else  if (type == 12)
    {
        tarW =1060;
        tarH =300;
        
    }else  if (type == 13)
    {
        tarW =1060;
        tarH =300;
        
    }else  if (type == 14)
    {
        tarW =1060;
        tarH =300;
        
    }else  if (type == 15)
    {
        tarW =1060;
        tarH =300;
        
    }
    
    if (  mainInfoBack.visible)
    {
     
    
    }else
    {
    
        mainInfoBack.visible =true;
        mainInfoBack.alpha =0.5;
        mainInfoBack.width =tarW -50;
        mainInfoBack.height =tarH -50;
    }
    npTween mijnTween;
    mijnTween.init(& mainInfoBack,NP_EASE_OUT_BACK,300,0);
    
    mijnTween.addProperty( &mainInfoBack.width,tarW );
    mijnTween.addProperty( &mainInfoBack.height,tarH );
      mijnTween.addProperty( &mainInfoBack.alpha,1.0 );
  
    
    
    makeCallBack(UIdisplaylist, openOverlayCompleet, openComp);
    mijnTween.addEventListener(NP_TWEEN_COMPLETE, openComp);
    npTweener::addTween(mijnTween);
    
    
    menuMenu.setOverlay(currentOverLay);
    colorMenu.setOverlay(currentOverLay);
}
void UIdisplaylist::openOverlayCompleet(npEvent *e)
{
   
    if ( currentOverLay  ==1)
    {
        colorHolder.visible  =true;
        colorHolder.isDirty =true;
        
    }

}
void UIdisplaylist::hideOverlayCompleet(npEvent *e)
{
    mainInfoBack.visible =false;
    mainInfoBack.isDirty =true;
}
void UIdisplaylist::closeCurrentOverLay()
{
    // hide overlayView
    if ( currentOverLay  ==1)
    {
       
        colorHolder.visible  =false;
            colorHolder.isDirty =true;
            
       
    
    }
   menuMenu.setOverlay(-1);
    colorMenu.setOverlay(-1);
    npTween mijnTween;
    int  tarW  =mainInfoBack.width -100;
    int tarH = mainInfoBack.height -100;
    
    mijnTween.init(&mainInfoBack,NP_EASE_OUT_SINE,150,0);
    
    mijnTween.addProperty( &mainInfoBack.width,tarW );
    mijnTween.addProperty( &mainInfoBack.height,tarH );
    mijnTween.addProperty( &mainInfoBack.alpha,0 );
    makeCallBack(UIdisplaylist, hideOverlayCompleet, openComp);
    mijnTween.addEventListener(NP_TWEEN_COMPLETE, openComp);
    npTweener::addTween(mijnTween);
    currentOverLay = -1;
}
void UIdisplaylist::setPaint(npEvent *e )
{

    if (paintBtn.isSelected) return;
    closeCurrentState();
    
    float delay =0;
    if (model->currentState == STATE_VIEW)delay=200;
    colorMenu.setSelected(true,delay);
    
    paintBtn.setSelected(true);
    model->setCurrentState(STATE_PAINT);

}

void UIdisplaylist::setRemove(npEvent *e )
{

    if (removeBtn.isSelected) return;
    closeCurrentState();
    removeBtn.setSelected(true);
    model->setCurrentState(STATE_REMOVE);



}

void UIdisplaylist::setAdd(npEvent *e )
{
    if (addBtn.isSelected) return;
    closeCurrentState();
    
    float delay =0;
    if (model->currentState == STATE_VIEW)delay=200;
    colorMenu.setSelected(true,delay);
    
    addBtn.setSelected(true);
    model->setCurrentState(STATE_ADD);

}
void UIdisplaylist::setRotate(npEvent *e )
{
    if (rotateBtn.isSelected) return;
    model->camera->touchPointer =NULL;/// clear pointer sometimes stays
    closeCurrentState();
    rotateBtn.setSelected(true);
    model->setCurrentState(STATE_ROTATE);

}
void UIdisplaylist::setMove(npEvent *e )
{
    if (moveBtn.isSelected) return;
    closeCurrentState();
    moveBtn.setSelected(true);
    model->setCurrentState(STATE_MOVE);

}

void UIdisplaylist::setView(npEvent *e )
{
    if (viewMenu.isSelected) return;
    closeCurrentState();
    
    float delay =0;
    if (model->currentState == STATE_ADD || model->currentState ==STATE_PAINT)delay=200;
    
    viewMenu.setSelected(true,delay);
    viewBtn.setSelected(true);
    if (model->camera->didMove)viewMenu.clear();
    
    model->setCurrentState(STATE_VIEW);
    
}


void UIdisplaylist::setMenu(npEvent *e )
{
    if (menuBtn.isSelected) return;
    closeCurrentState();
    menuMenu.setSelected(true);
    menuBtn.setSelected(true);
    model->setCurrentState(STATE_MENU);
    
}

void UIdisplaylist::closeCurrentState()
{
    
    
    
    
    int state =  model->currentState;
    if (state == STATE_ADD){ addBtn.setSelected(false);
        
        colorMenu.setSelected(false);
    }
    else if (state == STATE_REMOVE) removeBtn.setSelected(false);
    else if (state == STATE_PAINT) {
        paintBtn.setSelected(false);
        colorMenu.setSelected(false);
    }
    else if (state == STATE_MOVE) moveBtn.setSelected(false);
    else if (state == STATE_ROTATE) rotateBtn.setSelected(false);
    else if (state ==STATE_VIEW)
    { viewBtn.setSelected(false);
        viewMenu.setSelected(false);
        
    }
    else if (state ==STATE_MENU)
    { menuBtn.setSelected(false);
        menuMenu.setSelected(false);
    }
   // if(viewMenu.isSelected){viewMenu.setSelected(false);}
    if(currentOverLay != -1) closeCurrentOverLay();
    
    


}

void UIdisplaylist::setOrientation(int orientation)
{
    
    
    
    
    
    
    int startLeftX  =32+16+8;
    int leftSpace  = 64+8;
    int startLeftY  ;
    int startRightX  ;
    int centerX;
     int centerY;
    int bottom;
     //landscape
    if (orientation ==1)
    {
    
        startLeftY  = 768 -128;  
        startRightX  = 1024-startLeftX;
        centerX =1024/2;
         centerY =768/2;
        bottom =768+64;
    }
    // portrait
    else
    {
        startLeftY  = 1024 -128-64;
        startRightX  = 768-startLeftX;
        centerX =768/2;
          centerY =1024/2;
        bottom =1024+64;
    }

   mainInfoBack.x =centerX;
    mainInfoBack.y =centerY;
    mainInfoBack.isDirty =true;
    
    
    colorHolder.x =centerX;
    colorHolder.y =centerY;
    
    
    //
    // left
    //
    paintBtn.x =startLeftX;
    paintBtn.y =startLeftY;
    paintBtn.isDirty =true;
    
    startLeftY -= leftSpace;
    removeBtn.x =startLeftX;
    removeBtn.y =startLeftY ;
    removeBtn.isDirty =true;
    
    
    startLeftY -= leftSpace;
    addBtn.x =startLeftX;
    addBtn.y =startLeftY ;
    addBtn.isDirty =true;
    
    
    startLeftY -= leftSpace;
    rotateBtn.x =startLeftX;
    rotateBtn.y =startLeftY ;
    rotateBtn.isDirty =true;
    
    
    startLeftY -= leftSpace;
    moveBtn.x =startLeftX;
    moveBtn.y =startLeftY ;
    moveBtn.isDirty =true;
    
    
    startLeftY -= leftSpace;
    viewBtn.x =startLeftX;
    viewBtn.y =startLeftY ;
    viewBtn.isDirty =true;
       
    
    
    // right;
    menuBtn.x = startRightX;
    menuBtn.y =startLeftY ;
    menuBtn.isDirty =true;
    
    startLeftY += leftSpace;
    redoBtn.x = startRightX;
    redoBtn.y =startLeftY ;
    redoBtn.isDirty =true;
    
    
    startLeftY += leftSpace;
    undoBtn.x = startRightX;
    undoBtn.y =startLeftY ;
    undoBtn.isDirty =true;
    
    
     startLeftY += leftSpace +64*1.25;
    zoomHolder.x = startRightX;
    zoomHolder.y = startLeftY;
    zoomHolder.isDirty =true;
    
    
    viewMenu.x= centerX- (viewMenu.w/2.0);
    viewMenu.setBottom(bottom);
    
    
    colorMenu.x= centerX- (viewMenu.w/2.0);
    colorMenu.setBottom(bottom);
    
    
    menuMenu.x= centerX- (menuMenu.w/2.0);
    menuMenu.isDirty =true;
    
}