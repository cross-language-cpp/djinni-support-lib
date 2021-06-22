using System;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class DurationTest
    {
        [Test]
        public void Test()
        {
            Assert.That(() => TestDuration.HoursString(TimeSpan.FromHours(1)), Is.EqualTo("1"));
            Assert.That(() => TestDuration.MinutesString(TimeSpan.FromMinutes(1)), Is.EqualTo("1"));
            Assert.That(() => TestDuration.SecondsString(TimeSpan.FromSeconds(1)), Is.EqualTo("1"));
            Assert.That(() => TestDuration.MillisString(TimeSpan.FromMilliseconds(1)), Is.EqualTo("1"));
            Assert.That(() => TestDuration.MicrosString(TimeSpan.FromTicks(10)), Is.EqualTo("1")); // 1 tick = 100 nanoseconds
            Assert.That(() => TestDuration.NanosString(TimeSpan.FromTicks(1)), Is.EqualTo("100")); // 1 tick = 100 nanoseconds

            Assert.That(() => TestDuration.Hours(1).Hours, Is.EqualTo(1));
            Assert.That(() => TestDuration.Minutes(1).Minutes, Is.EqualTo(1));
            Assert.That(() => TestDuration.Seconds(1).Seconds, Is.EqualTo(1));
            Assert.That(() => TestDuration.Millis(1).Milliseconds, Is.EqualTo(1));
            Assert.That(() => TestDuration.Micros(1).Ticks, Is.EqualTo(10)); // 1 tick = 100 nanoseconds
            Assert.That(() => TestDuration.Nanos(100).Ticks, Is.EqualTo(1)); // 1 tick = 100 nanoseconds

            Assert.That(() => TestDuration.Hoursf(1.5).TotalMinutes, Is.EqualTo(90));
            Assert.That(() => TestDuration.Minutesf(1.5).TotalSeconds, Is.EqualTo(90));
            Assert.That(() => TestDuration.Secondsf(1.5).TotalMilliseconds, Is.EqualTo(1500));
            Assert.That(() => TestDuration.Millisf(1.5).Ticks, Is.EqualTo(1500 * 10));
            Assert.That(() => TestDuration.Microsf(1.5).Ticks, Is.EqualTo(15)); // 1 tick = 100 nanoseconds
            Assert.That(() => TestDuration.Nanosf(100.5).Ticks, Is.EqualTo(1)); // 1 tick = 100 nanoseconds

            Assert.That(() => TestDuration.Box(1)?.Seconds, Is.EqualTo(1));
            Assert.That(() => TestDuration.Box(-1), Is.Null);

            Assert.That(() => TestDuration.Unbox(TimeSpan.FromSeconds(1)), Is.EqualTo(1));
            Assert.That(() => TestDuration.Unbox(null), Is.EqualTo(-1));
        }
    }
}