// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from derivings.djinni

#import "DBRecordWithNestedDerivings+Private.h"
#import "DBRecordWithDerivings+Private.h"
#import "DJIMarshal+Private.h"
#include <cassert>

namespace djinni_generated {

auto RecordWithNestedDerivings::toCpp(ObjcType obj) -> CppType
{
    assert(obj);
    return {::djinni::I32::toCpp(obj.key),
            ::djinni_generated::RecordWithDerivings::toCpp(obj.rec)};
}

auto RecordWithNestedDerivings::fromCpp(const CppType& cpp) -> ObjcType
{
    return [[DBRecordWithNestedDerivings alloc] initWithKey:(::djinni::I32::fromCpp(cpp.key))
                                                        rec:(::djinni_generated::RecordWithDerivings::fromCpp(cpp.rec))];
}

}  // namespace djinni_generated
