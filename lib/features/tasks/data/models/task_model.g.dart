
part of 'task_model.dart';


class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      description: fields[2] as String?,
      dueDate: fields[3] as DateTime?,
      priority: fields[4] as TaskPriorityModel,
      tags: (fields[5] as List).cast<String>(),
      isCompleted: fields[6] as bool,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityModelAdapter extends TypeAdapter<TaskPriorityModel> {
  @override
  final int typeId = 1;

  @override
  TaskPriorityModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriorityModel.low;
      case 1:
        return TaskPriorityModel.medium;
      case 2:
        return TaskPriorityModel.high;
      default:
        return TaskPriorityModel.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriorityModel obj) {
    switch (obj) {
      case TaskPriorityModel.low:
        writer.writeByte(0);
        break;
      case TaskPriorityModel.medium:
        writer.writeByte(1);
        break;
      case TaskPriorityModel.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
