// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from primtypes.djinni

#import "DBAssortedPrimitives.h"


@implementation DBAssortedPrimitives

- (nonnull instancetype)initWithB:(BOOL)b
                            eight:(int8_t)eight
                          sixteen:(int16_t)sixteen
                        thirtytwo:(int32_t)thirtytwo
                        sixtyfour:(int64_t)sixtyfour
                       fthirtytwo:(float)fthirtytwo
                       fsixtyfour:(double)fsixtyfour
                               oB:(nullable NSNumber *)oB
                           oEight:(nullable NSNumber *)oEight
                         oSixteen:(nullable NSNumber *)oSixteen
                       oThirtytwo:(nullable NSNumber *)oThirtytwo
                       oSixtyfour:(nullable NSNumber *)oSixtyfour
                      oFthirtytwo:(nullable NSNumber *)oFthirtytwo
                      oFsixtyfour:(nullable NSNumber *)oFsixtyfour
{
    if (self = [super init]) {
        _b = b;
        _eight = eight;
        _sixteen = sixteen;
        _thirtytwo = thirtytwo;
        _sixtyfour = sixtyfour;
        _fthirtytwo = fthirtytwo;
        _fsixtyfour = fsixtyfour;
        _oB = oB;
        _oEight = oEight;
        _oSixteen = oSixteen;
        _oThirtytwo = oThirtytwo;
        _oSixtyfour = oSixtyfour;
        _oFthirtytwo = oFthirtytwo;
        _oFsixtyfour = oFsixtyfour;
    }
    return self;
}

+ (nonnull instancetype)assortedPrimitivesWithB:(BOOL)b
                                          eight:(int8_t)eight
                                        sixteen:(int16_t)sixteen
                                      thirtytwo:(int32_t)thirtytwo
                                      sixtyfour:(int64_t)sixtyfour
                                     fthirtytwo:(float)fthirtytwo
                                     fsixtyfour:(double)fsixtyfour
                                             oB:(nullable NSNumber *)oB
                                         oEight:(nullable NSNumber *)oEight
                                       oSixteen:(nullable NSNumber *)oSixteen
                                     oThirtytwo:(nullable NSNumber *)oThirtytwo
                                     oSixtyfour:(nullable NSNumber *)oSixtyfour
                                    oFthirtytwo:(nullable NSNumber *)oFthirtytwo
                                    oFsixtyfour:(nullable NSNumber *)oFsixtyfour
{
    return [(DBAssortedPrimitives*)[self alloc] initWithB:b
                                                    eight:eight
                                                  sixteen:sixteen
                                                thirtytwo:thirtytwo
                                                sixtyfour:sixtyfour
                                               fthirtytwo:fthirtytwo
                                               fsixtyfour:fsixtyfour
                                                       oB:oB
                                                   oEight:oEight
                                                 oSixteen:oSixteen
                                               oThirtytwo:oThirtytwo
                                               oSixtyfour:oSixtyfour
                                              oFthirtytwo:oFthirtytwo
                                              oFsixtyfour:oFsixtyfour];
}

- (BOOL)isEqual:(id)other
{
    if (![other isKindOfClass:[DBAssortedPrimitives class]]) {
        return NO;
    }
    DBAssortedPrimitives *typedOther = (DBAssortedPrimitives *)other;
    return self.b == typedOther.b &&
            self.eight == typedOther.eight &&
            self.sixteen == typedOther.sixteen &&
            self.thirtytwo == typedOther.thirtytwo &&
            self.sixtyfour == typedOther.sixtyfour &&
            self.fthirtytwo == typedOther.fthirtytwo &&
            self.fsixtyfour == typedOther.fsixtyfour &&
            ((self.oB == nil && typedOther.oB == nil) || (self.oB != nil && [self.oB isEqual:typedOther.oB])) &&
            ((self.oEight == nil && typedOther.oEight == nil) || (self.oEight != nil && [self.oEight isEqual:typedOther.oEight])) &&
            ((self.oSixteen == nil && typedOther.oSixteen == nil) || (self.oSixteen != nil && [self.oSixteen isEqual:typedOther.oSixteen])) &&
            ((self.oThirtytwo == nil && typedOther.oThirtytwo == nil) || (self.oThirtytwo != nil && [self.oThirtytwo isEqual:typedOther.oThirtytwo])) &&
            ((self.oSixtyfour == nil && typedOther.oSixtyfour == nil) || (self.oSixtyfour != nil && [self.oSixtyfour isEqual:typedOther.oSixtyfour])) &&
            ((self.oFthirtytwo == nil && typedOther.oFthirtytwo == nil) || (self.oFthirtytwo != nil && [self.oFthirtytwo isEqual:typedOther.oFthirtytwo])) &&
            ((self.oFsixtyfour == nil && typedOther.oFsixtyfour == nil) || (self.oFsixtyfour != nil && [self.oFsixtyfour isEqual:typedOther.oFsixtyfour]));
}

- (NSUInteger)hash
{
    return NSStringFromClass([self class]).hash ^
            (NSUInteger)self.b ^
            (NSUInteger)self.eight ^
            (NSUInteger)self.sixteen ^
            (NSUInteger)self.thirtytwo ^
            (NSUInteger)self.sixtyfour ^
            (NSUInteger)self.fthirtytwo ^
            (NSUInteger)self.fsixtyfour ^
            self.oB.hash ^
            self.oEight.hash ^
            self.oSixteen.hash ^
            self.oThirtytwo.hash ^
            self.oSixtyfour.hash ^
            self.oFthirtytwo.hash ^
            self.oFsixtyfour.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p b:%@ eight:%@ sixteen:%@ thirtytwo:%@ sixtyfour:%@ fthirtytwo:%@ fsixtyfour:%@ oB:%@ oEight:%@ oSixteen:%@ oThirtytwo:%@ oSixtyfour:%@ oFthirtytwo:%@ oFsixtyfour:%@>", self.class, (void *)self, @(self.b), @(self.eight), @(self.sixteen), @(self.thirtytwo), @(self.sixtyfour), @(self.fthirtytwo), @(self.fsixtyfour), self.oB, self.oEight, self.oSixteen, self.oThirtytwo, self.oSixtyfour, self.oFthirtytwo, self.oFsixtyfour];
}

@end
