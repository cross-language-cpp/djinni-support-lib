#ifndef JSON_EXTENSION_h
#define JSON_EXTENSION_h

#include <optional>
#include <chrono>

#include <nlohmann/json.hpp>


namespace nlohmann {

    template <typename T>
    struct adl_serializer<std::optional<T>> {
        static void to_json(json& j, const std::optional<T>& opt) {
            if (opt == std::nullopt) {
                j = nullptr;
            } else {
              j = *opt;
            }
        }

        static void from_json(const json& j, std::optional<T>& opt) {
            if (j.is_null()) {
                opt = std::nullopt;
            } else {
                opt = j.get<T>();
            }
        }
    };
    
    template <>
    struct adl_serializer<std::chrono::system_clock::time_point> {
        static void to_json(json& j, const std::chrono::system_clock::time_point & opt) {
            // if (opt == std::nullopt) {
            //     j = nullptr;
            // } else {
            //   j = *opt;
            // }
        }

        static void from_json(const json& j, std::chrono::system_clock::time_point & opt) {
            // if (j.is_null()) {
            //     opt = std::nullopt;
            // } else {
            //     opt = j.get<T>();
            // }
        }
    };
}
#endif /* JSON_EXTENSION_h */

