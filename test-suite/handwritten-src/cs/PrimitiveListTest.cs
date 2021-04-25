using System.Collections.Generic;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class PrimitiveListTest
    {
        [SetUp]
        public void SetUp()
        {
            _primitiveList = new PrimitiveList(new List<long> {1, 2, 3});
        }

        private PrimitiveList _primitiveList;

        [Test]
        public void TestCsPrimitiveListToCpp()
        {
            Assert.That(() => TestHelpers.CheckPrimitiveList(_primitiveList), Is.True);
        }

        [Test]
        public void TestCppPrimitiveListToCs()
        {
            var converted = TestHelpers.GetPrimitiveList();
            Assert.That(() => converted.List, Is.EquivalentTo(_primitiveList.List));
        }

        [Test]
        public void TestBinary()
        {
            byte[] b = {1, 2, 3};
            Assert.That(() => TestHelpers.IdBinary(b), Is.EqualTo(b));
        }
    }
}