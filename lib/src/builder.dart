import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:rxvm_gen/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder rxVmBuilder(BuilderOptions options) =>
    SharedPartBuilder([RxVmGenerator(), SubjectGenerator()], 'rxvm');

class RxVmGenerator extends GeneratorForAnnotation<RxViewModel> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element.kind != ElementKind.CLASS) {
      return;
    }
    final visitor = _VisibleSubjectVisitor();
    element.visitChildren(visitor);
    var ext = 'extension _${element.name}Ext on ${element.name} {\n';

    return ext + '\n}';
  }
}

class _VisibleSubjectVisitor extends SimpleElementVisitor {
  final List<FieldElement> elements = [];

  @override
  visitFieldElement(FieldElement element) {
    final annotated = element.metadata
        .any((m) => m.element?.enclosingElement?.name == 'VisibleSubject');
    if (annotated) {
      elements.add(element);
    }
    return super.visitFieldElement(element);
  }
}

class SubjectGenerator extends GeneratorForAnnotation<VisibleSubject> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return '';
  }
}
