#import <Foundation/Foundation.h>
void advance(NSMutableArray *lines,bool stuckp) {
	NSMutableArray *conv = [[NSMutableArray alloc] init];
	NSUInteger size = [lines count];
	NSUInteger j;
	int a, b, c;
	for (NSUInteger i = 0; i < size; ++i) {
		a = 0;
		b = [[[lines objectAtIndex:i] objectAtIndex:0] intValue];
		c = [[[lines objectAtIndex:i] objectAtIndex:1] intValue];
		[conv addObject:[NSNumber numberWithInt:(b+c)]];
		for (j = 1; j < size - 1; ++j) {
			a = b;
			b = c;
			c = [[[lines objectAtIndex:i]
				    objectAtIndex:(j+1)] intValue];
			[conv addObject:
				      [NSNumber numberWithInt:(a+b+c)]];
		}
		[conv addObject:[NSNumber numberWithInt:(b+c)]];
	}
	for (NSUInteger i = 0; i < size; ++i) {
		a = 0;
		b = [[conv objectAtIndex:i] intValue];
		c = [[conv objectAtIndex:i+size] intValue];
		[conv replaceObjectAtIndex:i
				withObject:
			      [NSNumber numberWithInt:(b+c)]];
		for (j = 1; j < size - 1; ++j) {
			a = b;
			b = c;
			c = [[conv objectAtIndex:i+size*(j+1)] intValue];
			[conv replaceObjectAtIndex:(i+size*j)
					withObject:
				      [NSNumber numberWithInt:(a+b+c)]];
		}
		[conv replaceObjectAtIndex:i+size*j
				withObject:
			      [NSNumber numberWithInt:(b+c)]];
	}
	for (NSUInteger i = 0; i < size*size; ++i) {
		NSUInteger row = i/size;
		NSUInteger col = i%size;
		int b = [[[lines objectAtIndex:row] objectAtIndex:col]
				intValue];
		int c = [[conv objectAtIndex:i] intValue];
		if (b) {
			b = b && ((c == 3) || (c == 4));
		} else {
			b = b || (c == 3);
		}
		b = b || (stuckp
			  && (row == 0 || row == size - 1)
			  && (col == 0 || col == size - 1));
		[[lines objectAtIndex:row]
			replaceObjectAtIndex:col
				  withObject:[NSNumber numberWithInt:b]];
	}
	[conv release];
}

int main(void) {
	NSString *filePath = @"18.txt";
	NSError *error;
	NSString *fileContents
		= [[NSString
			  stringWithContentsOfFile:filePath
					  encoding:NSUTF8StringEncoding
					     error:&error]
			  stringByTrimmingCharactersInSet:
				  [NSCharacterSet newlineCharacterSet]];
	NSMutableArray *lines
		= [[fileContents componentsSeparatedByString:@"\n"]
			  mutableCopy];
	NSUInteger size = [lines count];
	for (NSUInteger i = 0; i < size; ++i) {
		NSMutableArray *x = [[NSMutableArray alloc] init];
		NSString *s = [lines objectAtIndex:i];
		for (NSUInteger j = 0; j < size; ++j) {
			bool b = [s characterAtIndex:j] == '#';
			[x addObject:[NSNumber numberWithBool:b]];
		}
		[lines replaceObjectAtIndex:i withObject:x];
	}
	NSMutableArray *lc
		= [[NSMutableArray alloc] initWithCapacity:size];
	for (NSUInteger i = 0; i < size; ++i) {
		[lc addObject:[[lines objectAtIndex:i] mutableCopy]];
	}
	for (NSUInteger i = 0; i < 100; ++i) advance(lines, NO);
	NSUInteger partA = 0;
	for (id object in lines) {
		for (id n in object) {
			partA += [n intValue];
		}
	}
	[[lc objectAtIndex:0]
		replaceObjectAtIndex:0
			  withObject:[NSNumber numberWithInt:1]];
	[[lc objectAtIndex:0]
		replaceObjectAtIndex:size-1
			  withObject:[NSNumber numberWithInt:1]];
	[[lc objectAtIndex:size-1]
		replaceObjectAtIndex:0
			  withObject:[NSNumber numberWithInt:1]];
	[[lc objectAtIndex:size-1]
		replaceObjectAtIndex:size-1
			  withObject:[NSNumber numberWithInt:1]];
	NSUInteger partB = 0;
	for (NSUInteger i = 0; i < 100; ++i) advance(lc, YES);
	for (id object in lc) {
		for (id n in object) {
			partB += [n intValue];
		}
	}
	printf("%lu %lu\n",partA,partB);
	/* release */
	for (id object in lines) {
		[object release];
	}
	[lines release];
	for (id object in lc) {
		[object release];
	}
	[lc release];
	return 0;
}
