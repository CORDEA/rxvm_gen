import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
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
    if (element.kind != ElementKind.CLASS) {
      return;
    }
    final visitor = _VisibleSubjectVisitor();
    element.visitChildren(visitor);
    var ext = 'extension _${element.name}Ext on ${element.name} {\n';

    for (final e in visitor.elements) {
      final type = e.type;
      if (type is! ParameterizedType) {
        continue;
      }
      if (type.element?.name != 'BehaviorSubject') {
        continue;
      }
      final childType = type.typeArguments.first;
      final typeSuffix =
          childType.nullabilitySuffix == NullabilitySuffix.question ? '?' : '';
      final typeName = childType.element?.name;
      if (typeName == null) {
        continue;
      }
      ext +=
          'ValueStream<$typeName$typeSuffix> get ${e.name.substring(1)} => ${e.name};\n';
    }

    ext += 'void _dispose() {\n';
    for (final e in visitor.elements) {
      final type = e.type.element;
      if (type == null || type is! ClassElement) {
        continue;
      }
      if (isSink(type)) {
        ext += '${e.name}.close();\n';
      }
    }
    ext += '}\n';

    return ext + '\n}';
  }

  bool isSink(Element e) {
    if (e is! ClassElement) {
      return false;
    }
    if (e.name == 'Sink') {
      return true;
    }
    return e.allSupertypes.any((element) => isSink(element.element));
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
