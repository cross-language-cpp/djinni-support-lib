using System.Collections.Generic;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class NestedCollectionTest
    {
        private NestedCollection _nestedCollection;

        [SetUp]
        public void SetUp()
        {
            _nestedCollection = new NestedCollection(new List<HashSet<string>>
            {
                new HashSet<string> { "String1", "String2" },
                new HashSet<string> { "StringA", "StringB" }
            });
        }

        [Test]
        public void TestCppNestedRecordToCsNestedCollection()
        {
            var converted = TestHelpers.GetNestedCollection();
            Assert.That(() => converted.SetList, Is.EquivalentTo(_nestedCollection.SetList));
        }

        [Test]
        public void TestCsNestedRecordToCppNestedCollection()
        {
            Assert.That(() => TestHelpers.CheckNestedCollection(_nestedCollection), Is.True);
        }
    }
}