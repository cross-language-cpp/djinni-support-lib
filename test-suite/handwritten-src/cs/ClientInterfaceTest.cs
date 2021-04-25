using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class ClientInterfaceTest
    {
        private ClientInterface _csClientInterface;

        [SetUp]
        public void SetUp()
        {
            _csClientInterface = new ClientInterfaceImpl();
        }

        [Test]
        public void TestClientReturn()
        {
            Assert.That(() => TestHelpers.CheckClientInterfaceAscii(_csClientInterface), Throws.Nothing);
        }

        [Test]
        public void TestClientReturnUtf8()
        {
            Assert.That(() => TestHelpers.CheckClientInterfaceNonascii(_csClientInterface), Throws.Nothing);
        }

        [Test]
        public void TestClientInterfaceArgs()
        {
            Assert.That(() => TestHelpers.CheckClientInterfaceArgs(_csClientInterface), Throws.Nothing);
        }

        [Test]
        public void TestReverseClientInterfaceArgs()
        {
            var i = ReverseClientInterface.Create();

            Assert.That(() => i.MethTakingInterface(i), Is.EqualTo("test"));
            Assert.That(() => i.MethTakingOptionalInterface(i), Is.EqualTo("test"));
        }
    }
}