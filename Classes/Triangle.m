//
//  Triangle.m
//  LightGame
//
//  Created by William Lindmeier on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Triangle.h"
#import "GlobalFunctions.h"
#import "Vec3f.h"
#import "OALAudioController.h"

@implementation Triangle

@synthesize a, b, c, intersected, size, origin, rotation, singing, pitch;

- (id)initWithOrigin:(CGPoint)anOrigin size:(float)aSize rotation:(float)aRotation
{
	if(self = [super init]){
		self.origin = anOrigin;
		self.size = aSize;
		float halfSize = aSize * 0.5;		
		float height = sqrtf((aSize * aSize) - (halfSize*halfSize));
		a = [[Vec3f alloc] initWithX:anOrigin.x y:anOrigin.y + (height*0.66) z:0.0];
		b = [[Vec3f alloc] initWithX:anOrigin.x - halfSize y:anOrigin.y - (height*0.33) z:0.0];
		c = [[Vec3f alloc] initWithX:anOrigin.x + halfSize y:anOrigin.y - (height*0.33) z:0.0];
		self.rotation = aRotation;
		
		// Load a random sound and store the source
		NSString *audioFileName = [NSString stringWithFormat:@"%i", (arc4random() % 7) + 1];
		soundId = [[OALAudioController sharedAudioController] loadAudioNamed:audioFileName loops:NO];
		pitch = 1.0;
		
	}
	return self;
}

- (void)setRotation:(float)aRotation
{
	if(rotation != aRotation){
		float rotationDelta = aRotation - rotation;
		rotation = aRotation;
		
		float aX = self.a.x - self.origin.x;
		float aY = self.a.y - self.origin.y;

		float bX = self.b.x - self.origin.x;
		float bY = self.b.y - self.origin.y;

		float cX = self.c.x - self.origin.x;
		float cY = self.c.y - self.origin.y;
		
		CGPoint axy = rotateXYDegrees(aX, aY, rotationDelta);
		CGPoint bxy = rotateXYDegrees(bX, bY, rotationDelta);
		CGPoint cxy = rotateXYDegrees(cX, cY, rotationDelta);

		a.x = self.origin.x + axy.x;
		a.y = self.origin.y + axy.y;
		
		b.x = self.origin.x + bxy.x;
		b.y = self.origin.y + bxy.y;
	
		c.x = self.origin.x + cxy.x;
		c.y = self.origin.y + cxy.y;
	}
}

- (void)setOffsetX:(float)xOffset y:(float)yOffset
{
	
	//self.origin = CGPointMake(self.origin.x + xOffset, self.origin.y - yOffset);
	
	self.a.x = self.a.x + xOffset;
	self.a.y = self.a.y - yOffset;
	
	self.b.x = self.b.x + xOffset;
	self.b.y = self.b.y - yOffset;
	
	self.c.x = self.c.x + xOffset;
	self.c.y = self.c.y - yOffset;
	
}

- (void)setSinging:(BOOL)isSinging
{
	if(singing != isSinging){
		singing = isSinging;
		if(singing){
			[[OALAudioController sharedAudioController] playAudioWithId:soundId];
		}else{
			[[OALAudioController sharedAudioController] stopAudioWithId:soundId];
		}
	}	
}

- (void)setPitch:(float)aPitch
{
	pitch = aPitch;
	[[OALAudioController sharedAudioController] adjustPitch:aPitch forSoundId:soundId];
}

- (NSArray *)points
{
	return [NSArray arrayWithObjects:a, b, c, nil];
}

- (void)dealloc
{
	[a release];
	[b release];
	[c release];
	[super dealloc];
}

@end
