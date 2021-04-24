#pragma once

#include "foo_enum_interface.hpp"
#include "color.hpp"
#include <memory>
#include <optional>

namespace testsuite {

class FooEnumInterfaceImpl final: public FooEnumInterface {
public:

    virtual void set_enum(color some_color) override;
    virtual color get_enum() override;

    virtual void set_optional_enum(std::optional<color> some_color) override;
    virtual std::optional<color> get_optional_enum() override;

    static std::shared_ptr<FooEnumInterface> create();
private:
    color m_color;
    std::optional<color> m_optional_color;
};

} // namespace testsuite
