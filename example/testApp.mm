#include "testApp.h"

int canvasW = 2000;	//these define where the camera can pan to
int canvasH = 3000;

void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	ofxiPhoneSetOrientation( (ofOrientation)ofxiPhoneGetOrientation() );	
	// initialize the accelerometer
	ofxAccelerometer.setup();	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	ofBackground(0);
	ofEnableAlphaBlending();
	ofSetCircleResolution(32);
	
	cam.setZoom(1.0f);
	cam.setMinZoom(0.5f);
	cam.setMaxZoom(5.0f);
	cam.setScreenSize( ofGetWidth(), ofGetHeight() ); //tell the system how large is out screen
	float gap = 100;
	cam.setViewportConstrain( ofVec3f(-gap, -gap), ofVec3f(canvasW + gap, canvasH + gap)); //limit browseable area, in world units
	cam.lookAt( ofVec2f(canvasW/2, canvasH/2) );
	grid.create();
}


void testApp::update(){
	touchAnims.update(0.016f);
}


void testApp::draw(){
		
	cam.apply(); //put all our drawing under the ofxPanZoom effect
	
		//draw grid
		grid.draw();
		touchAnims.draw();
	
		//draw space constrains		
		glColor4f(1, 1, 1, 0.1);
		ofRect(0, 0, canvasW, canvasH);
		
		glColor4f(1, 0, 0, 1);
		ofNoFill();
		ofSetLineWidth(2);
		ofRect(0, 0, canvasW, canvasH);
		ofFill();
		ofSetLineWidth(1);
	
		//canvas center cross
		glColor4f(1, 1, 1, 1);
		ofPushMatrix();
			ofTranslate(canvasW/2, canvasH/2);
			ofLine(0, -60, 0, 60);
			ofLine( -60, 0, 60,0);
		ofPopMatrix();
	
	cam.reset();	//back to normal ofSetupScreen() projection
	
	cam.drawDebug(); //see info on ofxPanZoom status
	
	glColor4f(1,1,1,1);
	ofDrawBitmapString("fps: " + ofToString( ofGetFrameRate(), 1 ),  10, ofGetHeight() - 10 );	
}


void testApp::touchDown(ofTouchEventArgs &touch){

	cam.touchDown(touch); //fw event to cam
	
	ofVec3f p =  cam.screenToWorld( ofVec3f( touch.x, touch.y) );	//convert touch (in screen units) to world units
	touchAnims.addTouch( p.x, p.y ); 
}


void testApp::touchMoved(ofTouchEventArgs &touch){
	cam.touchMoved(touch); //fw event to cam
}


void testApp::touchUp(ofTouchEventArgs &touch){
	cam.touchUp(touch);	//fw event to cam
}


void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	cam.touchDoubleTap(touch); //fw event to cam
	cam.setZoom(1.0f);	//reset zoom
	cam.lookAt( ofVec2f(canvasW/2, canvasH/2) ); //reset position
}


void testApp::touchCancelled(ofTouchEventArgs& args){

}


void testApp::deviceOrientationChanged(int newOrientation){
	//not sure whiy this is inverted in horizontal modes, disabling for now
	//ofxiPhoneSetOrientation( (ofOrientation)newOrientation);
	//cam.setScreenSize(ofGetWidth(), ofGetHeight());
};
