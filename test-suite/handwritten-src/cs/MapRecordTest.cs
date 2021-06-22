using System.Collections.Generic;
using System.Linq;
using Djinni.TestSuite;
using NUnit.Framework;

namespace Djinni.Testing.Unit
{
    [TestFixture]
    public class MapRecordTest
    {
        [Test]
        public void TestCppMapToCsMap()
        {
            CheckCsMap(TestHelpers.GetMap());
        }

        [Test]
        public void TestEmptyCppMapToCsMap()
        {
            Assert.That(TestHelpers.GetEmptyMap, Is.Empty);
        }

        [Test]
        public void TestCppMapListToCsMapList()
        {
            var mapListRecord = TestHelpers.GetMapListRecord();
            var mapList = mapListRecord.MapList;
            Assert.That(() => mapList, Has.Count.EqualTo(1));
            CheckCsMap(mapList.First());
        }

        [Test]
        public void TestCsMapToCppMap()
        {
            Assert.That(() => TestHelpers.CheckMap(CsMap), Is.True);
        }

        [Test]
        public void TestEmptyCsMapToCppMap()
        {
            Assert.That(() => TestHelpers.CheckEmptyMap(new Dictionary<string, long>()), Is.True);
        }

        [Test]
        public void TestCsMapListToCppMapList()
        {
            var mapList = new List<Dictionary<string, long>>{ CsMap };
            Assert.That(() => TestHelpers.CheckMapListRecord(new MapListRecord(mapList)), Is.True);
        }

        private static Dictionary<string, long> CsMap => new Dictionary<string, long>
        {
            {"String1", 1},
            {"String2", 2},
            {"String3", 3}
        };

        private void CheckCsMap(Dictionary<string, long> map)
        {
            var expectedMap = new Dictionary<string, long>
            {
                {"String1", 1},
                {"String2", 2},
                {"String3", 3}
            };
            Assert.That(() => map, Is.EquivalentTo(expectedMap));
        }
    }
}