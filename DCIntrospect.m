//
//  DCIntrospect.m
//
//  Created by Domestic Cat on 29/04/11.
//

#import "DCIntrospect.h"
#import <objc/runtime.h>

//#if RUN_ICRAWL_TEST
#import "ICrawlTestController.h"
//#endif

@implementation DCIntrospect

#pragma mark -
#pragma mark Helper Methods

- (void)logPropertiesForObject:(id)object withViewController:(NSString *)viewControllerName andStateIndex:(int)stateIndex {
	
	Class objectClass = [object class];
	NSString *className = [NSString stringWithFormat:@"%@", objectClass];
	
	unsigned int count;
	objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    size_t buf_size = 1024;
    char *buffer = malloc(buf_size);
	NSMutableString *outputString = [NSMutableString stringWithFormat:@"\n\n** %@ details in ViewController: %@ for State: S%i are:\n\n", className, viewControllerName, stateIndex];
	[outputString appendFormat:@"\n\n** %@", className];
	
	// list the class heirachy
	Class superClass = [objectClass superclass];
	while (superClass) {
		
		[outputString appendFormat:@" : %@", superClass];
		superClass = [superClass superclass];
	}
	
	[outputString appendString:@" ** \n\n"];
	
	if ([objectClass isSubclassOfClass:UIView.class]) {
		
		UIView *view = (UIView *)object;
		// print out generic uiview properties
		[outputString appendString:@"  ** UIView properties **\n"];
		[outputString appendFormat:@"    tag: %i\n", view.tag];
		[outputString appendFormat:@"    frame: %@ | ", NSStringFromCGRect(view.frame)];
		[outputString appendFormat:@"bounds: %@ | ", NSStringFromCGRect(view.bounds)];
		[outputString appendFormat:@"center: %@\n", NSStringFromCGPoint(view.center)];
		[outputString appendFormat:@"    transform: %@\n", NSStringFromCGAffineTransform(view.transform)];
		[outputString appendFormat:@"    autoresizingMask: %@\n", [self describeProperty:@"autoresizingMask" value:[NSNumber numberWithInt:view.autoresizingMask]]];
		[outputString appendFormat:@"    autoresizesSubviews: %@\n", (view.autoresizesSubviews) ? @"YES" : @"NO"];
		[outputString appendFormat:@"    contentMode: %@ | ", [self describeProperty:@"contentMode" value:[NSNumber numberWithInt:view.contentMode]]];
		[outputString appendFormat:@"contentStretch: %@\n", NSStringFromCGRect(view.contentStretch)];
		[outputString appendFormat:@"    backgroundColor: %@\n", [self describeColor:view.backgroundColor]];
		[outputString appendFormat:@"    alpha: %.2f | ", view.alpha];
		[outputString appendFormat:@"opaque: %@ | ", (view.opaque) ? @"YES" : @"NO"];
		[outputString appendFormat:@"hidden: %@ | ", (view.hidden) ? @"YES" : @"NO"];
		[outputString appendFormat:@"clips to bounds: %@ | ", (view.clipsToBounds) ? @"YES" : @"NO"];
		[outputString appendFormat:@"clearsContextBeforeDrawing: %@\n", (view.clearsContextBeforeDrawing) ? @"YES" : @"NO"];
		[outputString appendFormat:@"    userInteractionEnabled: %@ | ", (view.userInteractionEnabled) ? @"YES" : @"NO"];
		[outputString appendFormat:@"multipleTouchEnabled: %@\n", (view.multipleTouchEnabled) ? @"YES" : @"NO"];
		[outputString appendFormat:@"    gestureRecognizers: %@\n", (view.gestureRecognizers) ? [view.gestureRecognizers description] : @"nil"];
		
		// warn about accessibility inspector if the element count is zero
		NSUInteger count = [object accessibilityElementCount];
		if (count == 0)
			[outputString appendString:@"\n\n** Warning: Logging accessibility properties requires Accessibility Inspector: Settings.app -> General -> Accessibility\n"];
		
		[outputString appendString:@"\n"];
		[outputString appendFormat:@"  ** %@ Accessibility Properties **\n", className];
		[outputString appendFormat:@"	accessibilityElement enabled: %@ \n", ([object isAccessibilityElement]) ? @"YES" : @"NO"];
		[outputString appendFormat:@"	label: %@\n", [object accessibilityLabel]];
		[outputString appendFormat:@"	hint: %@\n", [object accessibilityHint]];
		[outputString appendFormat:@"	traits: %@\n", [self describeProperty:@"accessibilityTraits" value:[NSNumber numberWithUnsignedLongLong:[object accessibilityTraits]]]];
		[outputString appendFormat:@"	value: %@\n", [object accessibilityValue]];
		[outputString appendFormat:@"	frame: %@\n", NSStringFromCGRect([object accessibilityFrame])];
		[outputString appendString:@"\n"];
		
	}
	
	[outputString appendFormat:@"  ** %@ properties **\n", objectClass];
	
	if (objectClass == UIScrollView.class || objectClass == UIButton.class) {
		[outputString appendString:@"    Logging properties not currently supported for this view.\n"];
	}
	else
	{
		for (unsigned int i = 0; i < count; ++i)
		{
			// get the property name and selector name
			NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
			
			SEL sel = NSSelectorFromString(propertyName);
			if ([object respondsToSelector:sel])
			{
				NSString *propertyDescription;
				@try
				{
					// get the return object and type for the selector
					NSString *returnType = [NSString stringWithUTF8String:[[object methodSignatureForSelector:sel] methodReturnType]];
					id returnObject = [object valueForKey:propertyName];
					if ([returnType isEqualToString:@"c"])
						returnObject = [NSNumber numberWithBool:[returnObject intValue] != 0];
					
					propertyDescription = [self describeProperty:propertyName value:returnObject];
				}
				@catch (NSException *exception)
				{
					// Non KVC compliant properties, see also +workaroundUITextInputTraitsPropertiesBug
					propertyDescription = @"N/A";
				}
				[outputString appendFormat:@"    %@: %@\n", propertyName, propertyDescription];
			}
		}
	}
	
	// list targets if there are any
	if ([object respondsToSelector:@selector(allTargets)])
	{
		[outputString appendString:@"\n  ** Targets & Actions **\n"];
		UIControl *control = (UIControl *)object;
		UIControlEvents controlEvents = [control allControlEvents];
		NSSet *allTargets = [control allTargets];
		[allTargets enumerateObjectsUsingBlock:^(id target, BOOL *stop)
		 {
			 NSArray *actions = [control actionsForTarget:target forControlEvent:controlEvents];
			 [actions enumerateObjectsUsingBlock:^(id action, NSUInteger idx, BOOL *stop2)
			  {
				  [outputString appendFormat:@"    target: %@ action: %@\n", target, action];
			  }];
		 }];
	}
	
	[outputString appendString:@"\n"];
	//#if RUN_ICRAWL_TEST
	ICrawlTestController *iCrawlTestController = [[ICrawlTestController alloc] init];
	// Create paths to output txt file
	[iCrawlTestController outputUIElementsFile:outputString];
	//#endif
	free(properties);
    free(buffer);
}


