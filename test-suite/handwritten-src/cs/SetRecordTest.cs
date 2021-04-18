using System.Collections.Generic;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class SetRecordTest
    {
        [Test]
        public void TestCppSetToCsSet()
        {
            var setRecord = TestHelpers.GetSetRecord();
            var set = setRecord.Set;
            Assert.That(() => set, Is.EquivalentTo(new HashSet<string> {"StringA", "StringB", "StringC"}));
        }

        [Test]
        public void TestCsSetToCppSet()
        {
            var sSet = new HashSet<string> {"StringA", "StringB", "StringC"};
            var iSet = new HashSet<int>();
            var setRecord = new SetRecord(sSet, iSet);
            Assert.That(() => TestHelpers.CheckSetRecord(setRecord), Is.True);
        }
    }
}