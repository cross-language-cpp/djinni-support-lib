using System.Collections.Generic;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class EnumTest
    {
        [Test]
        public void TestEnumKey()
        {
            var m = new Dictionary<Color, string>
            {
                {Color.Red, "red"},
                {Color.Orange, "orange"},
                {Color.Yellow, "yellow"},
                {Color.Green, "green"},
                {Color.Blue, "blue"},
                {Color.Indigo, "indigo"},
                {Color.Violet, "violet"}
            };
            Assert.That(() => TestHelpers.CheckEnumMap(m), Throws.Nothing);
        }

        [Test]
        public void TestAccessFlagRoundtrip()
        {
            AccessFlags[] flags =
            {
                AccessFlags.Nobody,
                AccessFlags.Everybody,
                AccessFlags.OwnerRead,
                AccessFlags.OwnerRead | AccessFlags.OwnerWrite,
                AccessFlags.OwnerRead | AccessFlags.OwnerWrite | AccessFlags.OwnerExecute
            };

            foreach (var flag in flags)
            {
                Assert.That(FlagRoundtrip.RoundtripAccess(flag), Is.EqualTo(flag));
                Assert.That(FlagRoundtrip.RoundtripAccessBoxed(flag), Is.EqualTo(flag));
            }
            Assert.That(FlagRoundtrip.RoundtripAccessBoxed(null), Is.Null);
        }

        [Test]
        public void TestEmptyFlagRoundtrip()
        {
            EmptyFlags[] flags =
            {
                EmptyFlags.None,
                EmptyFlags.All
            };

            foreach (var flag in flags)
            {
                Assert.That(FlagRoundtrip.RoundtripEmpty(flag), Is.EqualTo(flag));
                Assert.That(FlagRoundtrip.RoundtripEmptyBoxed(flag), Is.EqualTo(flag));
            }
            Assert.That(FlagRoundtrip.RoundtripEmptyBoxed(null), Is.Null);
        }
    }
}