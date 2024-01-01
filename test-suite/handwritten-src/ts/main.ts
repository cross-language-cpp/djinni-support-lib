import {DjinniModule} from "@djinni_support/DjinniModule"
import {runTests, allTests} from "./testutils"
import "./ClientInterfaceTest"
import "./ConstantsTest"
import "./CppExceptionTest"
import "./DurationTest"
import "./EnumTest"
import "./MapRecordTest"
import "./NestedCollectionTest"
import "./PrimitiveListTest"
import "./PrimitivesTest"
import "./SetRecordTest"
import "./TokenTest"
import "./WcharTest"

declare function Module(): Promise<DjinniModule>;
Module().then(m => {
    runTests(m, allTests);
})
