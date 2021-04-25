#pragma once

#include <chrono>

namespace djinni {

// This is only a helper, trying to use it as member/param will fail
template<class Ratio>
struct DurationPeriod;

using Duration_h = DurationPeriod<std::ratio<3600>>;
using Duration_min = DurationPeriod<std::ratio<60>>;
using Duration_s = DurationPeriod<std::ratio<1>>;
using Duration_ms = DurationPeriod<std::milli>;
using Duration_us = DurationPeriod<std::micro>;
using Duration_ns = DurationPeriod<std::nano>;

template<class Rep, class Period>
struct Duration;

template<class Rep, class Ratio>
struct Duration<Rep, DurationPeriod<Ratio>> {
    using CppType = std::chrono::duration<typename Rep::CppType, Ratio>;
    using CsType = System::TimeSpan;

    using Ticks = std::chrono::duration<int64_t, std::ratio<1, 10000000>>;

    static CppType ToCpp(CsType dt) {
        return std::chrono::duration_cast<CppType>(Ticks(dt.Ticks));
    }
    static CsType FromCpp(CppType dt) {
        auto ms = std::chrono::duration_cast<Ticks>(dt).count();
        return System::TimeSpan::FromTicks(ms);
    }
};

}