#pragma mark Description Methods

- (NSString *)describeProperty:(NSString *)propertyName value:(id)value
{
	if ([propertyName isEqualToString:@"contentMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIViewContentModeScaleToFill";
			case 1: return @"UIViewContentModeScaleAspectFit";
			case 2: return @"UIViewContentModeScaleAspectFill";
			case 3: return @"UIViewContentModeRedraw";
			case 4: return @"UIViewContentModeCenter";
			case 5: return @"UIViewContentModeTop";
			case 6: return @"UIViewContentModeBottom";
			case 7: return @"UIViewContentModeLeft";
			case 8: return @"UIViewContentModeRight";
			case 9: return @"UIViewContentModeTopLeft";
			case 10: return @"UIViewContentModeTopRight";
			case 11: return @"UIViewContentModeBottomLeft";
			case 12: return @"UIViewContentModeBottomRight";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"textAlignment"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextAlignmentLeft";
			case 1: return @"UITextAlignmentCenter";
			case 2: return @"UITextAlignmentRight";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"lineBreakMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UILineBreakModeWordWrap";
			case 1: return @"UILineBreakModeCharacterWrap";
			case 2: return @"UILineBreakModeClip";
			case 3: return @"UILineBreakModeHeadTruncation";
			case 4: return @"UILineBreakModeTailTruncation";
			case 5: return @"UILineBreakModeMiddleTruncation";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"activityIndicatorViewStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIActivityIndicatorViewStyleWhiteLarge";
			case 1: return @"UIActivityIndicatorViewStyleWhite";
			case 2: return @"UIActivityIndicatorViewStyleGray";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"returnKeyType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIReturnKeyDefault";
			case 1: return @"UIReturnKeyGo";
			case 2: return @"UIReturnKeyGoogle";
			case 3: return @"UIReturnKeyJoin";
			case 4: return @"UIReturnKeyNext";
			case 5: return @"UIReturnKeyRoute";
			case 6: return @"UIReturnKeySearch";
			case 7: return @"UIReturnKeySend";
			case 8: return @"UIReturnKeyYahoo";
			case 9: return @"UIReturnKeyDone";
			case 10: return @"UIReturnKeyEmergencyCall";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"keyboardAppearance"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardAppearanceDefault";
			case 1: return @"UIKeyboardAppearanceAlert";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"keyboardType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardTypeDefault";
			case 1: return @"UIKeyboardTypeASCIICapable";
			case 2: return @"UIKeyboardTypeNumbersAndPunctuation";
			case 3: return @"UIKeyboardTypeURL";
			case 4: return @"UIKeyboardTypeNumberPad";
			case 5: return @"UIKeyboardTypePhonePad";
			case 6: return @"UIKeyboardTypeNamePhonePad";
			case 7: return @"UIKeyboardTypeEmailAddress";
			case 8: return @"UIKeyboardTypeDecimalPad";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"autocorrectionType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardTypeDefault";
			case 1: return @"UITextAutocorrectionTypeDefault";
			case 2: return @"UITextAutocorrectionTypeNo";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"autocapitalizationType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextAutocapitalizationTypeNone";
			case 1: return @"UITextAutocapitalizationTypeWords";
			case 2: return @"UITextAutocapitalizationTypeSentences";
			case 3: return @"UITextAutocapitalizationTypeAllCharacters";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"clearButtonMode"] ||
			 [propertyName isEqualToString:@"leftViewMode"] ||
			 [propertyName isEqualToString:@"rightViewMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextFieldViewModeNever";
			case 1: return @"UITextFieldViewModeWhileEditing";
			case 2: return @"UITextFieldViewModeUnlessEditing";
			case 3: return @"UITextFieldViewModeAlways";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"borderStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextBorderStyleNone";
			case 1: return @"UITextBorderStyleLine";
			case 2: return @"UITextBorderStyleBezel";
			case 3: return @"UITextBorderStyleRoundedRect";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"progressViewStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIProgressViewStyleBar";
			case 1: return @"UIProgressViewStyleDefault";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"separatorStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellSeparatorStyleNone";
			case 1: return @"UITableViewCellSeparatorStyleSingleLine";
			case 2: return @"UITableViewCellSeparatorStyleSingleLineEtched";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"selectionStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellSelectionStyleNone";
			case 1: return @"UITableViewCellSelectionStyleBlue";
			case 2: return @"UITableViewCellSelectionStyleGray";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"editingStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellEditingStyleNone";
			case 1: return @"UITableViewCellEditingStyleDelete";
			case 2: return @"UITableViewCellEditingStyleInsert";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"accessoryType"] || [propertyName isEqualToString:@"editingAccessoryType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellAccessoryNone";
			case 1: return @"UITableViewCellAccessoryDisclosureIndicator";
			case 2: return @"UITableViewCellAccessoryDetailDisclosureButton";
			case 3: return @"UITableViewCellAccessoryCheckmark";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"style"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewStylePlain";
			case 1: return @"UITableViewStyleGrouped";
			default: return nil;
		}
		
	}
	else if ([propertyName isEqualToString:@"autoresizingMask"])
	{
		UIViewAutoresizing mask = [value intValue];
		NSMutableString *string = [NSMutableString string];
		if (mask & UIViewAutoresizingFlexibleLeftMargin)
			[string appendString:@"UIViewAutoresizingFlexibleLeftMargin"];
		if (mask & UIViewAutoresizingFlexibleRightMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleRightMargin"];
		if (mask & UIViewAutoresizingFlexibleTopMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleTopMargin"];
		if (mask & UIViewAutoresizingFlexibleBottomMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleBottomMargin"];
		if (mask & UIViewAutoresizingFlexibleWidth)
			[string appendString:@" | UIViewAutoresizingFlexibleWidthMargin"];
		if (mask & UIViewAutoresizingFlexibleHeight)
			[string appendString:@" | UIViewAutoresizingFlexibleHeightMargin"];
		
		if ([string hasPrefix:@" | "])
			[string replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
		
		return ([string length] > 0) ? string : @"UIViewAutoresizingNone";
	}
	else if ([propertyName isEqualToString:@"accessibilityTraits"])
	{
		UIAccessibilityTraits traits = [value intValue];
		NSMutableString *string = [NSMutableString string];
		if (traits & UIAccessibilityTraitButton)
			[string appendString:@"UIAccessibilityTraitButton"];
		if (traits & UIAccessibilityTraitLink)
			[string appendString:@" | UIAccessibilityTraitLink"];
		if (traits & UIAccessibilityTraitSearchField)
			[string appendString:@" | UIAccessibilityTraitSearchField"];
		if (traits & UIAccessibilityTraitImage)
			[string appendString:@" | UIAccessibilityTraitImage"];
		if (traits & UIAccessibilityTraitSelected)
			[string appendString:@" | UIAccessibilityTraitSelected"];
		if (traits & UIAccessibilityTraitPlaysSound)
			[string appendString:@" | UIAccessibilityTraitPlaysSound"];
		if (traits & UIAccessibilityTraitKeyboardKey)
			[string appendString:@" | UIAccessibilityTraitKeyboardKey"];
		if (traits & UIAccessibilityTraitStaticText)
			[string appendString:@" | UIAccessibilityTraitStaticText"];
		if (traits & UIAccessibilityTraitSummaryElement)
			[string appendString:@" | UIAccessibilityTraitSummaryElement"];
		if (traits & UIAccessibilityTraitNotEnabled)
			[string appendString:@" | UIAccessibilityTraitNotEnabled"];
		if (traits & UIAccessibilityTraitUpdatesFrequently)
			[string appendString:@" | UIAccessibilityTraitUpdatesFrequently"];
		if (traits & UIAccessibilityTraitStartsMediaSession)
			[string appendString:@" | UIAccessibilityTraitStartsMediaSession"];
		if (traits & UIAccessibilityTraitAdjustable)
			[string appendFormat:@" | UIAccessibilityTraitAdjustable"];
		if ([string hasPrefix:@" | "])
			[string replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
		
		return ([string length] > 0) ? string : @"UIAccessibilityTraitNone";
	}
	
	if ([value isKindOfClass:[NSValue class]])
	{
		// print out the return for each value depending on type
		NSString *type = [NSString stringWithUTF8String:[value objCType]];
		if ([type isEqualToString:@"c"])
		{
			return ([value boolValue]) ? @"YES" : @"NO";
		}
		else if ([type isEqualToString:@"{CGSize=ff}"])
		{
			CGSize size = [value CGSizeValue];
			return CGSizeEqualToSize(size, CGSizeZero) ? @"CGSizeZero" : NSStringFromCGSize(size);
		}
		else if ([type isEqualToString:@"{UIEdgeInsets=ffff}"])
		{
			UIEdgeInsets edgeInsets = [value UIEdgeInsetsValue];
			return UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero) ? @"UIEdgeInsetsZero" : NSStringFromUIEdgeInsets(edgeInsets);
		}
	}
	else if ([value isKindOfClass:[UIColor class]])
	{
		UIColor *color = (UIColor *)value;
		return [self describeColor:color];
	}
	else if ([value isKindOfClass:[UIFont class]])
	{
		UIFont *font = (UIFont *)value;
		return [NSString stringWithFormat:@"%.0fpx %@", font.pointSize, font.fontName];
	}
	
	return value ? [value description] : @"nil";
}

- (NSString *)describeColor:(UIColor *)color
{
	if (!color)
		return @"nil";
	
	NSString *returnString = nil;
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelRGB)
	{
		const CGFloat *components = CGColorGetComponents(color.CGColor);
		returnString = [NSString stringWithFormat:@"R: %.0f G: %.0f B: %.0f A: %.2f",
						components[0] * 256,
						components[1] * 256,
						components[2] * 256,
						components[3]];
	}
	else
	{
		returnString = [NSString stringWithFormat:@"%@ (incompatible color space)", color];
	}
	return returnString;
}

@end
