using Djinni.TestSuite;

namespace Djinni.Testing.Unit
{
    public class ClientInterfaceImpl : ClientInterface
    {
        public override ClientReturnedRecord GetRecord(long recordId, string utf8String, string misc)
        {
            return new ClientReturnedRecord(recordId, utf8String, misc);
        }

        public override double IdentifierCheck(byte[] data, int r, long jret)
        {
            throw new System.NotImplementedException();
        }

        public override string ReturnStr()
        {
            return "test";
        }

        public override string MethTakingInterface(ClientInterface i)
        {
            return i != null ? i.ReturnStr() : "";
        }

        public override string MethTakingOptionalInterface(ClientInterface i)
        {
            return i != null ? i.ReturnStr() : "";
        }
    }
}