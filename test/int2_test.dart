import 'package:coalfront_logic_2/coalfront_logic_2.dart';
import 'package:coalfront_logic_2/src/models/common/int2.dart';
import 'package:coalfront_logic_2/src/models/common/rotation_steps.dart';
import 'package:test/test.dart';

void main() {
  test('rotation', () {
    Int2 i = Int2(2, 1);

    expect(Int2(2, 1), i.rotateAround0(RotationSteps.deg0));
    expect(Int2(1, -2), i.rotateAround0(RotationSteps.deg90));
    expect(Int2(-2, -1), i.rotateAround0(RotationSteps.deg180));
    expect(Int2(-1, 2), i.rotateAround0(RotationSteps.deg270));
  });
}
