using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class PrimitivesTest
    {
        [Test]
        public void TestPrimitives()
        {
            var p = new AssortedPrimitives(true, 123, 20000, 1000000000, 1234567890123456789L, 1.23f, 1.23d,
                true, 123, 20000, 1000000000, 1234567890123456789L, 1.23f, 1.23d);
            Assert.That(() => TestHelpers.AssortedPrimitivesId(p), Is.EqualTo(p));
        }
    }
}