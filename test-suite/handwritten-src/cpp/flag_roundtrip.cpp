#include "flag_roundtrip.hpp"

using namespace testsuite;

access_flags FlagRoundtrip::roundtrip_access(access_flags flag) {
  return flag;
}

empty_flags FlagRoundtrip::roundtrip_empty(empty_flags flag) {
  return flag;
}

std::optional<access_flags> FlagRoundtrip::roundtrip_access_boxed(std::optional<access_flags> flag) {
  return flag;
}

std::optional<empty_flags> FlagRoundtrip::roundtrip_empty_boxed(std::optional<empty_flags> flag) {
  return flag;
}
