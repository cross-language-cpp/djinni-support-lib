using System.Runtime.InteropServices;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class MockRecordTest
    {
        [Test]
        public void TestMockConstants()
        {
            Constants mock = new MockConstants();
            Assert.That(() => mock.ToString(), Is.EqualTo("MockConstants{}"), "The ToString() method should be overridden.");
        }
    }

    public class MockConstants : Constants
    {
        public override string ToString()
        {
            return "MockConstants{}";
        }
    }
}