using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class WcharTest
    {
        private const string Str1 = "some string with unicode \u0000, \u263A, \uD83D\uDCA9 symbols";
        private const string Str2 = "another string with unicode \u263B, \uD83D\uDCA8 symbols";

        [Test]
        public void Test()
        {
            Assert.That(WcharTestHelpers.GetRecord().S, Is.EqualTo(Str1));
            Assert.That(WcharTestHelpers.GetString(), Is.EqualTo(Str2));
            Assert.That(WcharTestHelpers.CheckString(Str2), Is.True);
            Assert.That(WcharTestHelpers.CheckRecord(new WcharTestRec(Str1)), Is.True);
        }
    }
}