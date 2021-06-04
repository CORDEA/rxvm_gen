import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:rxvm_gen/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder rxVmBuilder(BuilderOptions options) =>
    SharedPartBuilder([RxVmGenerator()], 'rxvm');

class RxVmGenerator extends GeneratorForAnnotation<RxViewModel> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return 'void dispose() {}';
  }
}
