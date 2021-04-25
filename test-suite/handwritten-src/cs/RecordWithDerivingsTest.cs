using System;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class RecordWithDerivingsTest
    {
        [SetUp]
        public void SetUp()
        {
            _record1 = new RecordWithDerivings(1, 2, 3, 4, 5.0f, 6.0, new DateTime(1970, 1, 1), "String8");
            _record1A = new RecordWithDerivings(1, 2, 3, 4, 5.0f, 6.0, new DateTime(1970, 1, 1), "String8");
            _record2 = new RecordWithDerivings(1, 2, 3, 4, 5.0f, 6.0, new DateTime(1970, 1, 1), "String888");
            _record3 = new RecordWithDerivings(111, 2, 3, 4, 5.0f, 6.0, new DateTime(1970, 1, 1), "String8");

            _nestedRecord1 = new RecordWithNestedDerivings(1, _record1);
            _nestedRecord1A = new RecordWithNestedDerivings(1, _record1A);
            _nestedRecord2 = new RecordWithNestedDerivings(1, _record2);
        }

        private RecordWithDerivings _record1;
        private RecordWithDerivings _record1A;
        private RecordWithDerivings _record2;
        private RecordWithDerivings _record3;

        private RecordWithNestedDerivings _nestedRecord1;
        private RecordWithNestedDerivings _nestedRecord1A;
        private RecordWithNestedDerivings _nestedRecord2;

        [Test]
        public void TestNestedRecordEq()
        {
            Assert.That(() => _nestedRecord1, Is.EqualTo(_nestedRecord1A));
            Assert.That(() => _nestedRecord1, Is.Not.EqualTo(_nestedRecord2));
            Assert.That(() => _nestedRecord2, Is.Not.EqualTo(_nestedRecord1));
        }

        [Test]
        public void TestNestedRecordOrd()
        {
            Assert.That(() => _nestedRecord1.CompareTo(_nestedRecord1A), Is.Zero);
            Assert.That(() => _nestedRecord1.CompareTo(_nestedRecord2), Is.LessThan(0));
            Assert.That(() => _nestedRecord2.CompareTo(_nestedRecord1), Is.GreaterThan(0));
        }

        [Test]
        public void TestRecordEq()
        {
            Assert.That(() => _record1, Is.EqualTo(_record1A));
            Assert.That(() => _record1A, Is.EqualTo(_record1));
            Assert.That(() => _record1, Is.Not.EqualTo(_record2));
            Assert.That(() => _record2, Is.Not.EqualTo(_record1));
            Assert.That(() => _record1, Is.Not.EqualTo(_record3));
            Assert.That(() => _record3, Is.Not.EqualTo(_record1));
            Assert.That(() => _record2, Is.Not.EqualTo(_record3));
            Assert.That(() => _record3, Is.Not.EqualTo(_record2));
        }

        [Test]
        public void TestRecordOrd()
        {
            Assert.That(() => _record1.CompareTo(_record1A), Is.Zero);
            Assert.That(() => _record1A.CompareTo(_record1), Is.Zero);
            Assert.That(() => _record1.CompareTo(_record2), Is.LessThan(0));
            Assert.That(() => _record2.CompareTo(_record1), Is.GreaterThan(0));
            Assert.That(() => _record1.CompareTo(_record3), Is.LessThan(0));
            Assert.That(() => _record3.CompareTo(_record1), Is.GreaterThan(0));
            Assert.That(() => _record2.CompareTo(_record3), Is.LessThan(0));
            Assert.That(() => _record3.CompareTo(_record2), Is.GreaterThan(0));
        }
    }
}