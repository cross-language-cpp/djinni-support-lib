using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class CppExceptionTest
    {
        private CppException _cppInterface;

        [SetUp]
        public void SetUp()
        {
            _cppInterface = CppException.Get();
        }

        [Test]
        public void TestCppException()
        {
            Assert.That(() => _cppInterface.ThrowAnException(), Throws.Exception.Message.EqualTo("Exception Thrown"));
        }
    }
}