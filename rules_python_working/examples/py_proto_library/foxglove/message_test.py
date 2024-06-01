import sys
import unittest
print(sys.path)
from another_proto import message_pb2
import foxglove
from foxglove.Pose_pb2 import Pose as FoxglovePosePb

class TestCase(unittest.TestCase):
    def test_message(self):
        got = message_pb2.TestMessage(
            index = 5,
        )
        self.assertIsNotNone(got)
        print(FoxglovePosePb)
        print("GGGGG")
        # assert len("GG") > 4

if __name__ == "__main__":
    sys.exit(unittest.main())
